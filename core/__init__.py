"""GaussDB 测试因子库核心模块"""

from .factor_model import FactorDef, ParamDef, EquivalenceClass, SetupDef
from .symbol_table import (
    ColumnSymbol,
    TableSymbol,
    IndexSymbol,
    SchemaContext,
    infer_type_category,
    generate_sample_literal,
    apply_sql_effect_to_context,
)
from .combinator import generate, generate_cartesian, generate_pairwise, generate_equivalence
from .generator import GeneratedCase, generate_cases
from .executor import Executor, ExecConfig, ExecResult
from .registry import FactorRegistry
from .reporter import generate_report
from .scenario import ScenarioDef, ScenarioStepDef, ScenarioCase, ScenarioEngine

__all__ = [
    "FactorDef",
    "ParamDef",
    "EquivalenceClass",
    "SetupDef",
    "ColumnSymbol",
    "TableSymbol",
    "IndexSymbol",
    "SchemaContext",
    "infer_type_category",
    "generate_sample_literal",
    "apply_sql_effect_to_context",
    "generate",
    "generate_cartesian",
    "generate_pairwise",
    "generate_equivalence",
    "GeneratedCase",
    "generate_cases",
    "Executor",
    "ExecConfig",
    "ExecResult",
    "FactorRegistry",
    "generate_report",
    "ScenarioDef",
    "ScenarioStepDef",
    "ScenarioCase",
    "ScenarioEngine",
]
