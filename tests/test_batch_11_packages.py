"""PDF-grounded finite partition/DML/recovery scopes, without DB execution."""
import hashlib
import itertools
import json
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class Batch11Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.plan = json.loads((ROOT / 'tests/data/batch_11.json').read_text())
        cls.factors = {f.id: f for f in cls.registry.factors.values()
                       if f.name in cls.plan['new_chapters']}
        cls.generated = {mid: cls.generator.generate_with_report(cls.registry.manifests[mid])
                         for f in cls.factors.values() for mid in f.manifest_refs}

    def cases(self, fid):
        return [c for mid in self.factors[fid].manifest_refs for c in self.generated[mid][0]]

    def test_batch_count_and_pdf_identity(self):
        self.assertEqual(len(self.factors), 25)
        path = ROOT / self.plan['source_catalog']
        if not path.exists():
            self.skipTest('Local PDF corpus is not distributed')
        chapters = {c['title']: c for c in json.loads(path.read_text())['chapters']}
        for f in self.factors.values():
            raw = (path.parent / chapters[f.name]['source_relpath']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), f.source.artifact_sha256)
            self.assertEqual(len(raw.decode().splitlines()),
                             self.registry.source_ledgers[f.source_ledger_ref].source_line_count)

    def test_source_units_and_consumers(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid in self.factors:
            a = auditor.audit(fid)
            self.assertTrue(a['conclusions']['source_extraction_complete'], fid)
            self.assertEqual(a['source_units']['atomicity']['gaps'], [], fid)
            self.assertEqual(a['facts']['unconsumed_confirmed'], [], fid)
            self.assertEqual(a['facts']['wrong_consumer_type'], [], fid)

    def test_status_is_not_database_verified(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, f in self.factors.items():
            self.assertEqual(f.status, 'needs_review')
            self.assertFalse(auditor.audit(fid)['conclusions']['behavior_coverage_complete'])

    def test_only_internal_explain_autohint_has_no_manifest(self):
        expected = set()
        self.assertEqual({fid for fid, f in self.factors.items() if not f.manifest_refs}, expected)
        # LOAD DATA now has real local bytes, but is still gated on server deployment.
        load_cases = self.cases('load_data')
        self.assertEqual(len(load_cases), 2)
        self.assertTrue(all(c.file_assets and not c.file_assets[0]['deployed'] for c in load_cases))

    def test_pairwise_projection_is_independently_checked(self):
        ids = []
        for mid, (cases, report) in self.generated.items():
            m = self.registry.manifests[mid]
            keys = sorted(m.bindings)
            expected = {pair for values in itertools.product(*(m.bindings[k] for k in keys))
                        for pair in itertools.combinations(zip(keys, values), 2)}
            actual = {pair for c in cases for pair in
                      itertools.combinations([(k, c.params[k]) for k in keys], 2)}
            self.assertEqual(actual, expected, mid)
            self.assertFalse(report.missing_pairs, mid)
            ids.extend(c.case_id for c in cases)
        self.assertEqual(len(ids), len(set(ids)))

    def test_no_duplicate_sql_within_factor(self):
        for fid in self.factors:
            sql = [c.sql for c in self.cases(fid)]
            self.assertEqual(len(sql), len(set(sql)), fid)

    def test_partition_interval_uses_temporal_key(self):
        cases = self.cases('create_table_partition')
        self.assertTrue(any('INTERVAL' in c.sql for c in cases))
        for c in cases:
            if 'INTERVAL' in c.sql:
                self.assertIn('col_1 TIMESTAMP', c.sql)
                self.assertIn("INTERVAL ('1 day')", c.sql)
                self.assertNotIn('MAXVALUE', c.sql)

    def test_subpartition_all_nine_layouts(self):
        actual = {(a, b) for c in self.cases('create_table_subpartition')
                  for a in ('RANGE', 'LIST', 'HASH') for b in ('RANGE', 'LIST', 'HASH')
                  if f'PARTITION BY {a} (col_1)' in c.sql
                  and f'SUBPARTITION BY {b} (col_2)' in c.sql}
        self.assertEqual(actual, set(itertools.product(('RANGE', 'LIST', 'HASH'), repeat=2)))

    def test_alter_partition_has_real_partition_and_data(self):
        for fid, name in [('alter_table_partition', 'b11_range_source'),
                          ('alter_table_subpartition', 'b11_sub_source')]:
            for c in self.cases(fid):
                self.assertTrue(any('CREATE TABLE fp_cs_one.' + name in s
                                    and 'PARTITION BY' in s for s in c.setup_sqls))
                self.assertTrue(any('INSERT INTO fp_cs_one.' + name in s for s in c.setup_sqls))
                self.assertNotIn(' ONLINE ', c.sql)
                self.assertIn('ROLLBACK;', c.teardown_sqls)

    def test_merge_uses_astore_and_same_parent(self):
        for fid in ('alter_table_partition', 'alter_table_subpartition'):
            for c in self.cases(fid):
                if 'MERGE ' not in c.sql:
                    continue
                self.assertTrue(any('storage_type=astore' in s for s in c.setup_sqls))
                if fid.endswith('subpartition'):
                    self.assertIn('MERGE SUBPARTITIONS p1s1,p1s2', c.sql)

    def test_partition_as_projection_has_matching_keys(self):
        cases = self.cases('create_table_partition_subpartition_as')
        self.assertTrue(any('WITH NO DATA' in c.sql for c in cases))
        self.assertTrue(any('WITH DATA' in c.sql for c in cases))
        for c in cases:
            self.assertIn('AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source', c.sql)
            self.assertTrue(any('b11_as_source (col_1 INT, col_2 INT)' in s for s in c.setup_sqls))

    def test_copy_stdout_is_format_aware(self):
        positive_copy = [c for c in self.cases('copy') if c.expected == 'success']
        self.assertTrue(positive_copy)
        for c in positive_copy:
            self.assertIn('TO STDOUT', c.sql)
            self.assertNotIn('BINARY', c.sql)
            self.assertNotIn('FROM STDIN', c.sql)
            if "FORMAT 'text'" in c.sql:
                self.assertNotIn('HEADER', c.sql)
                self.assertNotIn('FORCE_QUOTE', c.sql)

    def test_insert_all_has_final_query_and_a_gate(self):
        for c in self.cases('insert_all'):
            if c.expected == 'success':
                self.assertIn('SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source', c.sql)
                self.assertTrue(c.sql.endswith(';'))
                self.assertEqual({g['key']: g['allowed_values'] for g in c.environment_requirements}
                                 ['sql_compatibility'], ['A'])
                if ' WHEN ' not in c.sql:
                    self.assertTrue(c.sql.startswith('INSERT ALL '))
            else:
                self.assertEqual(c.expected, 'error')
            self.assertNotIn('ELSE', c.sql)

    def test_replace_forms_and_conflict_state(self):
        cases = self.cases('replace')
        for token in (' VALUES ', ' VALUE ', ' SELECT ', ' SET '):
            self.assertTrue(any(token in c.sql for c in cases), token)
        for c in cases:
            self.assertTrue(any('PRIMARY KEY DEFAULT 0' in s for s in c.setup_sqls))
            self.assertTrue(any('b11_replace_target VALUES (1,10),(2,20)' in s for s in c.setup_sqls))

    def test_snapshot_uses_owned_version_and_purge(self):
        for c in self.cases('snapshot'):
            self.assertIn('fp_cs_one.b11_snapshot @1.0', c.sql)
            self.assertIn('PURGE SNAPSHOT fp_cs_one.b11_snapshot @1.0;', c.teardown_sqls)
            self.assertFalse(any('DROP SNAPSHOT' in s for s in c.teardown_sqls))
            self.assertTrue(any(s == 'CREATE SCHEMA fp_cs_one;' for s in c.setup_sqls))

    def test_purge_is_never_global(self):
        for c in self.cases('purge'):
            self.assertNotIn('RECYCLEBIN', c.sql)
            self.assertNotIn('DATABASE', c.sql)
            self.assertIn('fp_cs_one.b11_purge_', c.sql)
            self.assertIn('DROP TABLE fp_cs_one.b11_purge_source;', c.setup_sqls)

    def test_timecapsule_has_drop_or_truncate_state_and_owned_cleanup(self):
        for c in self.cases('timecapsule_table'):
            operation = 'TRUNCATE' if 'BEFORE TRUNCATE' in c.sql else 'DROP'
            self.assertIn(operation + ' TABLE fp_cs_one.b11_flash_source;', c.setup_sqls)
            self.assertNotIn('TO CSN', c.sql)
            self.assertNotIn('TO TIMESTAMP', c.sql)
            self.assertIn('DROP TABLE IF EXISTS fp_cs_one.b11_flash_restored PURGE;', c.teardown_sqls)

    def test_model_architecture_conflict_is_preserved(self):
        f = self.factors['create_model']
        renders = {v.render for cl in f.dimensions['architecture'].classes for v in cl.values}
        self.assertEqual(renders, {'linear_regression', 'logistic_regression', 'svm_classification', 'kmeans'})
        self.assertTrue(any(x.type in {'constraint', 'environment'} and x.status == 'confirmed' and 'xgboost' in x.statement for x in f.facts))

    def test_llm_example_credential_is_not_promoted(self):
        f = self.factors['create_llm']
        self.assertTrue(any(x.type in {'constraint', 'environment'} and x.status == 'confirmed' and '7字符' in x.statement for x in f.facts))
        self.assertTrue(f.manifest_refs)
        for c in self.cases('create_llm'):
            self.assertEqual(c.expected_scope, 'syntax_only')
            self.assertIn('NOT_A_SECRET', c.sql)

    def test_generated_sql_has_no_pdf_notation_or_broad_cleanup(self):
        for cases, _ in self.generated.values():
            for c in cases:
                if c.expected == 'success':
                    self.assertEqual(c.expected_scope, 'syntax_only')
                else:
                    self.assertEqual(c.expected_scope, 'syntax_and_semantics')
                for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                    self.assertTrue(sql.endswith(';'))
                    self.assertNotRegex(sql, r'\{[a-z_]+\}|\.\.\.|gaussdb=#|\*{4}')
                    self.assertNotRegex(sql.upper(), r'DROP OWNED|EXCEPTION WHEN|STATEMENT_TIMEOUT\s*=\s*0|PURGE RECYCLEBIN')


if __name__ == '__main__':
    unittest.main()
