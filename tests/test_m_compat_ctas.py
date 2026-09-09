import copy
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.shared_column_contract import ordinary_columns
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]


class MCTASTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,suffix='direct_columns'):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_create_table_select_'+suffix])

    def test_direct_projection_matches_real_fixture_types_and_order(self):
        resolved=self.r.resolve_dimension_values('m_create_table_select')
        for c in self.cases():
            columns=ordinary_columns(c.setup_sqls[0])
            projection=resolved['projection'][c.params['projection']].attributes
            names=projection['projection.properties.items']
            actual=re.search(r'SELECT (.+) FROM m_ctas_source;',c.sql)[1].split(', ')
            self.assertEqual(actual,names)
            self.assertEqual(projection['projection.properties.output_columns'],names)
            self.assertEqual(projection['projection.properties.output_column_count'],len(names))
            self.assertEqual(projection['projection.properties.output_types'],['INTEGER']*len(names))
            self.assertTrue(all(columns[n]['family']=='integer' for n in names))
            self.assertEqual(columns['id']['default_sql'],'7')
            self.assertFalse(columns['id']['nullable'])
            self.assertEqual(columns['qty']['default_sql'],'9')
            self.assertTrue(columns['qty']['nullable'])
            self.assertFalse(any(s.startswith('CREATE TABLE m_ctas_new') for s in c.setup_sqls))
            self.assertEqual(c.teardown_sqls,['DROP TABLE IF EXISTS m_ctas_new;','DROP TABLE m_ctas_source;'])

    def test_unknown_column_is_rejected(self):
        f=self.r.factors['m_create_table_select']
        combo={k:v.default_value_id for k,v in f.dimensions.items()}
        resolved=copy.deepcopy(self.r.resolve_dimension_values(f.id))
        resolved['projection'][combo['projection']].attributes['projection.properties.source_columns']=['absent']
        with self.assertRaisesRegex(GenerationValidationError,'不存在的列'):
            self.g._validate_fixture_contract(combo,resolved,['fixture_m_create_table_select_source'])

    def test_no_expression_or_union_without_precision_gate(self):
        for c in self.cases():
            self.assertRegex(c.sql,r'SELECT (id|id, qty|qty, id) FROM m_ctas_source;')
            self.assertNotRegex(c.sql,r'\b(UNION|PREPARE|PARTITION|UNLOGGED|TEMPORARY)\b')
        f=self.r.factors['m_create_table_select']
        self.assertTrue(any(x.type=='environment' and 'enable_precision_decimal' in x.statement for x in f.facts))
        self.assertTrue(any(x.type=='open_question' and 'UBTREE' in x.statement for x in f.facts))

    def test_column_storage_only_changes_target(self):
        c=self.cases('column_storage')[0]
        self.assertIn('WITH (orientation=column)',c.sql)
        self.assertTrue(all('orientation=column' not in s for s in c.setup_sqls))
        self.assertEqual(c.expected,'error')
        self.assertEqual(c.expected_oracle_status,'needs_verification')
        self.assertFalse(c.expected_sqlstates)
        f=self.r.factors['m_create_table_select']
        self.assertEqual(f.status,'needs_review')
        self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in f.scenario_refs))


if __name__=='__main__':unittest.main()
