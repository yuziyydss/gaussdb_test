"""规格定义数据模型 (Spec Data Models)：

实现文法工程的三层解耦数据契约：
1. SyntaxDef (语法规范与产生式插槽)
2. MatrixDef (全局语义兼容性矩阵与数据类型池)
3. ManifestDef (组合测试清单与绑定策略)
"""
import os
from typing import Dict, List, Optional, Any, Union
from pydantic import BaseModel, Field, model_validator
import yaml


# ==============================================================================
# 1. 语法规范模型 (Syntax & AST Slots)
# ==============================================================================

class SlotDef(BaseModel):
    """AST 插槽定义：描述产生式中的一个可变占位符。"""
    type: str = "token"  # token | element_list | sub_grammar | optional_group
    optional: bool = False
    delimiter: str = ", "
    min_elements: int = 1
    max_elements: int = 5
    values: List[str] = Field(default_factory=list)
    allowed_sub_grammars: List[str] = Field(default_factory=list)
    symbol_action: Optional[str] = None  # creates_table | consumes_table | consumes_column | None
    filter: Dict[str, Any] = Field(default_factory=dict)


class SubGrammarDef(BaseModel):
    """子语法定义：如列定义、表级约束、分区子句。"""
    production: str
    slots: Dict[str, SlotDef] = Field(default_factory=dict)


class SyntaxDef(BaseModel):
    """主语法规范定义。"""
    id: str
    name: str
    category: str = "DDL"  # DDL | DML | DCL | TCL
    doc_ref: str = ""
    description: str = ""
    production: str  # e.g. "CREATE {table_modifier} TABLE {table_name} ( {table_body} ) {storage_options}"
    slots: Dict[str, SlotDef] = Field(default_factory=dict)
    sub_grammars: Dict[str, SubGrammarDef] = Field(default_factory=dict)

    @model_validator(mode="before")
    @classmethod
    def normalize_slots(cls, data: Any) -> Any:
        """支持插槽简写：slots: { table_modifier: ["", "TEMPORARY"] } -> SlotDef."""
        if isinstance(data, dict) and "slots" in data and isinstance(data["slots"], dict):
            normalized = {}
            for k, v in data["slots"].items():
                if isinstance(v, list):
                    normalized[k] = {"values": v, "type": "token"}
                elif isinstance(v, dict):
                    normalized[k] = v
                else:
                    normalized[k] = {"values": [str(v)], "type": "token"}
            data["slots"] = normalized
        return data


# ==============================================================================
# 2. 全局语义兼容矩阵模型 (Semantic Matrix & Type Pool)
# ==============================================================================

class DataTypeDef(BaseModel):
    """数据类型规格定义。"""
    category: str = "numeric"  # numeric | string | datetime | binary | json | boolean
    representative: str = "100"
    boundary_values: List[str] = Field(default_factory=list)
    invalid_values: List[str] = Field(default_factory=list)
    expected_sqlstates_for_invalid: List[str] = Field(default_factory=list)


class MatrixDef(BaseModel):
    """全局语义兼容性矩阵定义。"""
    id: str
    name: str
    description: str = ""
    data_types: Dict[str, DataTypeDef] = Field(default_factory=dict)
    storage_engines: Dict[str, Dict[str, Any]] = Field(default_factory=dict)
    compatibility_rules: List[str] = Field(default_factory=list)  # CSP 规则集合


# ==============================================================================
# 3. 组合测试清单模型 (Test Manifest)
# ==============================================================================

class ManifestDef(BaseModel):
    """组合测试清单定义：描述针对特定特性的测试意图与参数空间。"""
    id: str
    name: str
    description: str = ""
    target_syntax: str  # 引用的语法 ID (如 syntax_create_table)
    import_matrices: List[str] = Field(default_factory=list)  # 引用的矩阵 ID 或路径
    bindings: Dict[str, List[str]] = Field(default_factory=dict)  # 参数取值绑定
    strategy: str = "pairwise"  # pairwise | equivalence | full_cartesian
    high_priority_dimensions: List[List[str]] = Field(default_factory=list)
    additional_constraints: List[str] = Field(default_factory=list)  # 场景级 CSP 约束


# ==============================================================================
# 4. 规格注册表 (SpecRegistry)
# ==============================================================================

class SpecRegistry:
    """加载与管理三类规格文件 (grammars/, matrices/, manifests/) 的注册表。"""

    def __init__(self, base_dir: str):
        self.base_dir = base_dir
        self.grammars_dir = os.path.join(base_dir, "grammars")
        self.matrices_dir = os.path.join(base_dir, "matrices")
        self.manifests_dir = os.path.join(base_dir, "manifests")

        self.syntaxes: Dict[str, SyntaxDef] = {}
        self.matrices: Dict[str, MatrixDef] = {}
        self.manifests: Dict[str, ManifestDef] = {}

    def load_all(self):
        """扫描并加载所有语法、矩阵与清单文件。"""
        self.syntaxes.clear()
        self.matrices.clear()
        self.manifests.clear()

        self._load_syntaxes()
        self._load_matrices()
        self._load_manifests()

    def _load_syntaxes(self):
        if not os.path.isdir(self.grammars_dir):
            return
        for root, _, files in os.walk(self.grammars_dir):
            for fname in files:
                if fname.endswith((".yaml", ".yml")):
                    path = os.path.join(root, fname)
                    with open(path, "r", encoding="utf-8") as f:
                        raw = yaml.safe_load(f)
                    if raw and "production" in raw and "id" in raw:
                        syntax = SyntaxDef(**raw)
                        self.syntaxes[syntax.id] = syntax

    def _load_matrices(self):
        if not os.path.isdir(self.matrices_dir):
            return
        for root, _, files in os.walk(self.matrices_dir):
            for fname in files:
                if fname.endswith((".yaml", ".yml")):
                    path = os.path.join(root, fname)
                    with open(path, "r", encoding="utf-8") as f:
                        raw = yaml.safe_load(f)
                    if raw and "id" in raw and ("data_types" in raw or "compatibility_rules" in raw):
                        matrix = MatrixDef(**raw)
                        self.matrices[matrix.id] = matrix

    def _load_manifests(self):
        if not os.path.isdir(self.manifests_dir):
            return
        for root, _, files in os.walk(self.manifests_dir):
            for fname in files:
                if fname.endswith((".yaml", ".yml")):
                    path = os.path.join(root, fname)
                    with open(path, "r", encoding="utf-8") as f:
                        raw = yaml.safe_load(f)
                    if raw and "target_syntax" in raw and "id" in raw:
                        manifest = ManifestDef(**raw)
                        self.manifests[manifest.id] = manifest

    def get_syntax(self, syntax_id: str) -> Optional[SyntaxDef]:
        return self.syntaxes.get(syntax_id)

    def get_matrix(self, matrix_id: str) -> Optional[MatrixDef]:
        return self.matrices.get(matrix_id)

    def get_manifest(self, manifest_id: str) -> Optional[ManifestDef]:
        return self.manifests.get(manifest_id)
