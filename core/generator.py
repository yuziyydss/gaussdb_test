"""SQL 生成引擎：因子定义 + 覆盖策略 -> 具体 SQL 测试用例。"""
import re
from typing import Dict, List

from .combinator import generate
from .factor_model import FactorDef


class GeneratedCase:
    """一条生成的 SQL 测试用例。"""

    def __init__(self, factor_id: str, case_id: str, strategy: str,
                 params: Dict[str, str], sql: str):
        self.factor_id = factor_id
        self.case_id = case_id
        self.strategy = strategy
        self.params = params
        self.sql = sql

    def to_dict(self) -> dict:
        return {
            "factor_id": self.factor_id,
            "case_id": self.case_id,
            "strategy": self.strategy,
            "params": self.params,
            "sql": self.sql,
        }


def _clean_sql(sql: str) -> str:
    """压缩多余空格, 不影响单引号内的字符串。"""
    out = []
    in_string = False
    for ch in sql:
        if ch == "'":
            in_string = not in_string
            out.append(ch)
        elif ch == " " and not in_string:
            if out and out[-1] != " ":
                out.append(ch)
        else:
            out.append(ch)
    return "".join(out).strip()


def generate_cases(factor: FactorDef, strategy: str = None) -> List[GeneratedCase]:
    """根据因子定义和覆盖策略生成 SQL 测试用例列表。"""
    strat = strategy or factor.default_strategy
    param_values = factor.values_for_strategy(strat)
    combos = generate(param_values, strat)

    cases: List[GeneratedCase] = []
    for idx, combo in enumerate(combos, 1):
        sql = _clean_sql(factor.render_sql(combo))
        case_id = f"{factor.id}_{idx:04d}"
        cases.append(GeneratedCase(factor.id, case_id, strat, combo, sql))
    return cases
