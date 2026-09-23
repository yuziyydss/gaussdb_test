"""PDF security/identity contracts, static only; no database connections."""
import hashlib
import itertools
import json
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class Batch09Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.plan = json.loads((ROOT / 'tests/data/batch_09.json').read_text())
        cls.factors = {f.id: f for f in cls.registry.factors.values()
                       if f.name in cls.plan['new_chapters']}

    def cases(self, mid):
        return self.generator.generate_with_report(self.registry.manifests[mid])[0]

    def factor_cases(self, fid):
        return [c for mid in self.factors[fid].manifest_refs for c in self.cases(mid)]

    def test_pdf_identity_and_batch_count(self):
        self.assertEqual(len(self.factors), 24)
        path = ROOT / self.plan['source_catalog']
        if not path.exists():
            self.skipTest('Local PDF corpus is not distributed')
        chapters = {c['title']: c for c in json.loads(path.read_text())['chapters']}
        for f in self.factors.values():
            raw = (path.parent / chapters[f.name]['source_relpath']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), f.source.artifact_sha256)
            self.assertEqual(self.registry.source_ledgers[f.source_ledger_ref].source_line_count,
                             len(raw.decode().splitlines()))

    def test_source_atomicity_and_consumers(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, f in self.factors.items():
            a = auditor.audit(fid)
            self.assertEqual(a['source_units']['atomicity']['gaps'], [], fid)
            self.assertTrue(a['conclusions']['source_extraction_complete'], fid)
            self.assertEqual(a['facts']['unconsumed_confirmed'], [], fid)
            self.assertEqual(a['facts']['wrong_consumer_type'], [], fid)
            self.assertFalse(a['conclusions']['behavior_coverage_complete'], fid)
            self.assertEqual(f.status, 'needs_review')

    def test_tool_and_global_dictionary_only_have_syntax_only_representatives(self):
        for fid in ('drop_group', 'create_weak_password_dictionary',
                    'drop_weak_password_dictionary'):
            self.assertTrue(self.factors[fid].manifest_refs, fid)
            for c in self.factor_cases(fid):
                self.assertEqual(c.expected, 'success')
                self.assertEqual(c.expected_scope, 'syntax_only')

    def test_resource_pool_dop_conflict_is_not_resolved_by_guess(self):
        for fid in ('create_resource_pool', 'alter_resource_pool'):
            f = self.factors[fid]
            self.assertTrue(any(x.type == 'environment' and x.status == 'confirmed' and 'dop' in x.id for x in f.facts))
            values = [v for d in f.dimensions.values() for c in d.classes for v in c.values]
            self.assertTrue(any('MAX_DOP' in v.render and v.validity == 'valid'
                                for v in values))
            self.assertTrue(any('MAX_DOP' in c.sql for c in self.factor_cases(fid)))

    def test_resource_pool_io_priority_domain_is_rendered_with_scope_gate(self):
        cases = self.factor_cases('create_resource_pool')
        self.assertEqual(len(cases), 18)
        sqls = '\n'.join(c.sql for c in cases)
        for value in ("Low", "Medium", "High", "None"):
            self.assertIn(f"IO_PRIORITY = '{value}'", sqls)
        priority_cases = [c for c in cases if 'IO_PRIORITY' in c.sql]
        self.assertEqual(len(priority_cases), 4)
        for case in priority_cases:
            gates = {gate['key']: gate['allowed_values']
                     for gate in case.environment_requirements}
            self.assertEqual(gates['io_control_scope'], ['complex_jobs_only'])
        audit = FactorCoverageAuditor(self.registry).audit('create_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'create_resource_pool_feature_io_priority_values']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'all')
        self.assertEqual(set(feature['selected_refs']), {
            'create_resource_pool_options_io_priority_low',
            'create_resource_pool_options_io_priority_medium',
            'create_resource_pool_options_io_priority_high',
            'create_resource_pool_options_io_priority_none',
        })
        self.assertIn('create_resource_pool_feature_io_threshold',
                      audit['documented_features']['details'])

    def test_create_resource_pool_memory_limit_boundaries_are_rendered(self):
        cases = self.factor_cases('create_resource_pool')
        sqls = '\n'.join(c.sql for c in cases)
        self.assertIn("MEMORY_LIMIT = '1KB'", sqls)
        self.assertIn("MEMORY_LIMIT = '2047GB'", sqls)
        memory_cases = [c for c in cases if c.params['options'] in {
            'create_resource_pool_options_memory_min',
            'create_resource_pool_options_memory',
            'create_resource_pool_options_memory_max',
        }]
        self.assertEqual(len(memory_cases), 3)
        self.assertIn("MEMORY_LIMIT = '1MB'", '\n'.join(c.sql for c in memory_cases))
        audit = FactorCoverageAuditor(self.registry).audit('create_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'create_resource_pool_feature_memory_limit_boundaries']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'any')
        self.assertEqual(set(feature['selected_refs']), {
            'create_resource_pool_options_memory_min',
            'create_resource_pool_options_memory',
            'create_resource_pool_options_memory_max',
        })
        self.assertTrue(audit['documented_features']['coverage_gaps'] == [])

    def test_alter_resource_pool_io_priority_domain_is_rendered_with_scope_gate(self):
        cases = self.factor_cases('alter_resource_pool')
        self.assertEqual(len(cases), 19)
        sqls = '\n'.join(c.sql for c in cases)
        for value in ("Low", "Medium", "High", "None"):
            self.assertIn(f"IO_PRIORITY = '{value}'", sqls)
        priority_cases = [c for c in cases if 'IO_PRIORITY' in c.sql]
        self.assertEqual(len(priority_cases), 4)
        for case in priority_cases:
            gates = {gate['key']: gate['allowed_values']
                     for gate in case.environment_requirements}
            self.assertEqual(gates['io_control_scope'], ['complex_jobs_only'])
        audit = FactorCoverageAuditor(self.registry).audit('alter_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'alter_resource_pool_feature_io_priority_values']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'all')
        self.assertEqual(set(feature['selected_refs']), {
            'alter_resource_pool_options_io_priority_low',
            'alter_resource_pool_options_io_priority_medium',
            'alter_resource_pool_options_io_priority_high',
            'alter_resource_pool_options_io_priority_none',
        })
        self.assertTrue(audit['documented_features']['coverage_gaps'] == [])

    def test_alter_resource_pool_active_statements_boundaries_are_rendered(self):
        cases = self.factor_cases('alter_resource_pool')
        sqls = '\n'.join(c.sql for c in cases)
        for value in (-1, 0, 1, 2147483647):
            self.assertIn(f'ACTIVE_STATEMENTS = {value}', sqls)
        active_cases = [c for c in cases if 'ACTIVE_STATEMENTS' in c.sql]
        self.assertEqual(len(active_cases), 4)
        audit = FactorCoverageAuditor(self.registry).audit('alter_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'alter_resource_pool_feature_active_statements_boundaries']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'any')
        self.assertEqual(set(feature['selected_refs']), {
            'alter_resource_pool_options_active_unlimited',
            'alter_resource_pool_options_active_disabled',
            'alter_resource_pool_options_active_one',
            'alter_resource_pool_options_active_max',
        })
        self.assertTrue(audit['documented_features']['coverage_gaps'] == [])

    def test_alter_resource_pool_memory_limit_boundaries_are_rendered(self):
        cases = self.factor_cases('alter_resource_pool')
        sqls = '\n'.join(c.sql for c in cases)
        self.assertIn("MEMORY_LIMIT = '1KB'", sqls)
        self.assertIn("MEMORY_LIMIT = '1MB'", sqls)
        self.assertIn("MEMORY_LIMIT = '2047GB'", sqls)
        memory_cases = [c for c in cases if c.params['options'] in {
            'alter_resource_pool_options_memory_limit_min',
            'alter_resource_pool_options_memory_limit_mb',
            'alter_resource_pool_options_memory_limit_max',
        }]
        self.assertEqual(len(memory_cases), 3)
        audit = FactorCoverageAuditor(self.registry).audit('alter_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'alter_resource_pool_feature_memory_limit_boundaries']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'any')
        self.assertEqual(set(feature['selected_refs']), {
            'alter_resource_pool_options_memory_limit_min',
            'alter_resource_pool_options_memory_limit_mb',
            'alter_resource_pool_options_memory_limit_max',
        })
        self.assertTrue(audit['documented_features']['coverage_gaps'] == [])

    def test_alter_resource_pool_io_limits_boundaries_are_rendered(self):
        cases = self.factor_cases('alter_resource_pool')
        sqls = '\n'.join(c.sql for c in cases)
        self.assertIn("IO_LIMITS = 0", sqls)
        self.assertIn("IO_LIMITS = 2147483647", sqls)
        limit_cases = [c for c in cases if 'IO_LIMITS' in c.sql]
        self.assertEqual(len(limit_cases), 2)
        for case in limit_cases:
            gates = {gate['key']: gate['allowed_values']
                     for gate in case.environment_requirements}
            self.assertEqual(gates['io_control_scope'], ['complex_jobs_only'])
        audit = FactorCoverageAuditor(self.registry).audit('alter_resource_pool')
        self.assertEqual(audit['values']['coverage_gaps'],
                         [])
        feature = audit['documented_features']['details'][
            'alter_resource_pool_feature_io_limits_boundaries']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'any')
        self.assertEqual(set(feature['selected_refs']), {
            'alter_resource_pool_options_io_limits_zero',
            'alter_resource_pool_options_io_limits_max',
        })
        self.assertTrue(audit['documented_features']['coverage_gaps'] == [])

    def test_security_label_negative_oracle_is_source_confirmed(self):
        m = self.registry.manifests['manifest_create_security_label_invalid_content']
        self.assertEqual(m.expected.oracle_status, 'confirmed')
        self.assertEqual(m.expected.error_category, 'invalid_security_label_content')
        self.assertEqual(m.bindings['content'],
                         ['create_security_label_content_empty_range'])
        self.assertTrue(m.violates_rule_refs)
        cs = self.cases(m.id)
        self.assertEqual(len(cs), 1)
        self.assertTrue(all(c.expected == 'error' for c in cs))

    def test_pair_projections_and_candidate_identity(self):
        ids = []
        for f in self.factors.values():
            sqls = []
            for mid in f.manifest_refs:
                m = self.registry.manifests[mid]
                cs, report = self.generator.generate_with_report(m)
                keys = sorted(m.bindings)
                # Positive and negative security-label domains each have one axis;
                # all other selected domains have no cross-value exclusion.
                expected = set()
                for vs in itertools.product(*(m.bindings[k] for k in keys)):
                    expected.update(itertools.combinations(zip(keys, vs), 2))
                actual = {pair for c in cs for pair in
                          itertools.combinations([(k, c.params[k]) for k in keys], 2)}
                self.assertEqual(actual, expected, mid)
                self.assertFalse(report.missing_pairs, mid)
                ids.extend(c.case_id for c in cs)
                sqls.extend(c.sql for c in cs)
            self.assertEqual(len(sqls), len(set(sqls)), f.id)
        self.assertEqual(len(ids), len(set(ids)))

    def test_only_nonlogin_disabled_password_identities_are_created(self):
        for f in self.factors.values():
            for c in self.factor_cases(f.id):
                for s in c.setup_sqls + [c.sql]:
                    if re.match(r'CREATE (ROLE|USER|GROUP) ', s):
                        self.assertIn('NOLOGIN', s)
                        self.assertIn('DISABLE', s)
                        self.assertNotRegex(s, r"PASSWORD\s+'|IDENTIFIED BY\s+'")

    def test_cleanup_does_not_hide_unbounded_ownership_or_security_mutation(self):
        for fid in self.factors:
            for c in self.factor_cases(fid):
                for sql in c.setup_sqls + c.teardown_sqls:
                    self.assertNotRegex(sql.upper(),
                                        r'DROP OWNED|REASSIGN OWNED|WEAK PASSWORD DICTIONARY|EXCEPTION WHEN')

    def test_drop_owned_is_target_only_and_limited_to_dedicated_roles(self):
        for c in self.factor_cases('drop_owned'):
            self.assertRegex(c.sql, r'^DROP OWNED BY b9_role_a')
            self.assertNotIn('CASCADE', c.sql)
            self.assertTrue(any('OWNER TO b9_role_a' in s for s in c.setup_sqls))
            self.assertTrue(any('DROP TABLE IF EXISTS b9_owned_a' in s for s in c.teardown_sqls))

    def test_unlock_and_remove_have_matching_initial_states(self):
        for fid in ('alter_role', 'alter_user'):
            for c in self.cases('manifest_' + fid + '_unlock'):
                self.assertTrue(any('ACCOUNT LOCK' in s for s in c.setup_sqls))
        for c in self.cases('manifest_alter_group_remove'):
            self.assertTrue(any('GRANT b9_role_a TO b9_role_b, b9_role_c' in s
                                for s in c.setup_sqls))

    def test_column_revoke_is_not_masked_by_table_grant(self):
        for c in self.cases('manifest_revoke_column'):
            grants = [s for s in c.setup_sqls if s.startswith('GRANT ')
                      and 'b9_revoke_source' in s]
            self.assertTrue(grants)
            self.assertTrue(all('(' in s.split(' ON ')[0] for s in grants))

    def test_default_acl_is_schema_scoped_not_global_or_public(self):
        for c in self.factor_cases('alter_default_privileges'):
            self.assertIn('IN SCHEMA fp_cs_one', c.sql)
            self.assertNotIn('PUBLIC', c.sql)
            self.assertNotIn(' FOR ROLE ', c.sql)
            self.assertTrue(any('ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE' in s
                                for s in c.teardown_sqls))

    def test_security_label_update_and_clear_start_from_marked_objects(self):
        for c in self.cases('manifest_security_label_on_change_clear'):
            self.assertTrue(any('SECURITY LABEL ON TABLE b9_sec_table IS' in s
                                for s in c.setup_sqls))
            self.assertTrue(any('SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS' in s
                                for s in c.setup_sqls))

    def test_sql_envelopes_have_no_pdf_notation_or_password_literals(self):
        for f in self.factors.values():
            for c in self.factor_cases(f.id):
                for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                    self.assertTrue(sql.endswith(';'))
                    self.assertNotRegex(sql, r'\{[a-z_]+\}|\.\.\.|gaussdb=#|\*{4}')
                    self.assertNotRegex(sql.upper(), r"PASSWORD\s+'|IDENTIFIED BY\s+'")


if __name__ == '__main__':
    unittest.main()
