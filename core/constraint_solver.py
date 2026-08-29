"""受限、可校验的组合约束求解器。

规则使用 Python 风格的布尔表达式，并额外支持单个 ``=>`` 蕴含：

    table_kind == 'TEMP' => storage != 'COLUMN'

允许的运算只有 ``==``、``!=``、``in``、``not in``、``and``、``or``、
``not`` 和括号。规则会在加载时解析；未知变量、非法语法和求值错误都
是规格错误，绝不再静默放行。
"""
from __future__ import annotations

import ast
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple


class ConstraintError(ValueError):
    """所有约束相关错误的基类。"""


class ConstraintSyntaxError(ConstraintError):
    """规则不属于受支持的约束 DSL。"""


class UnknownConstraintVariableError(ConstraintError):
    """规则引用了当前规格没有声明的变量。"""


class ConstraintEvaluationError(ConstraintError):
    """完整组合无法对规则求值。"""


_UNKNOWN = object()


def _attribute_name(node: ast.AST) -> Optional[str]:
    """把 ``fixture.table_kind`` AST 节点恢复为字典中的点分键。"""
    if isinstance(node, ast.Name):
        return node.id
    if isinstance(node, ast.Attribute):
        parent = _attribute_name(node.value)
        return f"{parent}.{node.attr}" if parent else None
    return None


def _tri_not(value: Any) -> Any:
    return _UNKNOWN if value is _UNKNOWN else not bool(value)


def _tri_and(values: Iterable[Any]) -> Any:
    seen_unknown = False
    for value in values:
        if value is False:
            return False
        if value is _UNKNOWN:
            seen_unknown = True
    return _UNKNOWN if seen_unknown else True


def _tri_or(values: Iterable[Any]) -> Any:
    seen_unknown = False
    for value in values:
        if value is True:
            return True
        if value is _UNKNOWN:
            seen_unknown = True
    return _UNKNOWN if seen_unknown else False


