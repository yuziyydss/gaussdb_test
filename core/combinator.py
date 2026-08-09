"""组合测试算法引擎：等价类 / Pairwise / 全笛卡尔积三种覆盖策略。"""
from itertools import product
from typing import Dict, List


def generate_cartesian(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """全笛卡尔积。"""
    if not param_values:
        return []
    keys = list(param_values.keys())
    value_lists = [param_values[k] for k in keys]
    return [dict(zip(keys, combo)) for combo in product(*value_lists)]


def generate_equivalence(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """等价类策略：取代表值做笛卡尔积。"""
    return generate_cartesian(param_values)


def generate_pairwise(param_values: Dict[str, List[str]]) -> List[Dict[str, str]]:
    """Pairwise (IPOG) 两两覆盖算法。"""
    if not param_values:
        return []
    params = list(param_values.keys())
    if len(params) == 1:
        return [{params[0]: v} for v in param_values[params[0]]]
    ordered = sorted(params, key=lambda p: len(param_values[p]), reverse=True)
    p1, p2 = ordered[0], ordered[1]
    suite = [{p1: v1, p2: v2} for v1 in param_values[p1] for v2 in param_values[p2]]
    for i in range(2, len(ordered)):
        pi = ordered[i]
        prev = ordered[:i]
        vals_i = param_values[pi]
        target: set = set()
        for pj in prev:
            for vj in param_values[pj]:
                for vi in vals_i:
                    target.add((pj, vj, vi))
        free_indices: List[int] = []
        for idx in range(len(suite)):
            tc = suite[idx]
            best_val = vals_i[0]
            best_gain = -1
            for vi in vals_i:
                gain = sum(1 for pj in prev if (pj, tc[pj], vi) in target)
                if gain > best_gain:
                    best_gain = gain
                    best_val = vi
            tc[pi] = best_val
            if best_gain == 0:
                free_indices.append(idx)
            for pj in prev:
                target.discard((pj, tc[pj], best_val))
        for pj, vj, vi in list(target):
            if (pj, vj, vi) not in target:
                continue
            placed = False
            for idx in free_indices:
                tc = suite[idx]
                if tc[pj] == vj:
                    tc[pi] = vi
                    placed = True
                    free_indices.remove(idx)
                    for p2 in prev:
                        target.discard((p2, tc[p2], vi))
                    break
            if not placed:
                for idx in free_indices:
                    tc = suite[idx]
                    tc[pj] = vj
                    tc[pi] = vi
                    placed = True
                    free_indices.remove(idx)
                    for p2 in prev:
                        target.discard((p2, tc[p2], vi))
                    break
            if not placed:
                new_tc = {p: param_values[p][0] for p in prev}
                new_tc[pj] = vj
                new_tc[pi] = vi
                suite.append(new_tc)
                for p2 in prev:
                    target.discard((p2, new_tc[p2], vi))
    return suite


def generate(param_values: Dict[str, List[str]], strategy: str) -> List[Dict[str, str]]:
    """根据策略名分派到具体算法。"""
    if strategy == "full_cartesian":
        return generate_cartesian(param_values)
    elif strategy == "equivalence":
        return generate_equivalence(param_values)
    elif strategy == "pairwise":
        return generate_pairwise(param_values)
    else:
        raise ValueError("unknown strategy: " + strategy)
