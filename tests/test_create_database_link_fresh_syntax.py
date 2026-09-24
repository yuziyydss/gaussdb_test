"""CREATE DATABASE LINK uses secret-free static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_database_link_fresh_syntax'
EXPECTED={
    "CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');",
    "CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');",
    "CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (dbserver 'oracle-static-syntax.invalid');",
    "CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (dbserver 'oracle-static-syntax.invalid');",
}


class CreateDatabaseLinkFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        for mid in self.r.factors['create_database_link'].manifest_refs:
            yield from self.g.generate_with_report(self.r.manifests[mid])[0]

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_create_database_link_coverage'].documented_features}
        feature=features['create_database_link_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        audit=FactorCoverageAuditor(self.r).audit('create_database_link')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertIn('create_database_link_feature_runtime',
                      audit['documented_features']['needs_profile'])
        self.assertIn('create_database_link_feature_syntax_conflict',
                      audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
