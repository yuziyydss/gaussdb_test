"""Finite catalog assets describe required evidence, not execution authority."""
import unittest
from core.execution_preparation import ownership_plan


class ForeignAssetTests(unittest.TestCase):
    def setup_sql(self):
        return ['CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;',
                'CREATE SCHEMA g_a3_at_log_ns;',
                "CREATE FOREIGN TABLE g_a3_at_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');"]

    def cleanup_sql(self):
        return ['DROP FOREIGN TABLE g_a3_at_log_ns.foreign_table RESTRICT;',
                'DROP SCHEMA g_a3_at_log_ns RESTRICT;', 'DROP SERVER g_a3_log_server RESTRICT;']

    def test_foreign_table_requires_both_parent_assets_and_exact_cleanup(self):
        p = ownership_plan(self.setup_sql(), self.cleanup_sql())
        self.assertEqual(p['blockers'], [])
        self.assertEqual([x['kind'] for x in p['creates']], ['server','schema','foreign_table'])
        self.assertEqual(p['creates'][2]['depends_on'], ['g_a3_at_log_ns','g_a3_log_server'])
        self.assertEqual(p['creates'][0]['namespace_scope'], 'database')
        self.assertTrue(all(x['require_absent_before_run'] and x['requires_success_receipt'] for x in p['creates']))
        self.assertTrue(all(x['execute_only_with_matching_create_receipt'] for x in p['cleanup']))
        self.assertFalse(p['runtime_ownership_proven'])

    def test_missing_out_of_order_or_wrong_parent_is_rejected(self):
        original = self.setup_sql()
        for setup in [original[1:], original[:1]+original[2:], original[::-1],
                      original[:2]+[original[2].replace('SERVER g_a3_log_server','SERVER other')],
                      original[:2]+[original[2].replace('g_a3_at_log_ns.foreign_table','other.foreign_table')]]:
            with self.subTest(setup=setup):
                self.assertTrue(ownership_plan(setup,self.cleanup_sql())['blockers'])

    def test_both_parents_must_outlive_all_dependent_foreign_tables(self):
        original = self.cleanup_sql()
        for cleanup in [original[::-1], original[1:]+original[:1],
                        [original[0].replace('FOREIGN TABLE','TABLE')]+original[1:],
                        original+[original[-1]], [x.replace('RESTRICT','CASCADE') for x in original]]:
            with self.subTest(cleanup=cleanup):
                self.assertTrue(ownership_plan(self.setup_sql(),cleanup)['blockers'])
        setup = self.setup_sql()+[self.setup_sql()[2].replace('foreign_table','second_table')]
        p = ownership_plan(setup,self.cleanup_sql())
        self.assertIn('cleanup_order:g_a3_log_server',p['blockers'])
        self.assertIn('missing_cleanup:g_a3_at_log_ns.second_table',p['blockers'])

    def test_arbitrary_fdw_options_columns_and_unreviewed_names_remain_blocked(self):
        for old,new in [('log_fdw','file_fdw'), ('col1 TEXT','col1 INTEGER'),
                        ("'gs_log'","'GS_LOG'"), ('g_a3_log_server','existing_server'),
                        ('CREATE SERVER','CREATE SERVER IF NOT EXISTS'),
                        ('CREATE FOREIGN TABLE','CREATE FOREIGN TABLE IF NOT EXISTS')]:
            with self.subTest(new=new):
                setup=[s.replace(old,new) for s in self.setup_sql()]
                self.assertTrue(ownership_plan(setup,self.cleanup_sql())['blockers'])
        p=ownership_plan(self.setup_sql()+["SELECT * FROM g_a3_at_log_ns.foreign_table;"],self.cleanup_sql())
        self.assertIn('unreviewed_setup:3',p['blockers'])

    def test_partial_creation_receipts_are_requirements_not_assumed_success(self):
        p=ownership_plan(self.setup_sql()[:2],self.cleanup_sql())
        self.assertIn('cleanup_without_create:g_a3_at_log_ns.foreign_table',p['blockers'])
        self.assertFalse(p['runtime_ownership_proven'])
        # A valid plan still cannot know if CREATE SERVER succeeded at runtime.
        p=ownership_plan(self.setup_sql(),self.cleanup_sql())
        self.assertEqual(p['blockers'],[])
        self.assertNotIn('runtime_created',p['creates'][0])

    def test_finite_option_seed_records_conditional_state_not_runtime_success(self):
        seed = "ALTER FOREIGN TABLE g_a3_at_log_ns.foreign_table OPTIONS (ADD latest_files '2');"
        p = ownership_plan(self.setup_sql()+[seed], self.cleanup_sql())
        self.assertEqual(p['blockers'], [])
        self.assertEqual(p['setup_mutations'], [{
            'object': 'g_a3_at_log_ns.foreign_table', 'setup_index': 3,
            'operation': 'add_foreign_option', 'option': 'latest_files',
            'required_before': None, 'planned_after': '2',
            'execute_only_with_matching_create_receipt': True,
            'requires_success_receipt': True, 'runtime_state_proven': False,
        }])
        self.assertFalse(p['runtime_ownership_proven'])

    def test_option_seed_rejects_duplicate_and_unowned_or_earlier_target(self):
        seed = "ALTER FOREIGN TABLE g_a3_at_log_ns.foreign_table OPTIONS (ADD latest_files '2');"
        base = self.setup_sql()
        for setup in [base+[seed,seed], base[:2]+[seed]+base[2:],
                      base+[seed.replace('foreign_table','other')],
                      base+[seed.replace('g_a3_at_log_ns.foreign_table','public.foreign_table')]]:
            with self.subTest(setup=setup):
                self.assertTrue(ownership_plan(setup,self.cleanup_sql())['blockers'])
        p = ownership_plan(base+[seed,seed], self.cleanup_sql())
        self.assertEqual(len(p.get('setup_mutations', [])), 1)
        self.assertIn('foreign_option_already_present:4', p['blockers'])

    def test_option_seed_is_not_generic_alter_or_log_data_authorization(self):
        seed = "ALTER FOREIGN TABLE g_a3_at_log_ns.foreign_table OPTIONS (ADD latest_files '2');"
        for statement in [seed.replace('ADD','SET'), seed.replace("ADD latest_files '2'",'DROP latest_files'),
                          seed.replace('latest_files','filename'), seed.replace("'2'","'5'"),
                          seed.replace('FOREIGN TABLE','TABLE'), seed+' SELECT 1;',
                          seed.replace('ADD','/* x */ ADD')]:
            with self.subTest(statement=statement):
                p = ownership_plan(self.setup_sql()+[statement],self.cleanup_sql())
                self.assertTrue(p['blockers'])
                self.assertFalse(p.get('setup_mutations',[]))
