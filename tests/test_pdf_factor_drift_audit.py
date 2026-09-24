from __future__ import annotations

import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from scripts.audit_pdf_factor_drift import (
    DEFAULT_OUTLINE_PATHS,
    PROBES,
    OutlineEntry,
    SpecPackage,
    _load_catalog_inputs,
    _source_binding_check,
    audit_factor,
    select_outline_entry,
)


ROOT = Path(__file__).resolve().parents[1]


def metadata(factor: str, title: str, text: str, next_title: str) -> dict:
    return {
        "mode": "pdf_outline_bbox",
        "outline_path": ["1 SQL参考", "1.13 SQL语法", title],
        "end_destination": {"next_sibling_title": next_title},
        "product_version": "V2.0-10.0.0",
        "parent_pdf_sha256": "f" * 64,
        "chapter_sha256": hashlib.sha256(text.encode("utf-8")).hexdigest(),
        "factor": factor,
    }


def comparison_map(report: dict) -> dict[str, dict]:
    return {item["id"]: item for item in report["comparisons"]}


class PdfFactorDriftAuditTests(unittest.TestCase):
    def test_extractor_catalog_is_consumed_with_hash_and_next_boundary(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            chapter_path = root / "general/ddl/create_view.txt"
            chapter_path.parent.mkdir(parents=True)
            chapter_text = (
                "[[PDF_PAGE physical=10 printed=1]]\n"
                "1.13.9.60 CREATE VIEW\n功能描述\n"
            )
            chapter_path.write_text(chapter_text, encoding="utf-8")
            chapter_outline = ["1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.60 CREATE VIEW"]
            next_outline = ["1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.61 NEXT"]
            catalog = {
                "parent_pdf_path": "/tmp/source.pdf",
                "parent_pdf_sha256": "a" * 64,
                "product_version": "V2.0-10.0.0",
                "document_version": "01",
                "chapters": [{
                    "variant": "general",
                    "title": "CREATE VIEW",
                    "source_relpath": "general/ddl/create_view.txt",
                    "outline_path": chapter_outline,
                    "chapter_sha256": hashlib.sha256(chapter_text.encode()).hexdigest(),
                    "end_destination": {"physical_page": 11},
                }],
                "outline": [
                    {"index": 10, "depth": 3, "outline_path": chapter_outline},
                    {"index": 11, "depth": 3, "outline_path": next_outline},
                ],
            }
            catalog_path = root / "catalog.json"
            catalog_path.write_text(json.dumps(catalog), encoding="utf-8")

            loaded = _load_catalog_inputs(["create_view"], catalog_path)
            text, loaded_metadata = loaded["create_view"]
            self.assertEqual(text, chapter_text)
            self.assertEqual(loaded_metadata["mode"], "catalog_outline_bbox")
            self.assertEqual(
                loaded_metadata["end_destination"]["next_sibling_title"],
                "1.13.9.61 NEXT",
            )

    def test_outline_requires_exact_full_path_and_uses_next_sibling(self):
        entries = [
            OutlineEntry(("general", "CREATE VIEW"), 10, 700.0, 0),
            OutlineEntry(("general", "CREATE VIEW", "example"), 11, 600.0, 1),
            OutlineEntry(("general", "CREATE WEAK PASSWORD DICTIONARY"), 12, 500.0, 2),
            OutlineEntry(("compat", "CREATE VIEW"), 20, 400.0, 3),
        ]
        start, end = select_outline_entry(entries, ("general", "CREATE VIEW"))
        self.assertEqual(start.page_index, 10)
        self.assertEqual(end.title, "CREATE WEAK PASSWORD DICTIONARY")

        with self.assertRaisesRegex(Exception, "必须唯一精确匹配"):
            select_outline_entry(entries, ("CREATE VIEW",))

    def test_create_view_pdf_rebuild_preserves_core_and_records_atomicity(self):
        text = """
1.13.9.60 CREATE VIEW
功能描述
注意事项
语法格式
CREATE [ OR REPLACE ] [ TEMP | TEMPORARY ] [ FORCE ] VIEW view_name
[ WITH ( view_option_name = view_option_value ) ] AS query
[ WITH CHECK OPTION | WITH READ ONLY ];
说明 security_barrier 可以保护隐藏数据。
参数说明
引用的任何表是临时表，视图将被创建为临时视图。
指定 FORCE 后，创建视图时如果视图依赖的对象不存在，该视图仍能够创建成功。
指定分区的 OID 发生变化会导致视图失效。
示例
SELECT * FROM information_schema.columns WHERE is_updatable = 'YES';
"""
        report = audit_factor(
            "create_view",
            text,
            metadata("create_view", "1.13.9.60 CREATE VIEW", text, "1.13.9.61 CREATE WEAK PASSWORD DICTIONARY"),
            ROOT / "specs",
        )
        comparisons = comparison_map(report)
        for probe_id in (
            "cv_or_replace", "cv_temp", "cv_force", "cv_view_options",
            "cv_check_option", "cv_read_only",
        ):
            self.assertEqual(comparisons[probe_id]["status"], "unchanged", probe_id)
        self.assertEqual(comparisons["cv_security_barrier"]["status"], "changed")
        self.assertIn(
            "planned_scenario",
            comparisons["cv_security_barrier"]["modeling_disposition"],
        )

        self.assertEqual(report["checks"]["source_binding"]["status"], "changed")
        self.assertFalse(report["checks"]["source_binding"]["hash_bound"])
        self.assertTrue(report["checks"]["source_binding"]["version_bound"])
        atomicity = report["checks"]["source_unit_atomicity"]
        self.assertEqual(atomicity["status"], "unchanged")
        self.assertEqual(atomicity["unit_count"], 116)
        self.assertEqual(atomicity["missing_atomicity"], [])
        self.assertEqual(atomicity["gap_count"], 0)
        self.assertEqual(atomicity["gaps"], [])
        self.assertEqual(
            report["checks"]["adjacent_chapter_pollution"]["status"], "unchanged"
        )

    def test_create_index_drift_probes_follow_the_pdf_rebuilt_package(self):
        text = """
1.13.9.27 CREATE INDEX
功能描述
注意事项
在线创建索引的类型只支持 B-Tree 索引和 UB-Tree 索引。
UGIN 索引目前仅支持 Ustore 存储引擎。
GIN、GiST 索引仅支持 Astore 存储引擎。
不支持XML类型数据作为普通索引。也不支持创建包含rowid，rowno系统列的索引。
当SQL语句长度大于等于5250字符时会上报一条WARNING。
语法格式
在表上创建索引
CREATE INDEX ON table_name USING method
( column_name [ ( length ) ] [ COLLATE collation ] [ opclass ] )
[ ILM ADD POLICY ROW STORE COMPRESS NONE ]
[ TABLESPACE tablespace_name ] [ COMMENT 'string' ] [ VISIBLE | INVISIBLE ] [ WHERE predicate ];
在分区表上创建索引
CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ IF NOT EXISTS ] index_name ON table_name USING method (...);
参数说明
method 支持 btree、ubtree、ugin、gin、gist。
示例
"""
        report = audit_factor(
            "create_index",
            text,
            metadata("create_index", "1.13.9.27 CREATE INDEX", text, "1.13.9.28 CREATE LANGUAGE"),
            ROOT / "specs",
        )
        comparisons = comparison_map(report)
        for probe_id in ("ci_method_ubtree", "ci_method_ugin", "ci_method_gin", "ci_method_gist"):
            self.assertEqual(comparisons[probe_id]["status"], "unchanged", probe_id)
        for probe_id in (
            "ci_partition_concurrently", "ci_partition_if_not_exists",
            "ci_partial_where", "ci_ilm_policy",
        ):
            self.assertEqual(comparisons[probe_id]["status"], "unchanged", probe_id)
        for probe_id in ("ci_key_prefix_length", "ci_key_collation", "ci_key_opclass"):
            self.assertEqual(comparisons[probe_id]["status"], "unchanged", probe_id)
        for probe_id in ("ci_clause_order", "ci_method_catalog"):
            self.assertEqual(comparisons[probe_id]["status"], "unchanged", probe_id)

        method_roles = set(comparisons["ci_method_catalog"]["spec_responsibility_domains"])
        self.assertIn("matrix", method_roles)
        self.assertEqual(report["comparison_summary"]["conflicting"], 0)

    def test_select_finds_unregistered_subchapters_and_restored_xml_example(self):
        headings = "\n".join(
            f"1.13.19.3.{index} {heading}"
            for index, heading in enumerate((
                "简单查询", "条件查询", "分组查询", "分页查询", "分区查询", "连接查询",
                "子查询", "层次查询", "复合查询", "行转列与列转行", "窗口函数查询",
                "简化版查询", "Hint 查询",
            ), 1)
        )
        text = f"""
1.13.19.3 SELECT
功能描述
注意事项
语法格式
WITH [ RECURSIVE ] with_query SELECT target_list FROM from_item
WHERE condition START WITH condition CONNECT BY condition
GROUP BY expression HAVING condition WINDOW window_name AS (...)
UNION SELECT ... INTERSECT SELECT ... EXCEPT | MINUS SELECT ...
LIMIT 1 OFFSET 1 FETCH FIRST 1 ROW ONLY
FOR {{ UPDATE | NO KEY UPDATE | SHARE }}
from_item unpivot_clause from_item pivot_clause
参数说明
SELECT * FROM XMLTABLE(XMLNAMESPACES('nspace1' AS "ns1"), '/ns1:root'
PASSING xmltype('<root xmlns="nspace1"><child/></root>'));
{headings}
"""
        report = audit_factor(
            "select",
            text,
            metadata("select", "1.13.19.3 SELECT", text, "1.13.19.4 SELECT INTO"),
            ROOT / "specs",
        )
        comparisons = comparison_map(report)
        subsection_ids = [f"select_subsection_{index:02d}" for index in range(1, 14)]
        self.assertTrue(all(comparisons[item]["status"] == "unchanged" for item in subsection_ids))
        self.assertEqual(
            comparisons["select_xmltable_example_restored"]["status"], "changed"
        )
        self.assertIn(
            "planned_scenario",
            comparisons["select_xmltable_example_restored"]["modeling_disposition"],
        )
        self.assertEqual(
            comparisons["select_subchapter_examples"]["status"], "unchanged"
        )
        self.assertEqual(
            report["checks"]["source_unit_atomicity"]["missing_atomicity"],
            [],
        )
        self.assertEqual(report["checks"]["source_unit_atomicity"]["unit_count"], 373)

    def test_all_five_calibration_factors_are_supported(self):
        expected = {"create_view", "create_index", "alter_table", "insert", "select"}
        self.assertEqual(set(PROBES), expected)
        self.assertEqual(set(DEFAULT_OUTLINE_PATHS), expected)

    def test_dimension_scope_resolves_profile_matrix_and_manifest_bindings(self):
        package = SpecPackage(ROOT / "specs", "create_index")
        fragments = package.fragments("dimension:method")
        roles = {fragment.role for fragment in fragments}
        corpus = "\n".join(fragment.text for fragment in fragments)
        self.assertIn("factor", roles)
        self.assertIn("syntax", roles)
        self.assertIn("matrix", roles)
        self.assertIn("manifest", roles)
        for value in ("ci_method_btree", "ci_method_ubtree", "ci_method_ugin", "ci_method_gin", "ci_method_gist"):
            self.assertIn(value, corpus)

    def test_current_pdf_catalog_has_no_false_semantic_conflicts_for_five_factors(self):
        factors = sorted(PROBES)
        loaded = _load_catalog_inputs(factors, ROOT / "intranet_corpus/catalog.json")
        reports = {
            factor: audit_factor(factor, *loaded[factor], ROOT / "specs")
            for factor in factors
        }
        conflicts = {
            factor: [
                comparison["id"]
                for comparison in report["comparisons"]
                if comparison["status"] == "conflicting"
            ]
            for factor, report in reports.items()
        }
        self.assertEqual(conflicts, {factor: [] for factor in factors})
        self.assertTrue(all(
            report["checks"]["source_binding"]["status"] == "unchanged"
            for report in reports.values()
        ))

    def test_source_binding_requires_all_hashes_not_any_single_intersection(self):
        text, chapter = _load_catalog_inputs(
            ["create_view"], ROOT / "intranet_corpus/catalog.json"
        )["create_view"]
        self.assertTrue(text)
        package = SpecPackage(ROOT / "specs", "create_view")
        self.assertEqual(
            _source_binding_check(package, chapter)["status"],
            "unchanged",
        )

        package.source[2]["artifact_sha256"] = "b" * 64
        check = _source_binding_check(package, chapter)
        self.assertEqual(check["status"], "changed")
        self.assertIn(
            "factor 与 source ledger 的 artifact_sha256 必须完全一致",
            check["issues"],
        )

    def test_page_range_input_reports_adjacent_chapter_pollution(self):
        text = "previous example\n1.13.9.60 CREATE VIEW\n...\n1.13.9.61 NEXT\n"
        report = audit_factor(
            "create_view",
            text,
            {
                **metadata("create_view", "1.13.9.60 CREATE VIEW", text, "1.13.9.61 NEXT"),
                "mode": "page_range",
            },
            ROOT / "specs",
        )
        boundary = report["checks"]["adjacent_chapter_pollution"]
        self.assertEqual(boundary["status"], "conflicting")
        self.assertGreaterEqual(len(boundary["issues"]), 2)


if __name__ == "__main__":
    unittest.main()
