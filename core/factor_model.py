"""因子定义数据模型：YAML 因子文件的结构契约。"""
from typing import Dict, List

from pydantic import BaseModel, Field


class EquivalenceClass(BaseModel):
    name: str
    description: str = ""
    values: List[str] = Field(default_factory=list)


class ParamDef(BaseModel):
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


class CompositeDef(BaseModel):
    template: str


class FactorDef(BaseModel):
    id: str
    name: str
    category: str = "OTHER"
    description: str = ""
    template: str
    params: Dict[str, ParamDef] = Field(default_factory=dict)
    composites: Dict[str, CompositeDef] = Field(default_factory=dict)
    constants: Dict[str, str] = Field(default_factory=dict)
    default_strategy: str = "pairwise"

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

    def render_sql(self, param_values: Dict[str, str]) -> str:
        """把一组参数取值渲染成最终 SQL 语句。"""
        scope = dict(self.constants)
        scope.update(param_values)
        for comp_name, comp_def in self.composites.items():
            scope[comp_name] = comp_def.template.format(**scope)
        return self.template.format(**scope)
