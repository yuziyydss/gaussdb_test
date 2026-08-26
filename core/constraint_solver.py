"""约束满足求解器 (Constraint Satisfaction Problem Solver)：

解析并执行因子定义中的复杂参数依赖与互斥规则 (如 P => Q 一阶逻辑)，
在参数组合生成前进行前置可行域剪枝，取代低效脆弱的人工 exclusions 列表。
"""
import ast
import re
from typing import List, Dict, Any, Tuple, Optional, Callable


class ConstraintRule:
    """单个约束规则，支持 P => Q (蕴含) 或标准 Python 布尔表达式。"""

    def __init__(self, rule_str: str):
        self.raw_rule = rule_str.strip()
        self.compiled_expr = self._compile(self.raw_rule)

    def _compile(self, rule: str) -> str:
        """将包含 => 蕴含符号及点分嵌套变量的规则转换为可执行的 Python 逻辑表达式。"""
        # 1. 转换蕴含符号 => (A => B 等价于 (not (A)) or (B))
        expr = rule
        if "=>" in expr:
            parts = expr.split("=>", 1)
            premise = parts[0].strip()
            conclusion = parts[1].strip()
            expr = f"(not ({premise})) or ({conclusion})"

        # 2. 将点分嵌套变量 (如 fixture.col_type) 转为合法标识符 (fixture__col_type)
        expr = re.sub(r"(?<=[a-zA-Z0-9_])\.([a-zA-Z_][a-zA-Z0-9_]*)", r"__\1", expr)
        return expr

    def evaluate(self, combo: Dict[str, Any]) -> bool:
        """在给定的参数字典上下文中评估约束是否满足。"""
        # 构建安全评估作用域 (同时提供原始 key 与点分替换 key)
        eval_scope = {}
        for k, v in combo.items():
            val_str = str(v) if v is not None else ""
            eval_scope[k] = val_str
            eval_scope[k.replace(".", "__")] = val_str

        try:
            # 使用 eval 进行布尔求值 (限制内置函数保障安全)
            result = eval(self.compiled_expr, {"__builtins__": None, "len": len, "str": str}, eval_scope)
            return bool(result)
        except NameError:
            # 规则中引用的参数若当前组合不存在，视为默认通过 (不适用当前上下文)
            return True
        except Exception:
            # 语法解析或类型异常时保守放行
            return True


class ConstraintSolver:
    """因子参数组合约束求解与智能剪枝器。"""

    def __init__(self, rules: List[str] = None):
        self.rules: List[ConstraintRule] = [ConstraintRule(r) for r in (rules or []) if r.strip()]

    def add_rule(self, rule_str: str):
        if rule_str.strip():
            self.rules.append(ConstraintRule(rule_str))

    def is_valid(self, combo: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        """检查单个参数组合是否满足所有约束规则。"""
        for rule in self.rules:
            if not rule.evaluate(combo):
                return False, rule.raw_rule
        return True, None

    def filter_combos(self, combos: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """对候选组合列表进行全量约束求解与无效空间剪枝。"""
        if not self.rules:
            return combos
        valid_combos = []
        for c in combos:
            ok, _ = self.is_valid(c)
            if ok:
                valid_combos.append(c)
        return valid_combos
