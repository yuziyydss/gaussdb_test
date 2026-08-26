"""场景链引擎 (Scenario Pipeline)：

编排多因子时序执行与 SchemaContext 状态迁移，
实现：[CREATE_TABLE] -> [INSERT_DATA] -> [CREATE_INDEX] -> [SELECT_DQL] -> [ALTER_TABLE] 的全生命周期状态机测试。
"""
import copy
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Any

from .factor_model import FactorDef
from .generator import GeneratedCase, generate_cases, _render_sql
from .registry import FactorRegistry
from .symbol_table import SchemaContext, TableSymbol, ColumnSymbol, apply_sql_effect_to_context


@dataclass
class ScenarioStepDef:
    """场景链中的单个步骤定义。"""
    step_name: str
    factor_id: str
    strategy: str = "equivalence"
    params_override: Dict[str, str] = field(default_factory=dict)
    bind_from_context: bool = True  # 是否自动从上下文绑定已有的表名与列名


@dataclass
class ScenarioDef:
    """完整业务场景链定义。"""
    id: str
    name: str
    description: str = ""
    steps: List[ScenarioStepDef] = field(default_factory=list)


class ScenarioCase:
    """一条生成的复合场景测试用例：包含多步顺序执行的 SQL 列表与最终符号表上下文。"""

    def __init__(self, scenario_id: str, case_id: str,
                 step_cases: List[GeneratedCase],
                 final_context: SchemaContext):
        self.scenario_id = scenario_id
        self.case_id = case_id
        self.step_cases = step_cases
        self.final_context = final_context

    @property
    def all_sqls(self) -> List[str]:
        return [c.sql for c in self.step_cases]

    def to_dict(self) -> dict:
        return {
            "scenario_id": self.scenario_id,
            "case_id": self.case_id,
            "steps": [c.to_dict() for c in self.step_cases],
            "context_summary": self.final_context.to_dict(),
        }


class ScenarioEngine:
    """场景链生成与状态机调度引擎。"""

    def __init__(self, registry: FactorRegistry):
        self.registry = registry

    def generate_scenario(self, scenario: ScenarioDef,
                          initial_context: SchemaContext = None) -> List[ScenarioCase]:
        """按时序步骤推进 SchemaContext 状态，生成场景用例。"""
        ctx = (initial_context.snapshot() if initial_context
               else SchemaContext(schema_name="scenario_sandbox"))
        step_cases: List[GeneratedCase] = []

        for idx, step in enumerate(scenario.steps, start=1):
            factor = self.registry.get(step.factor_id)
            if not factor:
                continue

            # 动态绑定上下文中的表和列
            override_params = dict(step.params_override)
            if step.bind_from_context:
                active_table = ctx.pick_table()
                if active_table:
                    if "table_name" not in override_params:
                        override_params["table_name"] = active_table.name
                    cols = active_table.column_names()
                    if cols and "column_name" not in override_params:
                        override_params["column_name"] = cols[0]

            # 生成当前步骤的基础用例
            cases = generate_cases(factor, strategy=step.strategy, registry=self.registry)
            if not cases:
                continue

            # 选取具有代表性的用例推进状态机
            selected_case = cases[0]
            if override_params:
                # 重新渲染带有上下文动态绑定的 SQL
                merged_params = dict(selected_case.params)
                merged_params.update(override_params)
                selected_case.params = merged_params
                selected_case.sql = _render_sql(factor, selected_case.params, override_params)

            selected_case.case_id = f"{scenario.id}_step{idx}_{step.step_name}"
            step_cases.append(selected_case)

            # 推动 SchemaContext 状态迁移
            apply_sql_effect_to_context(ctx, factor.id, selected_case.params, selected_case.sql)

        scenario_case = ScenarioCase(
            scenario_id=scenario.id,
            case_id=f"{scenario.id}_0001",
            step_cases=step_cases,
            final_context=ctx,
        )
        return [scenario_case]
