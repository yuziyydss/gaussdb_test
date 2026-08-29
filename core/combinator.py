"""组合测试算法：完整组合、等价类组合与约束感知 Pairwise。"""
from __future__ import annotations

from dataclasses import dataclass, field
from itertools import combinations, product
from typing import Dict, Iterable, List, Optional, Set, Tuple

from .constraint_solver import ConstraintSolver


Pair = Tuple[str, str, str, str]


class PairwiseGenerationError(RuntimeError):
    """无法在已配置搜索预算内证明 Pairwise 覆盖。"""


@dataclass
class PairwiseResult:
    """约束感知 Pairwise 的可审计产物。"""

    suite: List[Dict[str, str]]
    feasible_pairs: Set[Pair]
    covered_pairs: Set[Pair]
    missing_pairs: Set[Pair]
    infeasible_pair_reasons: Dict[str, int] = field(default_factory=dict)
    search_nodes: int = 0


def generate_cartesian(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """全笛卡尔积。调用方须自行决定是否允许该规模。"""
    if not param_values:
        return []
    keys = list(param_values.keys())
    value_lists = [param_values[key] for key in keys]
    return [dict(zip(keys, combo)) for combo in product(*value_lists)]


def generate_equivalence(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """在传入值已是等价类代表值的前提下做完整组合。"""
    return generate_cartesian(param_values)


def _canonical_pair(left_name: str, left_value: str, right_name: str, right_value: str,
                    positions: Dict[str, int]) -> Pair:
    if positions[left_name] < positions[right_name]:
        return left_name, left_value, right_name, right_value
    return right_name, right_value, left_name, left_value


def _pairs_for_combo(combo: Dict[str, str], parameters: List[str],
                     positions: Dict[str, int]) -> Set[Pair]:
    return {
        _canonical_pair(left, combo[left], right, combo[right], positions)
        for left, right in combinations(parameters, 2)
    }


def _combo_key(combo: Dict[str, str], parameters: Iterable[str]) -> Tuple[Tuple[str, str], ...]:
    return tuple((name, str(combo[name])) for name in parameters)


def generate_constraint_aware_pairwise(
    param_values: Dict[str, List[str]],
    solver: Optional[ConstraintSolver] = None,
    high_priority_dimensions: Optional[List[List[str]]] = None,
    max_search_nodes: int = 200_000,
) -> PairwiseResult:
    """生成并证明覆盖所有可行 pair。

    该实现不会先构造完整笛卡尔积再过滤。它逐个检查一个参数对是否存在
    满足全部约束的完整补全，收集这些补全作为候选，再以贪心 set-cover
    选择测试用例。只要函数返回，``missing_pairs`` 必为零；搜索预算不足
    会明确报错，而不是输出不可信的部分覆盖结果。
    """
    if not param_values:
        return PairwiseResult([], set(), set(), set())

    parameters = list(param_values.keys())
    if any(not values for values in param_values.values()):
        empty = [name for name, values in param_values.items() if not values]
        raise PairwiseGenerationError(f"参数没有可选值: {', '.join(empty)}")

    solver = solver or ConstraintSolver()
    solver.validate_references(parameters)
    positions = {name: index for index, name in enumerate(parameters)}
    search_nodes = 0

    def find_completion(fixed: Dict[str, str]) -> Tuple[Optional[Dict[str, str]], Optional[str]]:
        """查找一个合法完整补全；返回 ``None`` 即代表该部分赋值不可行。"""
        nonlocal search_nodes
        possible, reason = solver.is_possible(fixed)
        if not possible:
            return None, reason

        remaining = [name for name in parameters if name not in fixed]
        # 小值域优先通常能更快发现不可行分支，同时不改变最终结果的确定性。
        remaining.sort(key=lambda name: (len(param_values[name]), positions[name]))

        def visit(index: int, current: Dict[str, str]) -> Tuple[Optional[Dict[str, str]], Optional[str]]:
            nonlocal search_nodes
            search_nodes += 1
            if search_nodes > max_search_nodes:
                raise PairwiseGenerationError(
                    f"Pairwise 可行性搜索超过 {max_search_nodes} 个节点；"
                    "请缩小值域、补充剪枝约束，或显式提高预算。"
                )
            possible_now, failed_rule = solver.is_possible(current)
            if not possible_now:
                return None, failed_rule
            if index == len(remaining):
                valid, failed_rule = solver.is_valid(current)
                return (dict(current), None) if valid else (None, failed_rule)

            name = remaining[index]
            last_reason: Optional[str] = None
            for value in param_values[name]:
                current[name] = value
                completion, failed_rule = visit(index + 1, current)
                if completion is not None:
                    return completion, None
                last_reason = failed_rule or last_reason
            current.pop(name, None)
            return None, last_reason

        return visit(0, dict(fixed))

    # 单一维度没有 pair；仍保证每个值都有一条可行 case。
    if len(parameters) == 1:
        name = parameters[0]
        suite: List[Dict[str, str]] = []
        reasons: Dict[str, int] = {}
        for value in param_values[name]:
            completion, reason = find_completion({name: value})
            if completion is not None:
                suite.append(completion)
            else:
                reasons[reason or "no_satisfying_completion"] = reasons.get(reason or "no_satisfying_completion", 0) + 1
        if not suite:
            raise PairwiseGenerationError("参数空间不存在任何满足约束的组合")
        return PairwiseResult(suite, set(), set(), set(), reasons, search_nodes)

    feasible_pairs: Set[Pair] = set()
    candidate_combos: Dict[Tuple[Tuple[str, str], ...], Dict[str, str]] = {}
    infeasible_reasons: Dict[str, int] = {}

    base_completion, base_reason = find_completion({})
    if base_completion is None:
        raise PairwiseGenerationError(
            f"参数空间不存在任何满足约束的组合: {base_reason or 'unknown reason'}"
        )
    candidate_combos[_combo_key(base_completion, parameters)] = base_completion

    for left, right in combinations(parameters, 2):
        for left_value, right_value in product(param_values[left], param_values[right]):
            pair = _canonical_pair(left, left_value, right, right_value, positions)
            completion, reason = find_completion({left: left_value, right: right_value})
            if completion is None:
                reason_key = reason or "no_satisfying_completion"
                infeasible_reasons[reason_key] = infeasible_reasons.get(reason_key, 0) + 1
                continue
            feasible_pairs.add(pair)
            candidate_combos[_combo_key(completion, parameters)] = completion

    priority_dimension_pairs = {
        frozenset(pair)
        for pair in (high_priority_dimensions or [])
        if len(pair) == 2 and pair[0] in positions and pair[1] in positions
    }

    def is_priority(pair: Pair) -> bool:
        return frozenset((pair[0], pair[2])) in priority_dimension_pairs

    remaining_pairs = set(feasible_pairs)
    selected: List[Dict[str, str]] = []
    candidate_items = list(candidate_combos.items())
    while remaining_pairs:
        priority_remaining = any(is_priority(pair) for pair in remaining_pairs)
        best_combo: Optional[Dict[str, str]] = None
        best_covered: Set[Pair] = set()
        best_score: Optional[Tuple[int, int]] = None

        for _, combo in candidate_items:
            covered = _pairs_for_combo(combo, parameters, positions) & remaining_pairs
            if not covered:
                continue
            priority_gain = sum(1 for pair in covered if is_priority(pair))
            score = (priority_gain if priority_remaining else 0, len(covered))
            if best_score is None or score > best_score:
                best_combo = combo
                best_covered = covered
                best_score = score

        if best_combo is None:
            # 理论上不会发生：每个可行 pair 都已保存了一个完整补全。
            raise PairwiseGenerationError("无法为剩余可行 pair 选择覆盖用例")
        selected.append(best_combo)
        remaining_pairs.difference_update(best_covered)

    covered_pairs: Set[Pair] = set()
    for combo in selected:
        valid, failed_rule = solver.is_valid(combo)
        if not valid:
            raise PairwiseGenerationError(f"生成了违反约束的组合: {failed_rule}")
        covered_pairs.update(_pairs_for_combo(combo, parameters, positions))

    missing_pairs = feasible_pairs - covered_pairs
    if missing_pairs:
        raise PairwiseGenerationError(f"Pairwise 覆盖缺失: {sorted(missing_pairs)}")

    return PairwiseResult(
        suite=selected,
        feasible_pairs=feasible_pairs,
        covered_pairs=covered_pairs,
        missing_pairs=missing_pairs,
        infeasible_pair_reasons=infeasible_reasons,
        search_nodes=search_nodes,
    )


def generate_pairwise(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """向后兼容入口：无约束时同样保证完整两两覆盖。"""
    return generate_constraint_aware_pairwise(param_values).suite


def generate(param_values: Dict[str, List[str]], strategy: str) -> List[Dict[str, str]]:
    """根据策略名分派到具体算法。"""
    if strategy == "full_cartesian":
        return generate_cartesian(param_values)
    if strategy == "equivalence":
        return generate_equivalence(param_values)
    if strategy == "pairwise":
        return generate_pairwise(param_values)
    raise ValueError("unknown strategy: " + strategy)
