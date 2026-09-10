"""Finite C/template0 encoding profiles must not silently become generic support."""
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_database_server_encoding_c'


class CreateDatabaseEncodingContextTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def manifest(self):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.r.manifests[MID].model_copy(deep=True)

    def test_37_server_encodings_have_finite_context_not_reclassified_originals(self):
        cases, report = self.g.generate_with_report(self.manifest())
        values = self.r.resolve_dimension_values('create_database')['encoding']
        original = {k: v for k, v in values.items() if v.validity == 'conditional'}
        self.assertEqual(len(original), 37)
        self.assertEqual(len(cases), 37)
        self.assertEqual(len({c.case_id for c in cases}), 37)
        self.assertEqual(len({c.sql for c in cases}), 37)
        self.assertTrue(report.pairwise_complete)
        for case in cases:
            profile = values[case.params['encoding']]
            origin = profile.attributes['encoding.properties.original_value_ref']
            self.assertIn(origin, original)
            self.assertEqual(profile.render, original[origin].render)
            self.assertIs(original[origin].attributes['encoding.properties.server_supported'], True)
            self.assertIn("TEMPLATE = template0 ENCODING = " + profile.render + " LC_COLLATE = 'C' LC_CTYPE = 'C'", case.sql)

    def test_context_mutations_cannot_reuse_valid_profile(self):
        manifest = self.manifest()
        syntax = self.r.syntaxes[manifest.syntax_ref]
        original = syntax.production
        try:
            for before, after in [('template0', 'template1'), ("LC_COLLATE = 'C'", "LC_COLLATE = 'en_US.UTF8'"),
                                  ("LC_CTYPE = 'C'", "LC_CTYPE = 'POSIX'"), ("DBCOMPATIBILITY = 'PG'", "DBCOMPATIBILITY = 'M'")]:
                with self.subTest(after=after):
                    syntax.production = original.replace(before, after)
                    with self.assertRaises(GenerationValidationError):
                        self.g.generate_with_report(manifest)
        finally:
            syntax.production = original

    def test_missing_environment_or_cleanup_fails_closed(self):
        manifest = self.manifest()
        for key in ('locale_available', 'autocommit_no_transaction_block', 'database_recyclebin', 'createdb_authorized'):
            with self.subTest(key=key):
                changed = manifest.model_copy(deep=True)
                changed.environment_requirements = [g for g in changed.environment_requirements if g.key != key]
                with self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(changed)
        changed = manifest.model_copy(deep=True)
        changed.fixture_refs = []
        with self.assertRaises(GenerationValidationError):
            self.g.generate_with_report(changed)

    def test_profile_cannot_lie_about_source_encoding(self):
        self.manifest()
        encoding = self.r.factors['create_database'].dimensions['encoding']
        profile = next(c for c in encoding.classes if c.id == 'create_database_encoding_c_template0_profiles').values[0]
        old_render = profile.render
        try:
            profile.render = "'BIG5'"
            with self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(self.manifest())
        finally:
            profile.render = old_render

    def test_database_lifecycle_is_not_ordinary_schema_execution(self):
        cases, _ = self.g.generate_with_report(self.manifest())
        for case in cases:
            self.assertEqual(case.teardown_sqls, ['DROP DATABASE b8_database;'])
            self.assertEqual(len(case.setup_sqls), 1)
            self.assertIn("datname = 'b8_database'", case.setup_sqls[0])
            self.assertEqual(case.expected, 'success')
            self.assertEqual(case.expected_scope, 'syntax_only')
            self.assertNotIn('PURGE', ' '.join(case.teardown_sqls))

    def test_missing_contract_and_duplicate_gates_are_rejected(self):
        manifest = self.manifest()
        manifest.environment_requirements.append(manifest.environment_requirements[0].model_copy(deep=True))
        with self.assertRaises(GenerationValidationError):
            self.g.generate_with_report(manifest)
        encoding = self.r.factors['create_database'].dimensions['encoding']
        profile = next(c for c in encoding.classes if c.id == 'create_database_encoding_c_template0_profiles').values[0]
        properties = dict(profile.properties)
        try:
            profile.properties.pop('encoding_contract')
            with self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(self.manifest())
        finally:
            profile.properties = properties

    def test_shared_existing_asset_does_not_create_a_package_cycle(self):
        fixture = self.r.fixtures['fixture_create_database_existing_database']
        self.assertIsNone(fixture.factor_ref)
        for ref in ('fixture_alter_database_existing_database', 'fixture_drop_database_existing_database'):
            self.assertIn(fixture.id, self.r.fixture_topological_order([ref]))
        self.assertIn('drop_database', self.r.factor_dependency_graph()['create_database'])
        self.assertNotIn('create_database', self.r.factor_dependency_graph()['drop_database'])
        self.r.factor_topological_order()


if __name__ == '__main__':
    unittest.main()
