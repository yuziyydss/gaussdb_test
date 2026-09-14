"""Batch 02 finite models: source, combinations, lifecycle and environment."""
import hashlib
import json
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.m_compat_environment import BOOTSTRAP_PATH, requires_m
from scripts.generate_factor_package_sql import render_sql_snapshot

ROOT=Path(__file__).resolve().parents[1]
CORPUS=ROOT/'work/m_compat_batch_02/corpus'
FACTORS=tuple('m_'+c['title'].lower().replace(' ','_') for c in
              json.loads((CORPUS/'catalog.json').read_text())['chapters'])


class MCompatBatch02Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry=FactorPackageRegistry(ROOT/'specs'); cls.registry.load_all()
        cls.generator=FactorPackageSQLGenerator(cls.registry)
        cls.cases={fid:[c for mid in cls.registry.factors[fid].manifest_refs
                       for c in cls.generator.generate_cases_for_manifest(cls.registry.manifests[mid])]
                   for fid in FACTORS}

    def test_all_18_have_real_finite_generation(self):
        self.assertEqual(len(self.cases),18)
        ids=set()
        for fid in FACTORS:
            own_sql=set()
            for mid in self.registry.factors[fid].manifest_refs:
                m=self.registry.manifests[mid]
                cases,report=self.generator.generate_with_report(m)
                again,_=self.generator.generate_with_report(m)
                self.assertTrue(cases); self.assertTrue(report.pairwise_complete)
                self.assertEqual([c.to_dict() for c in cases],[c.to_dict() for c in again])
                varied={k for k,v in m.bindings.items() if len(v)>1}
                for dim,values in m.bindings.items():
                    self.assertEqual(set(values),{c.params[dim] for c in cases},(mid,dim))
                for c in cases:
                    self.assertNotIn(c.case_id,ids); ids.add(c.case_id)
                    self.assertNotIn(c.sql,own_sql); own_sql.add(c.sql)
                    self.assertTrue(varied.issubset(c.consumed_dimension_ids),(mid,c.sql))
                    self.assertTrue(requires_m(c)); self.assertEqual(c.expected_scope,'syntax_only')
                    self.assertNotRegex(c.sql,r'\{|\}|\.\.\.')
                    self.assertTrue(c.setup_sqls); self.assertTrue(c.teardown_sqls)
                    self.assertNotIn('SELECT 1;',c.setup_sqls)
                self.assertIn(BOOTSTRAP_PATH,render_sql_snapshot(mid,cases))

    def test_transaction_fixture_is_not_just_a_table(self):
        for fid in ('m_commit','m_rollback','m_savepoint','m_release_savepoint','m_rollback_to_savepoint'):
            for c in self.cases[fid]:
                self.assertIn('BEGIN;',c.setup_sqls)
                self.assertEqual(c.teardown_sqls[0],'ROLLBACK;')
                if fid in ('m_release_savepoint','m_rollback_to_savepoint'):
                    self.assertEqual(sum(s.startswith('SAVEPOINT ') for s in c.setup_sqls),2)
        for fid in ('m_begin','m_start_transaction'):
            self.assertTrue(all('BEGIN;' not in c.setup_sqls for c in self.cases[fid]))

    def test_namespace_sql_is_not_physical_database_bootstrap(self):
        for fid in ('m_create_database','m_create_schema'):
            for c in self.cases[fid]:
                self.assertNotIn('DBCOMPATIBILITY',c.sql)
                self.assertTrue(c.sql.startswith(('CREATE DATABASE','CREATE SCHEMA')))
                self.assertEqual(c.teardown_sqls[0],'USE public;')

    def test_temporary_drop_has_matching_temporary_fixture(self):
        for c in self.cases['m_drop_table']:
            temporary='DROP TEMPORARY TABLE' in c.sql
            self.assertEqual(any(s.startswith('CREATE TEMPORARY TABLE') for s in c.setup_sqls),temporary)

    def test_shared_source_dag_and_teardown_order(self):
        for fid in ('m_describe','m_drop_view','m_table'):
            for c in self.cases[fid]:
                self.assertEqual(sum(s.startswith('CREATE TABLE m_b01_source ') for s in c.setup_sqls),1)
                if fid != 'm_table':
                    self.assertLess(next(i for i,s in enumerate(c.teardown_sqls) if s.startswith('DROP VIEW')),
                                    next(i for i,s in enumerate(c.teardown_sqls) if s.startswith('DROP TABLE m_b01_source')))

    def test_known_m_semantics_not_silently_removed_or_overclaimed(self):
        start=[c.sql for c in self.cases['m_start_transaction']]
        self.assertTrue(any('READ COMMITTED' in sql and 'CONSISTENT SNAPSHOT' in sql for sql in start))
        self.assertTrue(any('SERIALIZABLE' in sql for sql in start))
        self.assertTrue(all('CONSISTENT SNAPSHOT' not in s for s in start if s.startswith('BEGIN')))
        for c in self.cases['m_truncate']:
            self.assertNotIn('CASCADE',c.sql); self.assertNotIn('ONLY',c.sql)

    def test_source_fingerprints_and_gaps_remain_visible(self):
        for fid in FACTORS:
            f=self.registry.factors[fid]
            src=CORPUS/f.source.catalog_chapter_ref.source_relpath
            self.assertEqual(hashlib.sha256(src.read_bytes()).hexdigest(),f.source.artifact_sha256)
            self.assertEqual(f.status,'needs_review')
            ledger=self.registry.source_ledgers[f.source_ledger_ref]
            # m_drop_view已完成source extraction；其余仍保留unmapped账本。
            if fid == 'm_drop_view':
                self.assertFalse(any(u.status=='unmapped' for u in ledger.units))
            else:
                self.assertTrue(any(u.status=='unmapped' for u in ledger.units))
            lines=[n for u in ledger.units for n in range(u.line_start,u.line_end+1)]
            lines += [i.line for i in ledger.ignored_lines]
            self.assertEqual(sorted(lines),list(range(1,len(src.read_text().splitlines())+1)))
            self.assertTrue(all(self.registry.scenarios[s].status=='planned' for s in f.scenario_refs))


if __name__=='__main__': unittest.main()
