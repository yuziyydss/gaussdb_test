"""有限 facet 代表关系审计。

原 conditional/invalid 值保留身份与条件性；当同维度中一个已被清单选中的
有限 facet 通过 original_value_ref 显式指向它时，该原值获得代表性生成证据，
不再计入 value coverage gap。facet 未被选中、链接缺失或跨维度时不得放行。
"""
import os
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageRegistry


class TestFiniteFacetRepresentation(unittest.TestCase):
    def setUp(self):
        self.root = Path(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        self.registry = FactorPackageRegistry(self.root / "specs")
        self.registry.load_all()
        self.auditor = FactorCoverageAuditor(self.registry)

    def test_conditional_encoding_represented_by_selected_template0_facet(self):
        audit = self.auditor.audit("create_database")
        gaps = set(audit["values"]["coverage_gaps"])
        for value_id in (
            "create_database_encoding_euc_cn",
            "create_database_encoding_gb18030",
            "create_database_encoding_sql_ascii",
            "create_database_encoding_zhs16gbk",
        ):
            self.assertNotIn(f"encoding.{value_id}", gaps)
        represented = set(audit["values"]["represented_by_finite_facet"])
        self.assertIn("encoding.create_database_encoding_euc_cn", represented)
        self.assertEqual(len(represented), 37)

    def test_unselected_facet_does_not_close_conditional_gap(self):
        manifest = self.registry.manifests["manifest_create_database_server_encoding_c"]
        binding = manifest.bindings["encoding"]
        removed = "create_database_encoding_euc_cn_c_template0"
        manifest.bindings["encoding"] = [v for v in binding if v != removed]
        try:
            audit = self.auditor.audit("create_database")
            self.assertIn(
                "encoding.create_database_encoding_euc_cn",
                audit["values"]["coverage_gaps"],
            )
        finally:
            manifest.bindings["encoding"] = binding

    def test_missing_original_value_ref_does_not_close_gap(self):
        factor = self.registry.factors["create_database"]
        encoding = factor.dimensions["encoding"]
        profile = next(
            value
            for cls in encoding.classes
            if cls.id == "create_database_encoding_c_template0_profiles"
            for value in cls.values
            if value.id == "create_database_encoding_euc_cn_c_template0"
        )
        original = dict(profile.properties)
        try:
            profile.properties.pop("original_value_ref", None)
            audit = self.auditor.audit("create_database")
            self.assertIn(
                "encoding.create_database_encoding_euc_cn",
                audit["values"]["coverage_gaps"],
            )
        finally:
            profile.properties = original

    def test_sequence_finite_facets_represent_original_values(self):
        audit = self.auditor.audit("create_sequence")
        gaps = set(audit["values"]["coverage_gaps"])
        self.assertNotIn("increment_clause.cs_increment_float_b", gaps)
        self.assertNotIn("owned_by_clause.cs_owned_rowid_invalid", gaps)
        represented = set(audit["values"]["represented_by_finite_facet"])
        self.assertIn("increment_clause.cs_increment_float_b", represented)
        self.assertIn("owned_by_clause.cs_owned_rowid_invalid", represented)


if __name__ == "__main__":
    unittest.main()
