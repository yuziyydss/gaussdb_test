"""Independent finite-scope checks for the first twelve-package quality review."""
import itertools
import re
import unittest
from pathlib import Path

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
REVIEW_FACTORS = ('create_schema', 'drop_schema', 'grant', 'update', 'delete',
                  'insert_all', 'replace', 'create_table_partition',
                  'create_table_subpartition', 'alter_table_partition',
                  'alter_table_subpartition', 'copy')


class QualityRound01Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.cases = {fid: [c for mid in cls.registry.factors[fid].manifest_refs
                          for c in cls.generator.generate_with_report(cls.registry.manifests[mid])[0]]
                     for fid in REVIEW_FACTORS}

    def test_authorized_schema_is_transaction_scoped_without_role_cleanup(self):
        cases = [c for c in self.cases['create_schema'] if 'AUTHORIZATION' in c.sql]
        self.assertEqual(len(cases), 2)
        for c in cases:
            self.assertEqual(c.setup_sqls, ['BEGIN;'])
            self.assertEqual(c.teardown_sqls, ['ROLLBACK;'])
            self.assertEqual(c.expected_scope, 'syntax_only')
            self.assertFalse(any('DROP ROLE' in s or 'DROP OWNED' in s
                                 for s in c.setup_sqls + c.teardown_sqls))

    def test_copy_format_uses_documented_quoted_option(self):
        for c in [x for x in self.cases['copy'] if x.expected == 'success']:
            self.assertRegex(c.sql, r"FORMAT '(?:text|csv)'[,)]")
            self.assertIn('TO STDOUT', c.sql)
            if "FORMAT 'text'" in c.sql:
                self.assertNotIn('HEADER', c.sql)
                self.assertNotIn('FORCE_QUOTE', c.sql)

    def test_partition_dml_uses_real_provider_columns_and_seed(self):
        for fid in ('update', 'delete'):
            selected = [c for c in self.cases[fid] if 'b11_' in c.sql]
            self.assertTrue(selected, fid)
            for c in selected:
                is_sub = 'b11_sub_source' in c.sql
                table = 'fp_cs_one.b11_sub_source' if is_sub else 'fp_cs_one.b11_range_source'
                setup = '\n'.join(c.setup_sqls)
                self.assertIn('CREATE TABLE ' + table + ' (col_1 INT, col_2 INT)', setup)
                self.assertIn('INSERT INTO ' + table, setup)
                self.assertIn('BEGIN;', c.setup_sqls)
                self.assertEqual(c.teardown_sqls[0], 'ROLLBACK;')
                self.assertNotRegex(c.sql, r'\b(?:id|note|qty)\b')
                if fid == 'update':
                    # Both columns are partition keys in the two-level provider.
                    # A syntax-only assignment must not route rows out of its leaf.
                    self.assertIn('SET col_2 = col_2', c.sql)
                    self.assertNotIn('SET col_1', c.sql)
                self.assertEqual(c.expected_scope, 'syntax_only')
            for clause in ('PARTITION (p1)', 'PARTITION FOR (1)',
                           'SUBPARTITION (p1s1)', 'SUBPARTITION FOR (1,1)'):
                self.assertTrue(any(clause in c.sql for c in selected), (fid, clause))

    def test_partition_dependency_and_inactive_defaults(self):
        for fid in ('update', 'delete'):
            for c in self.cases[fid]:
                if 'b11_' not in c.sql:
                    continue
                self.assertTrue(any(ref.startswith('fixture_create_table_') for ref in c.preconditions))
                self.assertFalse(any('t_update_' in s or 't_delete_' in s for s in c.setup_sqls))

    def test_pdf_optional_delete_source_is_not_removed(self):
        self.assertTrue(any(re.fullmatch(r'DELETE t_delete_target, t_delete_aux AS a;', c.sql)
                            for c in self.cases['delete']))

    def test_update_cte_and_alias_are_not_rewritten_to_other_dialects(self):
        self.assertTrue(any(c.sql.startswith('WITH ') and ') UPDATE ' in c.sql
                            for c in self.cases['update']))
        self.assertTrue(any(' AS u SET u.note' in c.sql for c in self.cases['update']))

    def test_insert_all_conditions_and_single_row_values(self):
        for c in [x for x in self.cases['insert_all'] if x.expected == 'success']:
            self.assertIn('SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source', c.sql)
            self.assertTrue(c.sql.endswith(';'))
            self.assertNotRegex(c.sql, r'VALUES\s*\([^)]*\)\s*,\s*\(')
            self.assertEqual({g['key']: g['allowed_values'] for g in c.environment_requirements}
                             ['sql_compatibility'], ['A'])
            if ' WHEN ' not in c.sql:
                self.assertTrue(c.sql.startswith('INSERT ALL '))

    def test_replace_projection_matches_two_int_target(self):
        for c in self.cases['replace']:
            self.assertTrue(any('col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2' in s for s in c.setup_sqls))
            if ' SELECT ' in c.sql:
                self.assertIn('SELECT col_1,col_2 FROM fp_cs_one.b11_replace_source', c.sql)
            if ' SET ' in c.sql:
                self.assertIn('col_1 = col_1 + 1', c.sql)

    def test_partition_bounds_and_nine_layouts(self):
        layouts = set()
        for c in self.cases['create_table_subpartition']:
            layouts.add(tuple(re.findall(r'(?:SUB)?PARTITION BY (RANGE|LIST|HASH)', c.sql)))
            names = re.findall(r'(?:SUB)?PARTITION (p[12](?:s[12])?)\b', c.sql)
            self.assertEqual(len(names), len(set(names)))
        self.assertEqual(layouts, set(itertools.product(('RANGE', 'LIST', 'HASH'), repeat=2)))
        for c in self.cases['create_table_partition']:
            if 'INTERVAL' in c.sql:
                self.assertIn('col_1 TIMESTAMP', c.sql)
        for fid in ('alter_table_partition', 'alter_table_subpartition'):
            for c in self.cases[fid]:
                if ' SPLIT ' in c.sql:
                    self.assertIn('AT (15)', c.sql)
                    self.assertTrue(any('VALUES LESS THAN (20)' in s for s in c.setup_sqls))
                if ' MERGE SUBPARTITIONS ' in c.sql:
                    self.assertIn('p1s1,p1s2', c.sql)

    def test_grant_public_never_gets_grant_option_in_positive(self):
        for c in self.cases['grant']:
            if c.expected == 'success' and 'TO PUBLIC' in c.sql:
                self.assertNotIn('WITH GRANT OPTION', c.sql)
            if c.expected == 'success' and 'ON TABLE' in c.sql:
                self.assertNotIn('GRANT CREATE ON TABLE', c.sql)

    def test_drop_schema_targets_are_fixture_owned(self):
        for c in self.cases['drop_schema']:
            self.assertIn('search_path_excludes_test_schemas', {g['key'] for g in c.environment_requirements})
            self.assertNotRegex(c.sql, r'\b(?:public|pg_catalog|pg_temp)\b')
            self.assertTrue(any(s == 'CREATE SCHEMA fp_cs_one;' for s in c.setup_sqls))

    def test_case_identity_unique_across_review_set(self):
        cases = [c for cs in self.cases.values() for c in cs]
        self.assertEqual(len(cases), len({c.case_id for c in cases}))


if __name__ == '__main__':
    unittest.main()
