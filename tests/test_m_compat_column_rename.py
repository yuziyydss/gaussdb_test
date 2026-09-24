"""M CHANGE must share actual-column proof without importing B-only scope."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_alter_table_change_fresh'
FX='fixture_m_alter_table_change_fresh'
TARGET='m_at_change_fresh'


class MColumnRenameConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.r.manifests[MID]

    def test_actual_two_spellings_have_plain_fresh_source(self):
        cases,report=self.g.generate_with_report(self.manifest())
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{'ALTER TABLE m_at_change_fresh CHANGE qty amount INTEGER;',
            'ALTER TABLE m_at_change_fresh CHANGE COLUMN qty amount INTEGER;'})
        self.assertEqual(len(cases),2)
        for c in cases:
            self.assertEqual(c.setup_sqls,['CREATE TABLE m_at_change_fresh (id INTEGER, qty INTEGER);',
                'INSERT INTO m_at_change_fresh VALUES (1,10),(2,20);'])
            self.assertEqual(c.teardown_sqls,['DROP TABLE m_at_change_fresh;'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
        requirements=self.manifest().environment_requirements
        self.assertTrue(any('m_create_table::m_create_table_fact_authority' in e.fact_refs for e in requirements))

    def test_actual_ddl_not_provides_controls_missing_and_duplicate_columns(self):
        manifest=self.manifest();fixture=self.r.fixtures[FX];before=fixture.execution.setup_sqls
        try:
            for ddl in (before[0].replace('qty INTEGER','other INTEGER'),
                        before[0].replace('id INTEGER','amount INTEGER'),
                        before[0].replace('qty INTEGER','qty INTEGER DEFAULT 9')):
                fixture.execution.setup_sqls=[ddl,*before[1:]]
                with self.subTest(ddl=ddl),self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(manifest)
        finally:fixture.execution.setup_sqls=before

    def test_source_identity_and_mode_must_agree(self):
        original=self.manifest();source=self.r.factors['m_alter_table'].source
        ref=source.catalog_chapter_ref;before=ref.source_relpath
        try:
            for path,modes in [('m_compat/ddl/alter_table.txt',['B']),
                               ('general/ddl/alter_table.txt',['M']),
                               ('m_compat/ddl/other.txt',['M']),
                               ('m_compat/ddl/alter_table.txt',['M','B'])]:
                ref.source_relpath=path;m=copy.deepcopy(original)
                next(e for e in m.environment_requirements if e.key=='compatibility_mode').allowed_values=modes
                with self.subTest(path=path,modes=modes),self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(m)
            ref.source_relpath=before
            m=copy.deepcopy(original)
            m.environment_requirements.append(copy.deepcopy(next(e for e in m.environment_requirements if e.key=='compatibility_mode')))
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(m)
            source.catalog_chapter_ref=None
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(original)
        finally:source.catalog_chapter_ref=ref;ref.source_relpath=before
        branch=self.r.syntaxes['syntax_m_alter_table'].ast.branches['m_alter_table_form_change_fresh']
        old_action,old_mapping=branch.items[2].text,branch.items[4].text
        try:
            branch.items[2].text=' RENAME ';branch.items[4].text=' qty TO amount'
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(original)
        finally:branch.items[2].text=old_action;branch.items[4].text=old_mapping

    def test_original_change_domain_remains_and_oracle_is_only_planned(self):
        self.manifest()
        old=[c for mid in self.r.factors['m_alter_table'].manifest_refs if mid not in (MID,'manifest_m_alter_table_add_position_fresh')
             for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]
        self.assertEqual(len(old),40)
        changes=[c for c in old if c.params['form']=='m_alter_table_form_change']
        self.assertEqual(len(changes),6)
        self.assertTrue(all('INTEGER DEFAULT 9' in c.sql for c in changes))
        self.assertTrue(any('FIRST' in c.sql for c in changes))
        self.assertTrue(any('AFTER id' in c.sql for c in changes))
        scenario=self.r.scenarios['scenario_m_alter_table_change_fresh']
        self.assertEqual(scenario.status,'planned')
        self.assertTrue(any(step.get('manifest_ref')==MID for step in scenario.steps))
        self.assertTrue(any(o.get('step_id')=='rows' and o.get('expected')==[[1,10],[2,20]] for o in scenario.oracles))


if __name__=='__main__':unittest.main()
