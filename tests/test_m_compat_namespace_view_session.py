import hashlib
import json
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MNamespaceViewSessionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_namespaces_never_alter_physical_database(self):
        for name in ('alter_database','alter_schema'):
            for suite in ('charset','collation','combined','mismatch'):
                for c in self.cases(name+'_'+suite):
                    self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA m_{name}_namespace CHARSET utf8;'])
                    self.assertEqual(c.teardown_sqls,[f'DROP SCHEMA m_{name}_namespace;'])
                    self.assertNotIn('DBCOMPATIBILITY',c.sql)
                    self.assertTrue(any('m_'+name+'_fact_namespace' in e['fact_refs'] for e in c.environment_requirements if e['key']=='compatibility_mode'))
                    self.assertNotIn('public',c.sql)
                    self.assertIn('m_'+name+'_namespace',c.sql)
                    self.assertTrue(any(e['key']=='server_encoding' and e['allowed_values']==['UTF8'] for e in c.environment_requirements))

    def test_shared_charset_rule_rejects_wrong_association(self):
        for fid in ('m_alter_database','m_alter_schema'):
            f=self.r.factors[fid];resolved=self.r.resolve_dimension_values(fid)
            combo={k:v.default_value_id for k,v in f.dimensions.items()}
            combo.update(form=fid+'_form_combined',charset=fid+'_charset_utf8',collation=fid+'_collation_gbk')
            positive=self.r.manifests['manifest_'+fid+'_combined']
            negative=self.r.manifests['manifest_'+fid+'_mismatch']
            self.assertFalse(self.g._build_solver(f,positive,resolved).is_valid(combo)[0])
            self.assertTrue(self.g._build_solver(f,negative,resolved).is_valid(combo)[0])
            combo['collation']=fid+'_collation_utf8mb4'
            self.assertTrue(self.g._build_solver(f,positive,resolved).is_valid(combo)[0])
            self.assertEqual(negative.expected.oracle_status,'needs_verification')
        rule=self.r.factors['m_alter_schema'].rules[0]
        self.assertEqual(rule.fact_refs,['m_alter_database::m_alter_database_fact_charset_pair'])

    def test_supplemental_sources_are_hashed_and_linked_to_units(self):
        ledger=self.r.source_ledgers['source_ledger_m_alter_database']
        self.assertEqual(len(ledger.supplemental_sources),2)
        sources={}
        for folder in ('m_compat_batch_04_charset','m_compat_batch_04_dependencies'):
            root=ROOT/'work'/folder/'corpus';cat=json.loads((root/'catalog.json').read_text())
            for ch in cat['chapters']:sources[ch['chapter_sha256']]=root/ch['source_relpath']
        for s in ledger.supplemental_sources:
            ref=s.catalog_chapter_ref
            self.assertEqual(hashlib.sha256(sources[ref.chapter_sha256].read_bytes()).hexdigest(),ref.chapter_sha256)
            self.assertTrue(any(s.id in u.supplemental_source_refs for u in ledger.units))

    def test_cumulative_audit_rejects_changed_supplemental_body(self):
        from scripts import verify_m_compat_remaining as audit
        actual_sha=audit.sha
        source=ROOT/'work/m_compat_batch_04_charset/corpus/m_compat/utility/section_2_3.txt'
        def changed_sha(path):
            return '0'*64 if path==source else actual_sha(path)
        # Inject a changed body hash in memory; never alter the source PDF/body.
        with patch.object(audit,'sha',side_effect=changed_sha):
            with self.assertRaisesRegex(AssertionError,'m_alter_database'):
                audit.main()

    def test_view_definition_has_two_real_integer_columns(self):
        cases=self.cases('alter_view_definition')
        for c in cases:
            self.assertTrue(any(s.startswith('CREATE TABLE m_b01_source ') for s in c.setup_sqls))
            self.assertIn('CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;',c.setup_sqls)
            self.assertNotIn('IF EXISTS',c.sql)
            self.assertRegex(c.sql,r'AS SELECT id,qty FROM m_b01_source')
        self.assertTrue(any('(id,qty)' in c.sql for c in cases))
        self.assertTrue(any('WITH LOCAL CHECK OPTION' in c.sql for c in cases))

    def test_view_rename_and_move_cleanup_tracks_destination(self):
        for c in self.cases('alter_view_rename'):
            self.assertIn('DROP VIEW IF EXISTS m_alter_view_renamed;',c.teardown_sqls)
        for c in self.cases('alter_view_move'):
            self.assertIn('CREATE SCHEMA m_alter_view_destination;',c.setup_sqls)
            clean=c.teardown_sqls
            self.assertLess(clean.index('DROP VIEW IF EXISTS m_alter_view_destination.m_alter_view_target;'),clean.index('DROP SCHEMA m_alter_view_destination;'))
            self.assertTrue(any(e['key']=='destination_schema_authority' for e in c.environment_requirements))
            self.assertFalse(any('CASCADE' in s or 'DROP OWNED' in s for s in clean))

    def test_view_default_noop_not_execution_oracle(self):
        facts=self.r.factors['m_alter_view'].facts
        fact=next(f for f in facts if f.id=='m_alter_view_fact_defaults_noop')
        self.assertIn('暂无实际意义',fact.statement)
        self.assertEqual(self.r.manifests['manifest_m_alter_view_defaults'].expected.scope,'syntax_only')
        self.assertEqual(self.r.scenarios['scenario_m_alter_view_defaults_and_check'].status,'planned')
        for c in self.cases('alter_view_compile_valid'):
            self.assertNotIn('enable_view_invalidation',' '.join(c.setup_sqls))
            self.assertFalse(any(s.startswith('DROP TABLE') for s in c.setup_sqls))

    def test_alter_session_same_connection_before_data(self):
        for suite in ('timezone','parameter','transaction'):
            for c in self.cases('alter_session_'+suite):
                self.assertEqual(c.setup_sqls,['START TRANSACTION;'])
                self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
                self.assertTrue(any(e['key']=='session_lifecycle' for e in c.environment_requirements))
                self.assertNotIn('PASSWORD',c.sql)
                self.assertNotIn('CURRENT_SCHEMA',c.sql)
                self.assertNotIn('{',c.sql)
                if suite=='transaction':
                    self.assertTrue(any(e['key']=='transaction_stage' for e in c.environment_requirements))

    def test_builder_exact_reconstruction(self):
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for builder in BUILDERS.values():
            p=builder()
            if p.id in ('m_drop_audit_policy','m_drop_database','m_drop_owned','m_drop_schema','m_drop_sequence',
'm_rename_table','m_rollback_to_savepoint','m_deallocate','m_do','m_drop_user',
'm_drop_view','m_drop_role','m_grant','m_create_function','m_analyze','m_copy',
'm_alter_table','m_create_table','m_create_table_partition','m_checkpoint','m_drop_prepare',
'm_autohint_purge','m_prepare','m_reset','m_drop_extension','m_drop_group',
'm_rollback','m_autohint','m_comment','m_drop_table','m_use',
'm_alter_resource_label','m_alter_schema','m_create_database','m_set_role','m_alter_database'):
                continue
            for name,obj in rendered_files(p).items():
                path=ROOT/'specs'/p.category.lower()/p.id/name
                self.assertEqual(path.read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110),str(path))


if __name__=='__main__':unittest.main()
