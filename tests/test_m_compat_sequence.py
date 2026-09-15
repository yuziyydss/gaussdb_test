import copy
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]
IDS=('m_create_sequence','m_alter_sequence','m_drop_sequence')


class MSequenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,mid):
        return self.g.generate_cases_for_manifest(self.r.manifests[mid])

    def test_cache_zero_is_target_negative_not_setup_failure(self):
        cases=self.cases('manifest_m_alter_sequence_cache_zero')
        self.assertEqual(len(cases),1)
        c=cases[0]
        self.assertIn('CACHE 0',c.sql)
        self.assertEqual(c.expected,'error')
        self.assertEqual(c.expected_oracle_status,'needs_verification')
        self.assertFalse(c.expected_sqlstates)
        self.assertTrue(any(s.startswith('CREATE SEQUENCE m_b03_existing_seq ') for s in c.setup_sqls))
        self.assertTrue(all('CACHE 0' not in s for s in c.setup_sqls))
        f=self.r.factors['m_alter_sequence']
        m=copy.deepcopy(self.r.manifests['manifest_m_alter_sequence_finite'])
        solver=self.g._build_solver(f,m,self.r.resolve_dimension_values(f.id))
        self.assertFalse(solver.is_valid(c.params)[0])

    def test_alter_does_not_copy_create_attributes(self):
        for c in self.cases('manifest_m_alter_sequence_finite'):
            self.assertNotRegex(c.sql,r'\b(INCREMENT|START|RESTART|MINVALUE|CYCLE)\b')
            self.assertNotIn('MAXVALUE 5',c.sql)
            self.assertIn(dict(key='execution_context',allowed_values=['top_level_autocommit'],
                fact_refs=['m_alter_sequence_fact_outside_transaction']),c.environment_requirements)
            self.assertFalse(any(s.startswith('BEGIN') for s in c.setup_sqls))

    def test_create_explicit_range_and_owned_column_fixture(self):
        for c in self.cases('manifest_m_create_sequence_finite'):
            self.assertIn('MINVALUE -10 MAXVALUE 10',c.sql)
            self.assertTrue(any(s=='CREATE TABLE m_create_sequence_owner (id INT);' for s in c.setup_sqls))
            self.assertFalse(any(s.startswith('CREATE SEQUENCE m_create_sequence_new') for s in c.setup_sqls))
            self.assertLess(next(i for i,s in enumerate(c.teardown_sqls) if s.startswith('DROP SEQUENCE')),
                            next(i for i,s in enumerate(c.teardown_sqls) if s.startswith('DROP TABLE')))

    def test_dependency_topology_single_seed_and_reverse_cleanup(self):
        for mid in ('manifest_m_alter_sequence_finite','manifest_m_drop_sequence_finite'):
            for c in self.cases(mid):
                self.assertEqual(sum(s.startswith('CREATE SEQUENCE m_b03_existing_seq ') for s in c.setup_sqls),1)
                self.assertIn("SELECT nextval('m_b03_existing_seq');",c.setup_sqls)
                self.assertEqual(c.teardown_sqls[-1],'DROP TABLE m_b03_sequence_owner;')
                self.assertNotIn('LARGE',c.sql)

    def test_three_new_packages_keep_source_and_behavior_gaps(self):
        for fid in IDS:
            f=self.r.factors[fid]
            self.assertEqual(f.status,'needs_review')
            self.assertFalse(any(u.status=='unmapped' for u in self.r.source_ledgers[f.source_ledger_ref].units))
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in f.scenario_refs))
        self.assertTrue(any(f.type=='open_question' and '相等' in f.statement for f in self.r.factors['m_alter_sequence'].facts))


if __name__=='__main__':unittest.main()