@dataclass(frozen=True)
class ConstraintRule:
    """一条已经编译并受限校验的约束规则。"""

    raw_rule: str
    _tree: ast.Expression
    _premise: Optional[ast.Expression]
    references: Set[str]

    def __init__(self, rule_str: str):
        raw_rule = rule_str.strip()
        if not raw_rule:
            raise ConstraintSyntaxError("约束规则不能为空")

        expression, premise_expression = self._normalise_implication(raw_rule)
        try:
            tree = ast.parse(expression, mode="eval")
        except SyntaxError as exc:
            raise ConstraintSyntaxError(f"无法解析约束 '{raw_rule}': {exc.msg}") from exc

        premise_tree = None
        if premise_expression is not None:
            try:
                premise_tree = ast.parse(premise_expression, mode="eval")
            except SyntaxError as exc:  # 理论上已由完整表达式捕获，仍保留明确错误。
                raise ConstraintSyntaxError(f"无法解析蕴含前提 '{raw_rule}': {exc.msg}") from exc

        references: Set[str] = set()
        self._validate_node(tree.body, references)
        if premise_tree is not None:
            self._validate_node(premise_tree.body, set())

        object.__setattr__(self, "raw_rule", raw_rule)
        object.__setattr__(self, "_tree", tree)
        object.__setattr__(self, "_premise", premise_tree)
        object.__setattr__(self, "references", references)

    @staticmethod
    def _normalise_implication(rule: str) -> Tuple[str, Optional[str]]:
        count = rule.count("=>")
        if count > 1:
            raise ConstraintSyntaxError(f"约束只支持一个 =>: '{rule}'")
        if count == 0:
            return rule, None
        premise, conclusion = (part.strip() for part in rule.split("=>", 1))
        if not premise or not conclusion:
            raise ConstraintSyntaxError(f"=> 两侧都必须有表达式: '{rule}'")
        return f"(not ({premise})) or ({conclusion})", premise

    @classmethod
    def _validate_node(cls, node: ast.AST, references: Set[str]) -> None:
        """验证 AST 只包含 DSL 明确允许的节点。"""
        if isinstance(node, ast.BoolOp):
            if not isinstance(node.op, (ast.And, ast.Or)):
                raise ConstraintSyntaxError("仅支持 and/or")
            for child in node.values:
                cls._validate_node(child, references)
            return
        if isinstance(node, ast.UnaryOp):
            if not isinstance(node.op, ast.Not):
                raise ConstraintSyntaxError("仅支持 not")
            cls._validate_node(node.operand, references)
            return
        if isinstance(node, ast.Compare):
            cls._validate_node(node.left, references)
            for op, comparator in zip(node.ops, node.comparators):
                if not isinstance(op, (ast.Eq, ast.NotEq, ast.In, ast.NotIn)):
                    raise ConstraintSyntaxError("仅支持 ==、!=、in、not in")
                cls._validate_node(comparator, references)
            return
        if isinstance(node, (ast.List, ast.Tuple, ast.Set)):
            for child in node.elts:
                cls._validate_node(child, references)
            return
        if isinstance(node, ast.Constant):
            if not isinstance(node.value, (str, int, float, bool, type(None))):
                raise ConstraintSyntaxError("常量类型不受支持")
            return
        if isinstance(node, ast.Name):
            references.add(node.id)
            return
        if isinstance(node, ast.Attribute):
            name = _attribute_name(node)
            if not name:
                raise ConstraintSyntaxError("仅支持简单点分变量")
            references.add(name)
            return
        raise ConstraintSyntaxError(
            f"不支持的约束语法: {node.__class__.__name__}；"
            "不要使用函数调用、contains 或任意 Python 表达式"
        )

    def validate_references(self, available_names: Iterable[str]) -> None:
        available = set(available_names)
        missing = sorted(self.references - available)
        if missing:
            raise UnknownConstraintVariableError(
                f"约束 '{self.raw_rule}' 引用了未声明变量: {', '.join(missing)}"
            )

    def _evaluate_node(self, node: ast.AST, combo: Dict[str, Any], partial: bool) -> Any:
        if isinstance(node, ast.Constant):
            return node.value
        if isinstance(node, (ast.Name, ast.Attribute)):
            name = _attribute_name(node)
            if name in combo:
                return combo[name]
            if partial:
                return _UNKNOWN
            raise ConstraintEvaluationError(
                f"规则 '{self.raw_rule}' 缺少变量 '{name}' 的取值"
            )
        if isinstance(node, (ast.List, ast.Tuple, ast.Set)):
            values = [self._evaluate_node(child, combo, partial) for child in node.elts]
            return _UNKNOWN if _UNKNOWN in values else values
        if isinstance(node, ast.UnaryOp):
            return _tri_not(self._evaluate_node(node.operand, combo, partial))
        if isinstance(node, ast.BoolOp):
            values = [self._evaluate_node(child, combo, partial) for child in node.values]
            return _tri_and(values) if isinstance(node.op, ast.And) else _tri_or(values)
        if isinstance(node, ast.Compare):
            left = self._evaluate_node(node.left, combo, partial)
            result_values = []
            for op, comparator in zip(node.ops, node.comparators):
                right = self._evaluate_node(comparator, combo, partial)
                if left is _UNKNOWN or right is _UNKNOWN:
                    result_values.append(_UNKNOWN)
                elif isinstance(op, ast.Eq):
                    result_values.append(left == right)
                elif isinstance(op, ast.NotEq):
                    result_values.append(left != right)
                elif isinstance(op, ast.In):
                    result_values.append(left in right)
                elif isinstance(op, ast.NotIn):
                    result_values.append(left not in right)
                else:  # 已在加载期验证，仅为类型收窄。
                    raise ConstraintSyntaxError("不支持的比较运算")
                left = right
            return _tri_and(result_values)
        raise ConstraintSyntaxError(f"不支持的约束节点: {node.__class__.__name__}")

    def evaluate(self, combo: Dict[str, Any]) -> bool:
        """对完整组合求值；缺少变量即为规格错误。"""
        result = self._evaluate_node(self._tree.body, combo, partial=False)
        if result is _UNKNOWN:
            raise ConstraintEvaluationError(f"规则 '{self.raw_rule}' 未得到确定结果")
        return bool(result)

    def can_still_be_satisfied(self, partial_combo: Dict[str, Any]) -> bool:
        """三值求值：仅当当前部分赋值已确定违反规则时才剪枝。"""
        return self._evaluate_node(self._tree.body, partial_combo, partial=True) is not False

    def is_triggered(self, combo: Dict[str, Any]) -> bool:
        """蕴含规则的前提是否真正成立，用于真实规则覆盖统计。"""
        if self._premise is None:
            return self.evaluate(combo)
        result = self._evaluate_node(self._premise.body, combo, partial=False)
        return result is True


class ConstraintSolver:
    """严格约束集合，供规格加载、可行性搜索和最终用例校验共同使用。"""

    def __init__(self, rules: Optional[List[str]] = None):
        self.rules: List[ConstraintRule] = [ConstraintRule(rule) for rule in (rules or []) if rule.strip()]

    def add_rule(self, rule_str: str) -> None:
        if rule_str.strip():
            self.rules.append(ConstraintRule(rule_str))

    def validate_references(self, available_names: Iterable[str]) -> None:
        for rule in self.rules:
            rule.validate_references(available_names)

    def is_possible(self, partial_combo: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        for rule in self.rules:
            if not rule.can_still_be_satisfied(partial_combo):
                return False, rule.raw_rule
        return True, None

    def is_valid(self, combo: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        for rule in self.rules:
            if not rule.evaluate(combo):
                return False, rule.raw_rule
        return True, None

    def filter_combos(self, combos: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        valid_combos = []
        for combo in combos:
            ok, _ = self.is_valid(combo)
            if ok:
                valid_combos.append(combo)
        return valid_combos
