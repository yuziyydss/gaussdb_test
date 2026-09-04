#!/usr/bin/env python3
"""Compare PDF chapters with existing Factor Package V1 specifications.

This is a read-only, evidence-producing audit.  It deliberately does not edit
``specs/``: semantic differences must be reviewed before any YAML is replaced.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import unicodedata
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

import yaml

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageRegistry
from scripts.extract_pdf_sections import (
    EXTRACTION_RULE_VERSION,
    PopplerPageExtractor,
    assign_end_destinations,
    extract_chapter_text as extract_canonical_chapter_text,
    flatten_outline as flatten_canonical_outline,
    load_pypdf_reader,
    parse_cover_identity,
    sha256_file as sha256_path,
)


STATUS_VALUES = {"unchanged", "changed", "conflicting", "added", "missing"}


class DriftAuditError(RuntimeError):
    """Raised when an audit input is ambiguous or incomplete."""


@dataclass(frozen=True)
class OutlineEntry:
    path: tuple[str, ...]
    page_index: int
    top: float | None
    order: int

    @property
    def title(self) -> str:
        return self.path[-1]

    @property
    def parent(self) -> tuple[str, ...]:
        return self.path[:-1]


@dataclass(frozen=True)
class Probe:
    id: str
    axis: str
    description: str
    document_patterns: tuple[str, ...]
    spec_patterns: tuple[str, ...]
    spec_scope: str = "all"
    conflict_patterns: tuple[str, ...] = ()
    partial_patterns: tuple[str, ...] = ()


@dataclass(frozen=True)
class CorpusFragment:
    """One independently meaningful fragment in a package responsibility domain."""

    role: str
    source: str
    text: str
    incomplete_reasons: tuple[str, ...] = ()


DEFAULT_OUTLINE_PATHS: dict[str, tuple[str, ...]] = {
    "alter_table": (
        "1 SQL参考", "1.13 SQL语法", "1.13.7 A", "1.13.7.36 ALTER TABLE",
    ),
    "create_view": (
        "1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.60 CREATE VIEW",
    ),
    "create_index": (
        "1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.27 CREATE INDEX",
    ),
    "insert": (
        "1 SQL参考", "1.13 SQL语法", "1.13.14 I", "1.13.14.7 INSERT",
    ),
    "select": (
        "1 SQL参考", "1.13 SQL语法", "1.13.19 S", "1.13.19.3 SELECT",
    ),
}


def _section_probe(
    factor: str,
    probe_id: str,
    heading: str,
    pattern: str | None = None,
    spec_pattern: str | None = None,
) -> Probe:
    section_alias = {
        "语法格式": r"(?:语法格式|语法)",
        "参数说明": r"(?:参数说明|参数)",
    }.get(heading, re.escape(heading))
    return Probe(
        id=f"{factor}_{probe_id}",
        axis="source_section",
        description=f"原文小节已在 source ledger 中按小节登记：{heading}",
        document_patterns=(pattern or rf"(?:^|\s){re.escape(heading)}(?:\s|$)",),
        spec_patterns=(
            spec_pattern
            or rf"(?:section|anchor)=[^\n]*{section_alias}(?:\s|/|$)",
        ),
        spec_scope="source_sections",
    )


COMMON_SECTIONS = (
    ("section_purpose", "功能描述"),
    ("section_notes", "注意事项"),
    ("section_syntax", "语法格式"),
    ("section_parameters", "参数说明"),
    ("section_examples", "示例"),
)


PROBES: dict[str, tuple[Probe, ...]] = {
    "alter_table": tuple(
        _section_probe("alter_table", probe_id, heading)
        for probe_id, heading in COMMON_SECTIONS[:4]
    ) + (
        Probe(
            "at_action_branch", "syntax_token_or_branch", "通用 action [, ...] 顶层产生式",
            (r"action\s*\[\s*,\s*\.\.\.\s*\]",),
            (r"generic_action|action_profile",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_add_multi", "syntax_token_or_branch", "ADD 多列产生式",
            (r"ADD\s*\(.*?column_name.*?\[\s*,\s*\.\.\.\s*\]",),
            (r"add_multi|add_column_items",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_modify_multi", "syntax_token_or_branch", "MODIFY 多列产生式",
            (r"MODIFY\s*\(.*?column_name.*?\[\s*,\s*\.\.\.\s*\]",),
            (r"modify_multi|modify_column_items",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_rename_table", "syntax_token_or_branch", "RENAME TABLE 分支",
            (r"RENAME\s*\[\s*TO\s*\|\s*AS\s*\|\s*=\s*\]",),
            (r"rename_table|rename_operator",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_rename_column", "syntax_token_or_branch", "RENAME COLUMN 分支",
            (r"RENAME\s*\[\s*COLUMN\s*\]\s*column_name\s+TO",),
            (r"rename_column|column_keyword",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_rename_constraint", "syntax_token_or_branch", "RENAME CONSTRAINT 分支",
            (r"RENAME\s+CONSTRAINT\s+constraint_name\s+TO",),
            (r"rename_constraint",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_set_schema", "syntax_token_or_branch", "SET SCHEMA 分支",
            (r"SET\s+SCHEMA\s+new_schema",),
            (r"set_schema",), "roles:syntax,matrix,manifest,fixture",
        ),
        Probe(
            "at_gsiwaitall", "syntax_token_or_branch", "GSIWAITALL 分支",
            (r"GSIWAITALL",), (r"gsiwaitall",), "roles:syntax,matrix,manifest",
        ),
        Probe(
            "at_online_offline", "documented_feature", "ONLINE/OFFLINE 与在线参数",
            (r"OFFLINE\s*\|.*?ONLINE.*?online_parameter",),
            (r"ddl_mode|online_parameter",), "roles:factor,syntax,matrix,manifest,scenario",
        ),
        Probe(
            "at_target_forms", "syntax_token_or_branch", "table/*/ONLY 目标形态",
            (r"table_name\s*\[\s*\*\s*\]\s*\|\s*ONLY\s+table_name",),
            (r"at_target_star|at_target_only",), "roles:syntax,manifest",
        ),
        Probe(
            "at_rls", "documented_feature", "行访问控制开关及表形态限制",
            (r"行访问控制",), (r"row_level_security|RLS|rls",),
            "roles:factor,matrix,manifest,scenario,fixture",
        ),
    ),
    "create_view": tuple(
        _section_probe("create_view", probe_id, heading)
        for probe_id, heading in COMMON_SECTIONS
    ) + (
        Probe("cv_or_replace", "syntax_token_or_branch", "OR REPLACE 分支", (r"OR\s+REPLACE",), (r"or_replace",), "syntax"),
        Probe("cv_temp", "syntax_token_or_branch", "TEMP/TEMPORARY 分支", (r"TEMP\s*\|\s*TEMPORARY",), (r"temp_modifier",), "syntax"),
        Probe("cv_force", "syntax_token_or_branch", "FORCE 分支", (r"\[\s*FORCE\s*\]",), (r"force_modifier",), "syntax"),
        Probe("cv_view_options", "syntax_token_or_branch", "WITH(...) 视图选项分支", (r"view_option_name",), (r"view_options_profile",), "syntax"),
        Probe("cv_check_option", "syntax_token_or_branch", "CHECK OPTION 分支", (r"CHECK\s+OPTION",), (r"post_query_option",), "syntax"),
        Probe("cv_read_only", "syntax_token_or_branch", "READ ONLY 分支", (r"WITH\s+READ\s+ONLY",), (r"post_query_option",), "syntax"),
        Probe("cv_security_barrier", "documented_feature", "security_barrier 行级安全选项", (r"security_barrier",), (r"security_barrier",)),
        Probe("cv_temp_dependency", "documented_feature", "引用临时表时隐式成为临时视图", (r"引用.*临时表.*临时视图",), (r"临时依赖传播|temp_dependency",)),
        Probe("cv_force_dependency", "documented_feature", "FORCE 允许缺失依赖对象", (r"FORCE.*依赖的对象不存在",), (r"force_dependency|缺失对象",)),
        Probe("cv_partition_oid_invalidation", "documented_feature", "指定分区 OID 变化导致视图失效", (r"分区.*OID.*视图失效",), (r"OID.*视图失效|partition.*invalidation",)),
        Probe("cv_updatable_metadata", "documented_feature", "information_schema 可更新性元数据示例", (r"information_schema\.(?:columns|tables|views).*is_updatable",), (r"is_updatable",)),
    ),
    "create_index": tuple(
        _section_probe("create_index", probe_id, heading)
        for probe_id, heading in COMMON_SECTIONS
    ) + (
        Probe("ci_regular_branch", "syntax_token_or_branch", "普通表顶层产生式", (r"在表上创建索引",), (r"regular_index",), "syntax"),
        Probe("ci_partition_branch", "syntax_token_or_branch", "分区表顶层产生式", (r"在分区表上创建索引",), (r"partition_index",), "syntax"),
        Probe("ci_method_btree", "syntax_token_or_branch", "B-tree 方法候选", (r"B-?Tree",), (r"USING\s+btree",), "dimension:method"),
        Probe("ci_method_ubtree", "syntax_token_or_branch", "UB-tree 方法候选", (r"UB-?Tree",), (r"USING\s+ubtree",), "dimension:method"),
        Probe("ci_method_ugin", "syntax_token_or_branch", "UGIN 方法候选", (r"\bUGIN\b",), (r"USING\s+ugin",), "dimension:method"),
        Probe("ci_method_gin", "syntax_token_or_branch", "GIN 方法候选", (r"(?<!U)\bGIN\b",), (r"USING\s+gin",), "dimension:method"),
        Probe("ci_method_gist", "syntax_token_or_branch", "GiST 方法候选", (r"\bGiST\b",), (r"USING\s+gist",), "dimension:method"),
        Probe("ci_key_prefix_length", "syntax_token_or_branch", "索引键长度 (length)", (r"column_name\s*\[\s*\(\s*length\s*\)",), (r"prefix_length|prefix_name|key_length|\( length \)",), "dimension:key_profile"),
        Probe("ci_key_collation", "syntax_token_or_branch", "索引键 COLLATE", (r"COLLATE\s+collation",), (r"COLLATE|collation",), "dimension:key_profile"),
        Probe("ci_key_opclass", "syntax_token_or_branch", "索引键 opclass", (r"\[\s*opclass\s*\]",), (r"opclass",), "dimension:key_profile"),
        Probe(
            "ci_partition_concurrently",
            "syntax_token_or_branch",
            "分区表产生式包含 CONCURRENTLY",
            (r"在分区表上创建索引.*?CREATE.*?CONCURRENTLY.*?ON\s+table_name",),
            (r"partition_index", r"concurrently"),
            "syntax",
            conflict_patterns=(r"分区表产生式.*不列出\s*CONCURRENTLY",),
        ),
        Probe(
            "ci_partition_if_not_exists",
            "syntax_token_or_branch",
            "分区表产生式包含 IF NOT EXISTS",
            (r"在分区表上创建索引.*?CREATE.*?IF\s+NOT\s+EXISTS.*?ON\s+table_name",),
            (r"partition_index", r"if_not_exists"),
            "syntax",
            conflict_patterns=(r"分区表产生式.*不列出.*IF\s+NOT\s+EXISTS",),
        ),
        Probe("ci_ilm_policy", "syntax_token_or_branch", "ILM ADD POLICY 子句", (r"ILM\s+ADD\s+POLICY",), (r"ilm",), "syntax"),
        Probe(
            "ci_partial_where",
            "syntax_token_or_branch",
            "普通索引 WHERE predicate 子句",
            (r"\[\s*WHERE\s+predicate\s*\]",),
            (r"where_predicate|partial_index",),
            "syntax",
            conflict_patterns=(r"本页.*未给出.*WHERE\s*子语法|未给出离线\s*WHERE",),
        ),
        Probe(
            "ci_clause_order",
            "syntax_token_or_branch",
            "TABLESPACE → COMMENT → VISIBLE/INVISIBLE 子句顺序",
            (r"TABLESPACE\s+tablespace_name.*?COMMENT\s+'string'.*?VISIBLE\s*\|\s*INVISIBLE",),
            (r"tablespace_clause.*comment_clause.*visibility_clause",),
            "syntax",
            conflict_patterns=(r"comment_clause.*visibility_clause.*tablespace_clause",),
        ),
        Probe(
            "ci_method_catalog",
            "documented_feature",
            "方法目录包含 btree/ubtree/ugin/gin/gist",
            (r"UB-?Tree", r"\bUGIN\b", r"(?<!U)\bGIN\b", r"\bGiST\b"),
            (r"ubtree", r"ugin", r"(?<!u)gin", r"gist"),
            "dimension:method",
            conflict_patterns=(r"只列出\s*btree|仅.*btree",),
        ),
        Probe("ci_storage_method_contract", "documented_feature", "Ustore/GIN/GiST/UGIN 存储引擎能力约束", (r"UGIN.*Ustore", r"GIN、GiST.*Astore"), (r"ugin.*ustore", r"gin.*gist.*astore")),
        Probe("ci_xml_restriction", "documented_feature", "XML 类型索引限制", (r"不支持XML类型数据",), (r"XML\s*类型|xml_type",)),
        Probe("ci_rowid_rowno", "documented_feature", "rowid/rowno 系统列限制", (r"rowid.*rowno.*系统列",), (r"rowid.*rowno",)),
        Probe("ci_sql_length_warning", "documented_feature", "索引 SQL 长度 5250 警告", (r"5250字符.*WARNING",), (r"5250.*WARNING",)),
    ),
    "insert": tuple(
        _section_probe("insert", probe_id, heading)
        for probe_id, heading in COMMON_SECTIONS
    ) + (
        Probe(
            "insert_with", "syntax_token_or_branch", "WITH/RECURSIVE CTE 前缀",
            (r"WITH\s*\[\s*RECURSIVE\s*\]\s+with_query",),
            (r"with_clause",), "roles:syntax,matrix,manifest,scenario",
        ),
        Probe(
            "insert_ignore", "syntax_token_or_branch", "IGNORE 修饰符",
            (r"INSERT.*?\[\s*IGNORE\s*\].*?INTO",),
            (r"ignore_modifier|insert_feature_ignore",),
            "roles:factor,syntax,matrix,manifest,scenario",
        ),
        Probe(
            "insert_table_target", "syntax_token_or_branch", "普通表目标及列/分区别名",
            (r"INTO\s+table_name.*?partition_clause",),
            (r"target_profile|insert_target_table",),
            "roles:syntax,matrix,manifest,fixture",
        ),
        Probe(
            "insert_view_subquery_target", "syntax_token_or_branch", "视图或子查询目标",
            (r"对子查询和视图插入.*?INTO\s*\{\s*subquery\s*\|\s*view_name",),
            (r"insert_target_(?:view|subquery)|view_subquery",),
            "roles:factor,syntax,matrix,manifest,scenario,fixture",
        ),
        Probe(
            "insert_input_forms", "syntax_token_or_branch", "DEFAULT/VALUES/VALUE/query 输入分支",
            (r"DEFAULT\s+VALUES.*?VALUES\s*\|\s*VALUE.*?\|\s*query",),
            (r"insert_source_default|insert_source_values|insert_source_query",),
            "roles:factor,syntax,matrix,manifest",
        ),
        Probe(
            "insert_duplicate", "syntax_token_or_branch", "ON DUPLICATE KEY UPDATE",
            (r"ON\s+DUPLICATE\s+KEY\s+UPDATE",),
            (r"duplicate",), "roles:factor,syntax,matrix,manifest,scenario",
        ),
        Probe(
            "insert_conflict", "syntax_token_or_branch", "ON CONFLICT",
            (r"ON\s+CONFLICT",), (r"conflict_clause|on_conflict",),
            "roles:factor,syntax,matrix,manifest,scenario",
        ),
        Probe(
            "insert_returning", "syntax_token_or_branch", "RETURNING 输出列表",
            (r"RETURNING\s*\{\s*\*",), (r"returning_clause|returning",),
            "roles:factor,syntax,matrix,manifest,scenario",
        ),
        Probe(
            "insert_partition", "syntax_token_or_branch", "PARTITION/SUBPARTITION 目标",
            (r"PARTITION.*?SUBPARTITION",), (r"partition",),
            "roles:factor,matrix,manifest,scenario,fixture",
        ),
    ),
    "select": tuple(
        _section_probe("select", probe_id, heading)
        for probe_id, heading in COMMON_SECTIONS[:4]
    ) + tuple(
        _section_probe(
            "select",
            f"subsection_{index:02d}",
            heading,
            rf"1\.13\.19\.3\.{index}\s+{re.escape(heading)}",
            (
                rf"(?:section|anchor)=[^\n]*1\.13\.19\.3\.{index}(?:\s|/|$)"
                if index not in {10, 11}
                else (
                    rf"(?:section|anchor)=[^\n]*1\.13\.19\.3\.{index}[^\n]*"
                    + (r"(?:行转列与列转行|行列转置)" if index == 10 else r"窗口函数")
                )
            ),
        )
        for index, heading in enumerate((
            "简单查询", "条件查询", "分组查询", "分页查询", "分区查询", "连接查询",
            "子查询", "层次查询", "复合查询", "行转列与列转行", "窗口函数查询",
            "简化版查询", "Hint 查询",
        ), 1)
    ) + (
        Probe("select_cte", "syntax_token_or_branch", "WITH/RECURSIVE CTE", (r"WITH\s*\[\s*RECURSIVE",), (r"with_clause",), "syntax"),
        Probe("select_from", "syntax_token_or_branch", "FROM 查询源", (r"FROM\s+from_item",), (r"from_source",), "syntax"),
        Probe("select_hierarchy", "syntax_token_or_branch", "START WITH / CONNECT BY", (r"START\s+WITH.*CONNECT\s+BY",), (r"hierarchy",), "roles:syntax,matrix,manifest,scenario"),
        Probe("select_group", "syntax_token_or_branch", "GROUP BY / HAVING", (r"GROUP\s+BY", r"HAVING"), (r"group", r"having"), "roles:syntax,matrix,manifest,scenario"),
        Probe("select_window", "syntax_token_or_branch", "WINDOW 子句", (r"WINDOW\s+window_name",), (r"window",), "roles:syntax,matrix,manifest,scenario"),
        Probe("select_set_operations", "syntax_token_or_branch", "UNION/INTERSECT/EXCEPT/MINUS", (r"UNION", r"INTERSECT", r"EXCEPT\s*\|\s*MINUS"), (r"set_operation",), "syntax"),
        Probe("select_pagination", "syntax_token_or_branch", "LIMIT/OFFSET/FETCH", (r"LIMIT", r"OFFSET", r"FETCH"), (r"limit_clause",), "syntax"),
        Probe("select_locking", "syntax_token_or_branch", "FOR UPDATE/SHARE 锁定", (r"FOR\s*\{\s*UPDATE\s*\|\s*NO\s+KEY\s+UPDATE",), (r"lock",), "syntax"),
        Probe("select_pivot_unpivot", "syntax_token_or_branch", "PIVOT/UNPIVOT 查询源", (r"unpivot_clause", r"pivot_clause"), (r"pivot|unpivot",), "roles:syntax,matrix,manifest,scenario"),
        Probe(
            "select_xmltable_example_restored",
            "documented_feature",
            "PDF 中存在完整 XMLTABLE 示例输入",
            (r"SELECT\s+\*\s+FROM\s+XMLTABLE", r"XMLNAMESPACES", r"<root\s+xmlns="),
            (r"XMLTABLE.*示例",),
            "all",
            conflict_patterns=(r"XML\s*节点内容已丢失|XML.*内容不完整",),
        ),
        Probe("select_subchapter_examples", "documented_feature", "13 个 SELECT 示例子章节被逐章登记", (r"1\.13\.19\.3\.1\s+简单查询", r"1\.13\.19\.3\.13\s+Hint\s*查询"), (r"section:\s*1\.13\.19\.3\.1\s+简单查询", r"section:\s*1\.13\.19\.3\.13\s+Hint\s*查询"), "source"),
    ),
}


def normalize_text(value: str) -> str:
    value = unicodedata.normalize("NFKC", value)
    value = value.replace("‐", "-").replace("‑", "-").replace("–", "-")
    return re.sub(r"\s+", " ", value).strip()


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def _matches(text: str, patterns: Iterable[str]) -> bool:
    normalized = normalize_text(text)
    return all(re.search(pattern, normalized, re.IGNORECASE) for pattern in patterns)


def _evidence(text: str, patterns: Iterable[str], source: str) -> dict[str, Any] | None:
    normalized = normalize_text(text)
    first = next(iter(patterns), None)
    match = re.search(first, normalized, re.IGNORECASE) if first else None
    if match is None:
        return None
    start = max(0, match.start() - 70)
    # Some semantic probes intentionally span an entire grammar branch.  Never
    # copy that whole branch into the report; evidence is a locator, not source
    # redistribution.
    end = min(len(normalized), match.start() + 350)
    return {"source": source, "excerpt": normalized[start:end]}


def _matching_fragments(
    fragments: Iterable[CorpusFragment], patterns: Iterable[str]
) -> list[CorpusFragment]:
    return sorted(
        (fragment for fragment in fragments if _matches(fragment.text, patterns)),
        key=lambda fragment: (len(normalize_text(fragment.text)), fragment.source),
    )


def _fragment_evidence(
    fragments: list[CorpusFragment], patterns: Iterable[str]
) -> dict[str, Any] | None:
    if not fragments:
        return None
    fragment = fragments[0]
    evidence = _evidence(fragment.text, patterns, fragment.source)
    if evidence is not None:
        evidence["responsibility_domain"] = fragment.role
        if fragment.incomplete_reasons:
            evidence["incomplete_reasons"] = list(fragment.incomplete_reasons)
    return evidence


class SpecPackage:
    def __init__(self, spec_root: Path, factor_id: str):
        candidates = list(spec_root.rglob(f"{factor_id}.factor.yaml"))
        if len(candidates) != 1:
            raise DriftAuditError(
                f"{factor_id}: 预期唯一 factor.yaml，实际找到 {len(candidates)} 个"
            )
        self.directory = candidates[0].parent
        self.factor_id = factor_id
        self.yaml_files: list[tuple[Path, str, dict[str, Any]]] = []
        for path in sorted(self.directory.rglob("*.yaml")):
            text = path.read_text(encoding="utf-8")
            data = yaml.safe_load(text) or {}
            self.yaml_files.append((path, text, data))
        self.readme_path = self.directory / "README.md"
        self.readme_text = (
            self.readme_path.read_text(encoding="utf-8")
            if self.readme_path.exists() else ""
        )
        self.factor = self._one("factor")
        self.source = self._one("source_ledger")
        self.syntax = self._one("syntax")

    @staticmethod
    def _incomplete_reasons(node: dict[str, Any], role: str) -> tuple[str, ...]:
        """Return only dispositions declared by this node, not nested siblings."""
        reasons: list[str] = []
        if node.get("status") == "needs_profile":
            reasons.append("needs_profile")
        if node.get("coverage_mode") == "representative":
            reasons.append("representative_coverage")
        if node.get("oracle_status") == "needs_verification":
            reasons.append("oracle_needs_verification")
        if (
            node.get("type") == "open_question"
            or node.get("status") == "needs_verification"
        ):
            reasons.append("open_question")
        if role == "scenario" and node.get("status") == "planned":
            reasons.append("planned_scenario")
        return tuple(dict.fromkeys(reasons))

    @classmethod
    def _mapping_fragments(
        cls,
        node: Any,
        *,
        role: str,
        source: str,
        pointer: str = "",
    ) -> list[CorpusFragment]:
        fragments: list[CorpusFragment] = []
        if isinstance(node, dict):
            fragments.append(CorpusFragment(
                role=role,
                source=f"{source}#{pointer or '/'}",
                text=yaml.safe_dump(node, allow_unicode=True, sort_keys=False),
                incomplete_reasons=cls._incomplete_reasons(node, role),
            ))
            for key, value in node.items():
                escaped = str(key).replace("~", "~0").replace("/", "~1")
                fragments.extend(cls._mapping_fragments(
                    value,
                    role=role,
                    source=source,
                    pointer=f"{pointer}/{escaped}",
                ))
        elif isinstance(node, list):
            for index, value in enumerate(node):
                fragments.extend(cls._mapping_fragments(
                    value,
                    role=role,
                    source=source,
                    pointer=f"{pointer}/{index}",
                ))
        return fragments

    def _one(self, kind: str) -> tuple[Path, str, dict[str, Any]]:
        matches = [entry for entry in self.yaml_files if entry[2].get("kind") == kind]
        if len(matches) != 1:
            raise DriftAuditError(
                f"{self.factor_id}: 预期唯一 kind={kind}，实际找到 {len(matches)} 个"
            )
        return matches[0]

    def _role_entries(self, roles: set[str]) -> list[tuple[Path, str, dict[str, Any]]]:
        role_aliases = {"source": "source_ledger"}
        normalized = {role_aliases.get(role, role) for role in roles}
        return [entry for entry in self.yaml_files if entry[2].get("kind") in normalized]

    def fragments(self, scope: str) -> list[CorpusFragment]:
        if scope == "source_sections":
            _, _, data = self.source
            return [CorpusFragment(
                role="source_ledger",
                source=f"{self.source[0]}#/units/{index}",
                text=(
                    f"id={unit.get('id', '')} section={unit.get('section', '')} "
                    f"anchor={unit.get('source_anchor', '')} "
                    f"status={unit.get('status', '')}"
                ),
            ) for index, unit in enumerate(data.get("units", []))]
        if scope.startswith("dimension:"):
            dimension_id = scope.split(":", 1)[1]
            dimension = self.factor[2].get("dimensions", {}).get(dimension_id)
            if not isinstance(dimension, dict):
                return []
            result = self._mapping_fragments(
                dimension,
                role="factor",
                source=str(self.factor[0]),
                pointer=f"/dimensions/{dimension_id}",
            )
            matrix_ref = (dimension.get("profile_source") or {}).get("matrix_ref")
            for path, _, data in self._role_entries({"matrix"}):
                if data.get("id") == matrix_ref:
                    result.extend(self._mapping_fragments(
                        data, role="matrix", source=str(path)
                    ))
            dimension_ref = f"{self.factor_id}.{dimension_id}"
            for path, _, data in self._role_entries({"syntax"}):
                for slot_name, slot in (data.get("slots") or {}).items():
                    if isinstance(slot, dict) and slot.get("dimension_ref") == dimension_ref:
                        result.extend(self._mapping_fragments(
                            {"slot": slot_name, **slot},
                            role="syntax",
                            source=str(path),
                            pointer=f"/slots/{slot_name}",
                        ))
            for path, _, data in self._role_entries({"manifest"}):
                bindings = data.get("bindings") or {}
                if dimension_id in bindings:
                    result.extend(self._mapping_fragments(
                        {
                            "manifest_id": data.get("id"),
                            "suite_type": data.get("suite_type"),
                            "dimension": dimension_id,
                            "binding_values": bindings[dimension_id],
                        },
                        role="manifest",
                        source=str(path),
                        pointer=f"/bindings/{dimension_id}",
                    ))
            return result
        if scope == "all":
            entries = self.yaml_files
        elif scope.startswith("roles:"):
            roles = {item.strip() for item in scope.split(":", 1)[1].split(",") if item.strip()}
            entries = self._role_entries(roles)
        elif scope in {"factor", "source", "syntax", "matrix", "manifest", "scenario", "fixture"}:
            entries = self._role_entries({scope})
        else:
            raise DriftAuditError(f"未知 spec scope: {scope}")
        result: list[CorpusFragment] = []
        for path, _, data in entries:
            role = str(data.get("kind"))
            result.extend(self._mapping_fragments(
                data, role=role, source=str(path)
            ))
        return result

    def corpus(self, scope: str) -> tuple[str, str]:
        fragments = self.fragments(scope)
        return "\n".join(fragment.text for fragment in fragments), (
            ", ".join(dict.fromkeys(fragment.source for fragment in fragments))
            or str(self.directory)
        )

    @property
    def responsibility_domains(self) -> dict[str, list[str]]:
        domains: dict[str, list[str]] = {}
        for path, _, data in self.yaml_files:
            domains.setdefault(str(data.get("kind")), []).append(str(path))
        return {role: sorted(paths) for role, paths in sorted(domains.items())}

    @property
    def files(self) -> list[dict[str, str]]:
        return [
            {
                "path": str(path),
                "sha256": sha256_bytes(text.encode("utf-8")),
            }
            for path, text, _ in self.yaml_files
        ]


def _flatten_outline(items: list[Any], reader: Any) -> list[OutlineEntry]:
    entries: list[OutlineEntry] = []

    def walk(children: list[Any], parent: tuple[str, ...]) -> None:
        previous: Any | None = None
        for item in children:
            if isinstance(item, list):
                if previous is not None:
                    walk(item, parent + (str(previous.title),))
                continue
            previous = item
            entries.append(OutlineEntry(
                path=parent + (str(item.title),),
                page_index=reader.get_destination_page_number(item),
                top=float(item.top) if getattr(item, "top", None) is not None else None,
                order=len(entries),
            ))

    walk(items, ())
    return entries


def select_outline_entry(
    entries: list[OutlineEntry], requested_path: tuple[str, ...]
) -> tuple[OutlineEntry, OutlineEntry]:
    exact = [item for item in entries if item.path == requested_path]
    if len(exact) != 1:
        title_matches = [item for item in entries if item.title == requested_path[-1]]
        choices = [" > ".join(item.path) for item in title_matches]
        raise DriftAuditError(
            f"outline path 必须唯一精确匹配: {' > '.join(requested_path)}; "
            f"同标题候选={choices}"
        )
    start = exact[0]
    next_siblings = [
        item for item in entries
        if item.order > start.order and item.parent == start.parent
    ]
    if not next_siblings:
        raise DriftAuditError(f"{start.title}: 找不到下一同级书签，无法确定章节尾界")
    return start, next_siblings[0]


def extract_pdf_chapters(
    pdf_path: Path,
    outline_paths: dict[str, tuple[str, ...]],
) -> dict[str, tuple[str, dict[str, Any]]]:
    """Extract chapters with the same canonical engine used by catalog creation."""
    reader = load_pypdf_reader(pdf_path)
    page_count = len(reader.pages)
    page_labels = [str(label) for label in reader.page_labels]
    if len(page_labels) != page_count:
        page_labels = [str(number) for number in range(1, page_count + 1)]
    page_widths = [float(page.mediabox.width) for page in reader.pages]
    page_heights = [float(page.mediabox.height) for page in reader.pages]
    outline = assign_end_destinations(
        flatten_canonical_outline(reader, page_labels, page_heights),
        page_count=page_count,
        page_labels=page_labels,
        page_heights=page_heights,
    )
    selected = {}
    for factor_id, outline_path in outline_paths.items():
        matches = [item for item in outline if item.outline_path == outline_path]
        if len(matches) != 1:
            raise DriftAuditError(
                f"outline path 必须唯一精确匹配: {' > '.join(outline_path)}; "
                f"实际找到 {len(matches)} 个"
            )
        selected[factor_id] = matches[0]

    extractor = PopplerPageExtractor(pdf_path, page_widths, page_heights)
    identity = parse_cover_identity(reader.pages[0].extract_text() or "")
    parent_pdf_sha256 = sha256_path(pdf_path)
    extracted: dict[str, tuple[str, dict[str, Any]]] = {}
    for factor_id, bookmark in selected.items():
        text = extract_canonical_chapter_text(
            bookmark,
            extractor,
            page_labels=page_labels,
        )
        end = bookmark.end_destination
        following = sorted(
            (
                item for item in outline
                if item.index > bookmark.index and item.depth <= bookmark.depth
            ),
            key=lambda item: item.index,
        )
        next_sibling_title = following[0].outline_path[-1] if following else None
        metadata = {
            "mode": "pdf_outline_bbox_canonical",
            "outline_path": list(bookmark.outline_path),
            "start_destination": bookmark.start_destination.as_dict(),
            "end_destination": {
                **(end.as_dict(exclusive=True) if end else {}),
                "next_sibling_title": next_sibling_title,
            },
            "physical_page_start": bookmark.start_destination.physical_page,
            "physical_page_end": end.physical_page if end else None,
            "product_version": identity["product_version"],
            "document_version": identity["document_version"],
            "parent_pdf_path": str(pdf_path.resolve()),
            "parent_pdf_sha256": parent_pdf_sha256,
            "extraction_rule_version": EXTRACTION_RULE_VERSION,
            "chapter_sha256": sha256_bytes(text.encode("utf-8")),
            "line_count": len(text.splitlines()),
        }
        extracted[factor_id] = (text, metadata)
    return extracted


def extract_pdf_chapter(
    pdf_path: Path, outline_path: tuple[str, ...]
) -> tuple[str, dict[str, Any]]:
    """Single-chapter convenience wrapper used by callers and tests."""
    return extract_pdf_chapters(pdf_path, {"chapter": outline_path})["chapter"]


def _source_binding_check(package: SpecPackage, metadata: dict[str, Any]) -> dict[str, Any]:
    factor_source = package.factor[2].get("source", {})
    factor_hash = factor_source.get("artifact_sha256")
    ledger_hash = package.source[2].get("artifact_sha256")
    chapter_hash = metadata.get("chapter_sha256")
    parent_pdf_hash = metadata.get("parent_pdf_sha256")
    factor_parent_pdf_hash = factor_source.get("parent_pdf_sha256")
    extraction_rule_version = metadata.get("extraction_rule_version")
    factor_extraction_rule_version = factor_source.get("extraction_rule_version")
    catalog_ref = factor_source.get("catalog_chapter_ref") or {}
    document_id = metadata.get("document_id")
    source_relpath = metadata.get("source_relpath")
    product_version = metadata.get("product_version")
    current_version = factor_source.get("version")
    version_bound = bool(
        product_version and current_version and current_version != "unknown"
        and normalize_text(str(product_version)) == normalize_text(str(current_version))
    )
    issues = []
    if not factor_hash or factor_hash != ledger_hash:
        issues.append("factor 与 source ledger 的 artifact_sha256 必须完全一致")
    if chapter_hash and (factor_hash != chapter_hash or ledger_hash != chapter_hash):
        issues.append("factor/source ledger 必须同时绑定本次 canonical 章节哈希")
    if catalog_ref and catalog_ref.get("chapter_sha256") != factor_hash:
        issues.append("catalog_chapter_ref.chapter_sha256 与 factor artifact 不一致")
    if document_id and catalog_ref.get("document_id") != document_id:
        issues.append("catalog_chapter_ref.document_id 与本次 catalog 不一致")
    if source_relpath and catalog_ref.get("source_relpath") != source_relpath:
        issues.append("catalog_chapter_ref.source_relpath 与本次 catalog 不一致")
    if parent_pdf_hash:
        if not factor_parent_pdf_hash:
            issues.append("factor.source 缺少 parent_pdf_sha256")
        elif factor_parent_pdf_hash != parent_pdf_hash:
            issues.append("factor.source.parent_pdf_sha256 与本次父 PDF 不一致")
    if extraction_rule_version:
        if not factor_extraction_rule_version:
            issues.append("factor.source 缺少 extraction_rule_version")
        elif factor_extraction_rule_version != extraction_rule_version:
            issues.append("factor.source.extraction_rule_version 与本次抽取规则不一致")
    if product_version and not version_bound:
        issues.append(
            f"factor.source.version={current_version!r}，PDF product_version={product_version!r}"
        )
    return {
        "status": "unchanged" if not issues else "changed",
        "hash_bound": not any("sha256" in issue.lower() or "哈希" in issue for issue in issues),
        "version_bound": version_bound,
        "factor_artifact_sha256": factor_hash,
        "ledger_artifact_sha256": ledger_hash,
        "factor_parent_pdf_sha256": factor_parent_pdf_hash,
        "pdf_sha256": parent_pdf_hash,
        "chapter_sha256": chapter_hash,
        "factor_extraction_rule_version": factor_extraction_rule_version,
        "extraction_rule_version": extraction_rule_version,
        "factor_version": current_version,
        "pdf_product_version": product_version,
        "issues": issues,
    }


def _atomicity_check(
    package: SpecPackage,
    coverage_audit: dict[str, Any],
) -> dict[str, Any]:
    """Project the authoritative FactorCoverageAuditor atomicity result.

    ``grouped`` is a legitimate declaration when the number of independent
    claims is backed by distinct fact mappings.  It is therefore reported as
    inventory, not treated as a gap by itself.
    """
    units = package.source[2].get("units", [])
    missing = [
        unit.get("id") for unit in units
        if unit.get("atomicity", "unreviewed") == "unreviewed"
    ]
    grouped = [
        unit.get("id") for unit in units
        if unit.get("atomicity") == "grouped"
        or int(unit.get("independent_claim_count", 1) or 1) > 1
    ]
    authoritative = coverage_audit["source_units"]["atomicity"]
    gaps = authoritative["gaps"]
    return {
        "status": "unchanged" if authoritative["complete"] else "changed",
        "unit_count": len(units),
        "missing_atomicity": missing,
        "grouped_units": grouped,
        "gap_count": len(gaps),
        "gaps": gaps,
        "complete": authoritative["complete"],
        "issues": ([] if not gaps else [
            "source unit 原子性仍有 FactorCoverageAuditor 报告的具体缺口"
        ]),
    }


def _boundary_check(text: str, metadata: dict[str, Any]) -> dict[str, Any]:
    normalized = normalize_text(text)
    title = (metadata.get("outline_path") or [None])[-1]
    next_title = metadata.get("end_destination", {}).get("next_sibling_title")
    issues = []
    if title and normalize_text(str(title)) not in normalized[:500]:
        issues.append("章节标题未出现在裁剪文本开头，疑似包含前一章节尾部")
    if next_title and normalize_text(str(next_title)) in normalized:
        issues.append("裁剪文本包含下一同级章节标题")
    if metadata.get("mode") in {"page_range", "unknown"}:
        issues.append("输入仅有整页范围，不能证明页面内章节边界无污染")
    return {
        "status": "unchanged" if not issues else "conflicting",
        "next_sibling_title": next_title,
        "issues": issues,
    }


def compare_probe(probe: Probe, document_text: str, package: SpecPackage) -> dict[str, Any]:
    doc_present = _matches(document_text, probe.document_patterns)
    spec_fragments = package.fragments(probe.spec_scope)
    spec_matches = _matching_fragments(spec_fragments, probe.spec_patterns)
    spec_present = bool(spec_matches)

    # A contradiction must live in one independently meaningful fragment in
    # the same responsibility scope.  Searching one concatenated package blob
    # incorrectly joins unrelated clauses, rules, and manifests.
    conflict_matches = (
        _matching_fragments(spec_fragments, probe.conflict_patterns)
        if probe.conflict_patterns else []
    )
    conflicting_fragments = [
        fragment for fragment in conflict_matches
        if not _matches(fragment.text, probe.spec_patterns)
    ]
    conflict = bool(conflicting_fragments)

    partial_matches = (
        _matching_fragments(package.fragments("all"), probe.partial_patterns)
        if probe.partial_patterns else []
    )
    incomplete_reasons = sorted({
        reason
        for fragment in spec_matches
        for reason in fragment.incomplete_reasons
    })
    partial = bool(partial_matches or incomplete_reasons)

    if doc_present and conflict:
        status = "conflicting"
        reason = "PDF 与现有规格包含可判定的相反陈述或结构顺序"
    elif doc_present and spec_present and partial:
        status = "changed"
        reason = (
            "PDF 事实已在规格职责域中表示，但仍明确标记为代表覆盖、"
            "needs_profile、open_question、待校准 Oracle 或 planned scenario"
        )
    elif doc_present and spec_present:
        status = "unchanged"
        reason = "PDF 事实在指定规格职责域中已有对应表示"
    elif doc_present:
        status = "added"
        reason = "PDF 存在该事实，但指定规格职责域中没有对应表示"
    elif spec_present:
        status = "missing"
        reason = "现有规格包含该项，但本次精确章节文本中未找到依据"
    else:
        status = "missing"
        reason = "本次章节未检出预期事实，需先检查切章或版本差异"

    result = {
        "id": probe.id,
        "axis": probe.axis,
        "description": probe.description,
        "status": status,
        "reason": reason,
        "document_present": doc_present,
        "spec_present": spec_present,
        "spec_responsibility_domains": sorted({item.role for item in spec_matches}),
        "modeling_disposition": incomplete_reasons,
        "document_evidence": _evidence(document_text, probe.document_patterns, "pdf_chapter"),
        "spec_evidence": _fragment_evidence(spec_matches, probe.spec_patterns),
    }
    if conflict:
        result["conflict_evidence"] = _fragment_evidence(
            conflicting_fragments, probe.conflict_patterns
        )
    return result


def audit_factor(
    factor_id: str,
    text: str,
    metadata: dict[str, Any],
    spec_root: Path,
    coverage_auditor: FactorCoverageAuditor | None = None,
) -> dict[str, Any]:
    if factor_id not in PROBES:
        raise DriftAuditError(f"尚未定义试点语义探针: {factor_id}")
    package = SpecPackage(spec_root, factor_id)
    if coverage_auditor is None:
        registry = FactorPackageRegistry(spec_root)
        registry.load_all()
        coverage_auditor = FactorCoverageAuditor(registry)
    coverage_audit = coverage_auditor.audit(factor_id)
    comparisons = [compare_probe(probe, text, package) for probe in PROBES[factor_id]]
    checks = {
        "source_binding": _source_binding_check(package, metadata),
        "source_unit_atomicity": _atomicity_check(package, coverage_audit),
        "adjacent_chapter_pollution": _boundary_check(text, metadata),
    }
    comparison_counts = Counter(item["status"] for item in comparisons)
    check_counts = Counter(item["status"] for item in checks.values())
    counts = comparison_counts + check_counts
    if set(counts) - STATUS_VALUES:
        raise AssertionError(f"非法状态: {set(counts) - STATUS_VALUES}")
    return {
        "factor_id": factor_id,
        "chapter": metadata,
        "package": {
            "directory": str(package.directory),
            "files": package.files,
            "responsibility_domains": package.responsibility_domains,
            "coverage_snapshot": {
                "conclusions": coverage_audit["conclusions"],
                "unresolved_facts": coverage_audit["facts"]["unresolved"],
                "feature_representation_gaps": coverage_audit["documented_features"]["needs_profile"],
                "feature_domain_gaps": coverage_audit["documented_features"]["not_domain_complete"],
                "unresolved_error_oracles": coverage_audit["manifests"]["unresolved_error_oracles"],
                "planned_scenarios": coverage_audit["scenarios"]["planned"],
            },
        },
        "checks": checks,
        "comparison_summary": {
            status: comparison_counts.get(status, 0) for status in sorted(STATUS_VALUES)
        },
        "check_summary": {
            status: check_counts.get(status, 0) for status in sorted(STATUS_VALUES)
        },
        "summary": {status: counts.get(status, 0) for status in sorted(STATUS_VALUES)},
        "comparisons": comparisons,
    }


def _parse_mapping(values: list[str], option: str) -> dict[str, str]:
    result: dict[str, str] = {}
    for value in values:
        if "=" not in value:
            raise DriftAuditError(f"{option} 需要 FACTOR=VALUE: {value}")
        factor, mapped = value.split("=", 1)
        if factor in result:
            raise DriftAuditError(f"{option} 重复 factor: {factor}")
        result[factor] = mapped
    return result


def _load_text_inputs(
    factors: list[str], text_args: list[str], meta_args: list[str]
) -> dict[str, tuple[str, dict[str, Any]]]:
    paths = _parse_mapping(text_args, "--chapter-text")
    metadata_paths = _parse_mapping(meta_args, "--chapter-metadata")
    loaded = {}
    for factor_id in factors:
        if factor_id not in paths:
            raise DriftAuditError(f"{factor_id}: 缺少 --chapter-text {factor_id}=PATH")
        path = Path(paths[factor_id])
        text = path.read_text(encoding="utf-8")
        metadata = (
            json.loads(Path(metadata_paths[factor_id]).read_text(encoding="utf-8"))
            if factor_id in metadata_paths else {}
        )
        metadata.setdefault("mode", "unknown")
        metadata.setdefault("chapter_text_path", str(path.resolve()))
        metadata.setdefault("chapter_sha256", sha256_bytes(text.encode("utf-8")))
        metadata.setdefault("line_count", len(text.splitlines()))
        loaded[factor_id] = (text, metadata)
    return loaded


def _load_catalog_inputs(
    factors: list[str], catalog_path: Path, corpus_root: Path | None = None
) -> dict[str, tuple[str, dict[str, Any]]]:
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    root = (corpus_root or catalog_path.parent).resolve()
    chapters = catalog.get("chapters", [])
    outline = catalog.get("outline", [])
    loaded: dict[str, tuple[str, dict[str, Any]]] = {}
    for factor_id in factors:
        expected_title = factor_id.replace("_", " ").upper()
        matches = [
            item for item in chapters
            if item.get("variant") == "general"
            and normalize_text(str(item.get("title", ""))).upper() == expected_title
        ]
        if len(matches) != 1:
            raise DriftAuditError(
                f"{factor_id}: catalog 中预期唯一 general/{expected_title}，"
                f"实际找到 {len(matches)} 个"
            )
        chapter = matches[0]
        text_path = root / chapter["source_relpath"]
        text = text_path.read_text(encoding="utf-8")
        actual_hash = sha256_bytes(text.encode("utf-8"))
        if actual_hash != chapter.get("chapter_sha256"):
            raise DriftAuditError(
                f"{factor_id}: catalog chapter_sha256 与 {text_path} 不一致"
            )

        next_title = None
        chapter_path = chapter.get("outline_path", [])
        outline_match = next(
            (item for item in outline if item.get("outline_path") == chapter_path), None
        )
        if outline_match is not None:
            start_index = int(outline_match.get("index", -1))
            depth = int(outline_match.get("depth", len(chapter_path) - 1))
            following = sorted(
                (
                    item for item in outline
                    if int(item.get("index", -1)) > start_index
                    and int(item.get("depth", 10**9)) <= depth
                ),
                key=lambda item: int(item.get("index", -1)),
            )
            if following:
                next_title = following[0].get("outline_path", [None])[-1]

        metadata = {
            **chapter,
            "mode": "catalog_outline_bbox",
            "chapter_text_path": str(text_path),
            "parent_pdf_path": catalog.get("parent_pdf_path"),
            "parent_pdf_sha256": catalog.get("parent_pdf_sha256"),
            "product_version": catalog.get("product_version"),
            "document_version": catalog.get("document_version"),
            "document_id": catalog.get("document_id"),
            "extraction_rule_version": catalog.get("extraction_rule_version"),
            "line_count": len(text.splitlines()),
        }
        metadata.setdefault("end_destination", {})
        metadata["end_destination"] = {
            **metadata["end_destination"],
            "next_sibling_title": next_title,
        }
        loaded[factor_id] = (text, metadata)
    return loaded


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="审计 PDF 章节与现有 Factor Package 的语义漂移；绝不改写 specs。"
    )
    parser.add_argument("--factor", action="append", choices=sorted(PROBES), help="校准因子，可重复；默认五项")
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--pdf", type=Path, help="原始 PDF；按精确 outline path 与页面内坐标裁剪")
    source.add_argument("--chapter-text", action="append", default=[], metavar="FACTOR=PATH", help="已拆章 UTF-8 文本，可重复")
    source.add_argument("--source-catalog", type=Path, help="extract_pdf_sections.py 生成的 catalog.json")
    parser.add_argument("--chapter-metadata", action="append", default=[], metavar="FACTOR=PATH", help="文本对应的 JSON 元数据，可重复")
    parser.add_argument("--corpus-root", type=Path, help="catalog 中 source_relpath 的根目录；默认 catalog 所在目录")
    parser.add_argument("--outline-path", action="append", default=[], metavar="FACTOR=A>B>C", help="覆盖默认完整书签路径")
    parser.add_argument("--spec-root", type=Path, default=ROOT_DIR / "specs")
    parser.add_argument("--output", type=Path, default=ROOT_DIR / "generated" / "audit" / "pdf_factor_drift_pilot.json")
    parser.add_argument("--fail-on-conflict", action="store_true", help="发现 conflicting 时返回 1")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    factors = args.factor or sorted(PROBES)
    try:
        if args.pdf:
            overrides = _parse_mapping(args.outline_path, "--outline-path")
            outline_paths = {}
            for factor_id in factors:
                outline_paths[factor_id] = tuple(
                    overrides.get(factor_id, ">").split(">")
                    if factor_id in overrides else DEFAULT_OUTLINE_PATHS[factor_id]
                )
            inputs = extract_pdf_chapters(args.pdf, outline_paths)
        elif args.source_catalog:
            inputs = _load_catalog_inputs(
                factors, args.source_catalog, args.corpus_root
            )
        else:
            inputs = _load_text_inputs(factors, args.chapter_text, args.chapter_metadata)

        registry = FactorPackageRegistry(args.spec_root)
        registry.load_all()
        coverage_auditor = FactorCoverageAuditor(registry)
        audits = {
            factor_id: audit_factor(
                factor_id,
                inputs[factor_id][0],
                inputs[factor_id][1],
                args.spec_root,
                coverage_auditor,
            )
            for factor_id in factors
        }
        totals = Counter()
        for audit in audits.values():
            totals.update({status: count for status, count in audit["summary"].items()})
        report = {
            "schema_version": 1,
            "kind": "pdf_factor_drift_audit",
            "status_semantics": {
                "unchanged": "PDF 事实与现有规格职责域一致",
                "changed": "同一事实存在但来源绑定或建模完整度已变化",
                "conflicting": "PDF 与现有规格存在相反陈述或结构冲突",
                "added": "PDF 新增事实，现有规格职责域未表示",
                "missing": "现有规格项在本次章节中找不到依据，或切章缺失",
            },
            "inputs": {
                "spec_root": str(args.spec_root.resolve()),
                "factors": factors,
                "responsibility_domains": [
                    "factor", "source_ledger", "syntax", "matrix",
                    "manifest", "scenario", "fixture",
                ],
            },
            "summary": {status: totals.get(status, 0) for status in sorted(STATUS_VALUES)},
            "factors": audits,
        }
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
        print(json.dumps({"output": str(args.output), "summary": report["summary"]}, ensure_ascii=False))
        return 1 if args.fail_on_conflict and totals.get("conflicting", 0) else 0
    except (DriftAuditError, OSError, ValueError, yaml.YAMLError) as exc:
        print(f"PDF factor drift audit failed: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
