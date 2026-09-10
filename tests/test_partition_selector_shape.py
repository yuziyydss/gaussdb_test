"""Partition key/selector shape is not a multi-key routing or execution proof."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.finite_sql_contract import ReviewNeeded, Contradiction, ddl_tables, finite_range_partition_definition
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1];TABLE='g_tr_two_ns.target_table'
DDL=f'CREATE TABLE {TABLE} (id INTEGER, qty INTEGER) PARTITION BY RANGE (id, qty) (PARTITION p_low VALUES LESS THAN (10, 20), PARTITION p_max VALUES LESS THAN (MAXVALUE, MAXVALUE));'
SQL=f'ALTER TABLE {TABLE} TRUNCATE PARTITION FOR (1, 10);'
MID='manifest_truncate_partition_two_keys'


class SelectorShapeTests(unittest.TestCase):
    def check(self,sql=SQL,setup=None,keys=None,values=None):
        from core.partition_selector_contract import check_rendered_partition_selector
        return check_rendered_partition_selector(sql,[DDL] if setup is None else setup,
            profile_target=TABLE,keys=['id','qty'] if keys is None else keys,
            values=['1','10'] if values is None else values)

    def test_actual_two_integer_keys_and_values_have_finite_shape_only(self):
        r=self.check();self.assertEqual(r['partition_keys'],['id','qty'])
        self.assertEqual(r['selector_values'],[1,10]);self.assertEqual(r['key_types'],['INTEGER','INTEGER'])
        for key in ('routing_proven','bounds_order_proven','runtime_proven'):self.assertFalse(r[key])

    def test_wrong_width_order_missing_or_noninteger_column_cannot_use_profile_metadata(self):
        for setup,keys,values in (([DDL.replace('RANGE (id, qty)','RANGE (id)')],None,None),
                ([DDL.replace('qty INTEGER','qty TEXT')],None,None),
                ([DDL.replace('RANGE (id, qty)','RANGE (qty, id)')],None,None),
                ([DDL.replace('RANGE (id, qty)','RANGE (id, missing)')],None,None),
                ([DDL],['id'],None),([DDL],None,['1'])):
            with self.subTest(setup=setup,keys=keys,values=values),self.assertRaises(ReviewNeeded):
                self.check(setup=setup,keys=keys,values=values)

    def test_rendered_target_values_tail_and_ddl_history_are_not_trusted(self):
        for sql in (SQL.replace(TABLE,'other_table'),SQL.replace('(1, 10)','(1, 11)'),
                    SQL.replace('(1, 10)','(1, NULL)'),SQL+' SELECT 1;',SQL.replace('FOR (1, 10)','p_low')):
            with self.subTest(sql=sql),self.assertRaises(ReviewNeeded):self.check(sql=sql)
        for tail in (f'ALTER TABLE {TABLE} ADD z INTEGER;',f'DROP TABLE {TABLE};','RESET ALL;',
                     'DO $$BEGIN NULL; END$$;'):
            with self.subTest(tail=tail),self.assertRaises(ReviewNeeded):self.check(setup=[DDL,tail])

    def test_bound_shape_and_legacy_single_key_routing_are_not_broadened(self):
        for ddl in (DDL.replace('(10, 20)','(10)'),DDL.replace('(MAXVALUE, MAXVALUE)','(MAXVALUE, 20)'),
                    DDL.replace('qty INTEGER','qty INTEGER DEFAULT 1'),DDL.replace('qty INTEGER','qty ınt'),
                    DDL.replace('(id, qty) (PARTITION','(id, id) (PARTITION')):
            with self.subTest(ddl=ddl),self.assertRaises(ReviewNeeded):self.check(setup=[ddl])
        with self.assertRaisesRegex(ReviewNeeded,'Only a single integer RANGE key'):
            finite_range_partition_definition(ddl_tables([DDL])[TABLE])

    def test_opaque_insert_and_schema_elements_cannot_preserve_shape_evidence(self):
        for item in (f'INSERT INTO {TABLE} VALUES (user_function(),10);',
                     f'INSERT INTO {TABLE} SELECT 1,10;',
                     'CREATE SCHEMA app CREATE TABLE hidden(id INTEGER);',
                     'CREATE TABLE other AS SELECT user_function();'):
            with self.subTest(item=item),self.assertRaisesRegex(ReviewNeeded,'Only fresh'):
                self.check(setup=[DDL,item])


class SelectorConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID);return self.r.manifests[MID]

    def test_new_candidate_and_real_seed_are_owned_not_legacy_cascade(self):
        cs,r=FactorPackageSQLGenerator(self.r).generate_with_report(self.manifest())
        self.assertEqual(len(cs),1);self.assertEqual(cs[0].sql,SQL)
        self.assertEqual((cs[0].expected,cs[0].expected_scope),('success','syntax_only'))
        self.assertEqual(cs[0].setup_sqls,['CREATE SCHEMA g_tr_two_ns;',DDL,
            f'INSERT INTO {TABLE} (id,qty) VALUES (1,10),(11,30);'])
        self.assertEqual(cs[0].teardown_sqls,[f'DROP TABLE {TABLE} PURGE;','DROP SCHEMA g_tr_two_ns RESTRICT;'])
        self.assertFalse(any('CASCADE' in s or 'IF EXISTS' in s for s in cs[0].setup_sqls+cs[0].teardown_sqls))

    def test_generator_rejects_actual_ddl_and_rendered_selector_faults(self):
        m=self.manifest();g=FactorPackageSQLGenerator(self.r);original=g._compile_fixture_lifecycle
        def wrong(refs):
            setup,down=original(refs)
            return [s.replace('RANGE (id, qty)','RANGE (id)') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=wrong):
            with self.assertRaisesRegex(GenerationValidationError,'partition_'):g.generate_with_report(m)
        original_render=g._render_sql_with_consumption
        def wrong_sql(*args):
            sql,used=original_render(*args);return sql.replace('FOR (1, 10)','FOR (1, 11)'),used
        with patch.object(g,'_render_sql_with_consumption',side_effect=wrong_sql):
            with self.assertRaisesRegex(GenerationValidationError,'partition_'):g.generate_with_report(m)

    def test_real_provider_edges_and_unbounded_gap_remain(self):
        self.manifest();deps=self.r.factor_dependency_graph()['truncate']
        self.assertTrue({'create_table_partition','create_schema','create_table','drop_table','drop_schema'}<=deps)
        features={f.id:f for f in self.r.matrices['matrix_truncate_partition_values'].documented_features}
        f=features['tr_feature_partition_value_multi']
        self.assertEqual((f.status,f.coverage_mode),('covered','representative'))
        self.assertEqual(f.profile_refs,['tr_partition_values_two_owned'])
        self.assertEqual(features['tr_feature_partition_value_unbounded'].status,'needs_profile')

    def test_planned_oracles_distinguish_removed_partition_and_retained_rows(self):
        self.manifest();s=self.r.scenarios['scenario_truncate_two_keys']
        self.assertEqual(s.status,'planned');self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('ownership_scoped_cleanup',s.execution_requirements)
        self.assertTrue(any(o['kind']=='result_set' and o['expected']==[[11,30]] for o in s.oracles))
        self.assertTrue(any(o['kind']=='manual_assertion' and '路由' in o['expected'] for o in s.oracles))


if __name__=='__main__':unittest.main()
