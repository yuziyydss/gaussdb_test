"""因子定义数据模型：YAML 因子文件的结构契约。

增强版：支持预期结果 (expected)、文档溯源 (doc_ref)、
前置依赖 (setup)、上下文叠加 (context_overlays)、跨因子预期 (expected_matrix)。
"""
from typing import Dict, List, Any, Tuple

from pydantic import BaseModel, Field, model_validator


class EquivalenceClass(BaseModel):
    """等价类：一组行为相似的取值。"""
    name: str
    description: str = ""
    values: List[str] = Field(default_factory=list)
    expected: str = "success"          # success | error
    expected_sqlstate: str = ""       # 预期单个 SQLSTATE (保持向后兼容)
    expected_sqlstates: List[str] = Field(default_factory=list)  # 预期多个合法 SQLSTATE 集合

    @model_validator(mode="after")
    def normalize_sqlstates(self) -> "EquivalenceClass":
        """归一化 expected_sqlstates，确保单个字符串或列表均能正常工作。"""
        if self.expected_sqlstate and self.expected_sqlstate not in self.expected_sqlstates:
            self.expected_sqlstates.insert(0, self.expected_sqlstate)
        elif self.expected_sqlstates and not self.expected_sqlstate:
            self.expected_sqlstate = self.expected_sqlstates[0]
        return self


class ParamDef(BaseModel):
    """参数定义：一个可变化的测试维度。"""
    description: str = ""
    classes: List[EquivalenceClass] = Field(default_factory=list)
    representative: List[str] = Field(default_factory=list)

    def all_values(self) -> List[str]:
        """展开所有等价类下的全部取值。"""
        if not self.classes:
            return list(self.representative)
        out: List[str] = []
        for c in self.classes:
            out.extend(c.values)
        seen = set()
        uniq = []
        for v in out:
            if v not in seen:
                seen.add(v)
                uniq.append(v)
        return uniq

    def representative_values(self) -> List[str]:
        """取代表值。优先用显式 representative，否则取每个等价类首值。"""
        if self.representative:
            return list(self.representative)
        if not self.classes:
            return []
        return [c.values[0] for c in self.classes if c.values]

    def expected_for_value(self, value: str) -> Tuple[str, List[str]]:
        """取某个值的预期结果 (expected, [sqlstates])。"""
        for cls in self.classes:
            if value in cls.values:
                sqlstates = cls.expected_sqlstates if cls.expected_sqlstates else ([cls.expected_sqlstate] if cls.expected_sqlstate else [])
                return cls.expected, sqlstates
        return "success", []


class CompositeDef(BaseModel):
    """复合参数：由多个 param 组合而成。"""
    template: str


class SetupDef(BaseModel):
    """前置因子依赖定义 (fixture)。"""
    factor: str                                         # 引用的因子 ID
    strategy: str = "equivalence"                       # fixture 覆盖策略
    context: Dict[str, str] = Field(default_factory=dict)  # 固定 fixture 参数值
    matrix: bool = False                                # True=用所有配置做交叉


class FactorDef(BaseModel):
    """因子定义：一个可测试 SQL 构造的完整描述。"""
    id: str
    name: str
    category: str = "OTHER"
    description: str = ""
    doc_ref: str = ""                                   # 产品文档溯源
    template: str
    params: Dict[str, ParamDef] = Field(default_factory=dict)
    composites: Dict[str, Any] = Field(default_factory=dict)  # str 或 CompositeDef
    constants: Dict[str, str] = Field(default_factory=dict)
    setup: List[SetupDef] = Field(default_factory=list)       # fixture 链
    context_overlays: List[Dict[str, Any]] = Field(default_factory=list)
    expected_matrix: List[Dict[str, Any]] = Field(default_factory=list)
    exclusions: List[Dict[str, Any]] = Field(default_factory=list)
    constraints: List[str] = Field(default_factory=list)  # CSP 约束规则列表
    default_strategy: str = "pairwise"

    @model_validator(mode="before")
    @classmethod
    def normalize_composites(cls, data: Any) -> Any:
        """composites 支持字符串简写: "id {x}" -> {template: "id {x}"}。"""
        if isinstance(data, dict) and "composites" in data and data["composites"]:
            normalized = {}
            for k, v in data["composites"].items():
                if isinstance(v, str):
                    normalized[k] = {"template": v}
                else:
                    normalized[k] = v
            data["composites"] = normalized
        return data

    def param_names(self) -> List[str]:
        return list(self.params.keys())

    def values_for_strategy(self, strategy: str) -> Dict[str, List[str]]:
        """根据覆盖策略取每个参数的取值域。"""
        use_all = strategy == "full_cartesian"
        result: Dict[str, List[str]] = {}
        for name, pdef in self.params.items():
            if use_all:
                result[name] = pdef.all_values()
            else:
                result[name] = pdef.representative_values()
        return result

    def expected_for_value(self, param_name: str, value: str) -> Tuple[str, List[str]]:
        """取某个参数某个值的预期结果 (expected, [sqlstates])。"""
        pdef = self.params.get(param_name)
        if not pdef:
            return "success", []
        return pdef.expected_for_value(value)

    def merge_expected(self, combo: Dict[str, str]) -> Tuple[str, List[str]]:
        """组合多参数的预期：最严格原则 — 任一参数预期 error 则整条预期 error。"""
        expected = "success"
        sqlstates: List[str] = []
        for name, value in combo.items():
            e, ss_list = self.expected_for_value(name, value)
            if e == "error":
                expected = "error"
                for s in ss_list:
                    if s and s not in sqlstates:
                        sqlstates.append(s)
        return expected, sqlstates

    def has_matrix_setup(self) -> bool:
        """是否含 fixture 矩阵声明。"""
        return any(s.matrix for s in self.setup)

    @staticmethod
    def _extract_template(comp_def) -> str:
        """从 composites 值提取模板字符串 (兼容 str/dict/object)。"""
        if isinstance(comp_def, str):
            return comp_def
        if isinstance(comp_def, dict):
            return comp_def.get("template", "")
        if hasattr(comp_def, "template"):
            return comp_def.template
        return str(comp_def)

    def render_sql(self, param_values: Dict[str, str],
                   override_constants: Dict[str, str] = None) -> str:
        """把一组参数取值渲染成最终 SQL 语句。

        多趟解析 composites: 处理嵌套依赖时不怕顺序问题。
        例如 column_def 依赖 column_datatype, table_body 依赖 column_def,
        无论 YAML 里谁先写, 多趟循环保证全部解析。
        """
        scope = dict(self.constants)
        if override_constants:
            scope.update(override_constants)
        scope.update(param_values)

        # 多趟复合参数解析: 直到全部解析完或不再有进展
        resolved = set()
        for _ in range(len(self.composites) + 1):
            progress = False
            for comp_name, comp_def in self.composites.items():
                if comp_name in resolved:
                    continue
                tmpl = self._extract_template(comp_def)
                try:
                    scope[comp_name] = tmpl.format(**scope)
                    resolved.add(comp_name)
                    progress = True
                except (KeyError, IndexError):
                    pass  # 依赖还没解析, 下趟再试
            if not progress:
                break

        return self.template.format(**scope)
