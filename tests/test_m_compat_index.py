"""M index regressions: finite source-backed SQL, not database execution."""
import copy
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]


class MIndexTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,suffix):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+suffix])

    def test_m_comment_and_default_options_stay_inline(self):
        cases=self.cases('create_index_finite')
        self.assertTrue(any("COMMENT 'm finite index'" in c.sql for c in cases))
        for c in cases:
            self.assertEqual(c.sql.count(';'),1)
            self.assertNotRegex(c.sql,r'\b(GIN|GIST|INCLUDE|CONCURRENTLY|GLOBAL|LOCAL)\b')
            self.assertNotIn('COMMENT ON',c.sql)
            self.assertNotIn('fillfactor=9)',c.sql)
            if 'COMMENT' in c.sql and 'WITH (' in c.sql:
                self.assertLess(c.sql.index('WITH ('),c.sql.index('COMMENT'))

    def test_real_shared_fixture_and_target_absence(self):
        for c in self.cases('create_index_finite'):
            self.assertEqual(sum(s.startswith('CREATE TABLE m_b01_source ') for s in c.setup_sqls),1)
            self.assertIn('INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);',c.setup_sqls)
            self.assertFalse(any(s.startswith('CREATE INDEX m_create_index_new') for s in c.setup_sqls))
            self.assertEqual(c.teardown_sqls[-1],'DROP TABLE m_b01_source;')
        for c in self.cases('alter_index_finite')+self.cases('drop_index_ordinary'):
            self.assertEqual(sum(s.startswith('CREATE INDEX m_b03_existing_index ') for s in c.setup_sqls),1)
            self.assertEqual(c.teardown_sqls[-1],'DROP TABLE m_b01_source;')
            self.assertFalse(any('CASCADE' in s for s in c.teardown_sqls))
        for c in self.cases('alter_index_finite'):
            self.assertIn('DROP INDEX IF EXISTS m_b03_existing_index;',c.teardown_sqls)
            # A renamed index is still owned by the case's base table.
            self.assertEqual(c.teardown_sqls[-1],'DROP TABLE m_b01_source;')

    def test_bad_source_column_cannot_be_hidden_by_render(self):
        f=self.r.factors['m_create_index']
        resolved=copy.deepcopy(self.r.resolve_dimension_values(f.id))
        combo={k:v.default_value_id for k,v in f.dimensions.items()}
        resolved['key_profile'][combo['key_profile']].attributes['key_profile.properties.source_columns']=['missing_column']
        with self.assertRaisesRegex(GenerationValidationError,'不存在的列'):
            self.g._validate_fixture_contract(combo,resolved,['fixture_m_create_index_new_target'])

    def test_drop_forms_and_concurrent_constraints(self):
        for c in self.cases('drop_index_on_table'):
            self.assertIn(' ON m_b01_source',c.sql)
            self.assertNotIn('IF EXISTS',c.sql)
            self.assertNotIn('CONCURRENTLY',c.sql)
        for c in self.cases('drop_index_online'):
            self.assertNotIn(',',c.sql)
            self.assertNotIn('CASCADE',c.sql)
            self.assertTrue(any(e['key']=='execution_context' and e['allowed_values']==['top_level_autocommit']
                                for e in c.environment_requirements))

    def test_source_gaps_remain_visible(self):
        # Source extraction is now complete; runtime scenarios remain planned.
        for fid in ('m_alter_index','m_drop_index'):
            f=self.r.factors[fid]
            self.assertEqual(f.status,'needs_review')
            self.assertFalse(any(u.status=='unmapped' for u in self.r.source_ledgers[f.source_ledger_ref].units))
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in f.scenario_refs))
        f=self.r.factors['m_create_index']
        self.assertFalse(any(u.status=='unmapped' for u in self.r.source_ledgers[f.source_ledger_ref].units))
        f=self.r.factors['m_create_index']
        self.assertTrue(any(x.type=='environment' and '分区产生式' in x.statement for x in f.facts))


if __name__=='__main__':unittest.main()
