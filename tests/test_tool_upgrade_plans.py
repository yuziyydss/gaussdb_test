"""Planned tool/upgrade boundaries are not normal database execution permission."""
from pathlib import Path
import re
import unittest
import yaml

ROOT=Path(__file__).resolve().parents[1]
TOOLS=('expdp_database','expdp_table','impdp_database_create','impdp_pluggable_database_create',
       'impdp_pluggable_database_recover','impdp_recover','impdp_table','impdp_table_prepare')


class ToolUpgradePlanTests(unittest.TestCase):
    def scene(self,fid,name='documented_contracts'):
        package=ROOT/'specs/utility'/fid
        factor=yaml.safe_load((package/(fid+'.factor.yaml')).read_text())
        self.assertFalse(factor['manifest_refs'])
        s=yaml.safe_load((package/'scenarios'/(name+'.scenario.yaml')).read_text())
        self.assertEqual(s['status'],'planned')
        self.assertFalse(any(isinstance(step,dict) and ('sql' in step or 'candidate' in step) for step in s['steps']))
        return s

    def test_backup_plans_require_tool_and_physical_artifact_identity(self):
        for fid in TOOLS:
            with self.subTest(fid=fid):
                s=self.scene(fid)
                self.assertTrue({'authoritative_backup_tool_context','physical_backup_artifact_inventory',
                                 'import_export_phase_identity','partial_failure_recovery_review'}<=set(s['execution_requirements']))

    def test_pdb_import_dependency_cannot_be_empty_precondition(self):
        s=self.scene('impdp_pluggable_database_create','export_dependency')
        self.assertTrue(s['preconditions'])
        self.assertIn('export_success_and_file_identity',s['execution_requirements'])
        self.assertIn('abnormal_restart_recovery_control',s['execution_requirements'])

    def test_upgrade_plans_do_not_equate_guc_values_to_real_upgrade(self):
        for fid in ('generated_update_system_object','refresh_system_object'):
            s=self.scene(fid)
            self.assertIn('authoritative_upgrade_context',s['execution_requirements'])
            self.assertIn('initial_user_identity_proof',s['execution_requirements'])
            self.assertIn('不能', ''.join(s['preconditions']))

    def test_shutdown_needs_node_recovery_not_only_one_database(self):
        s=self.scene('shutdown')
        self.assertTrue({'exclusive_disposable_node','out_of_band_restart_control',
                         'client_transaction_impact_review'}<=set(s['execution_requirements']))

    def test_pdb_name_conflict_cites_grammar_and_parameter_statement(self):
        fid='impdp_pluggable_database_create'
        factor=yaml.safe_load((ROOT/'specs/utility'/fid/(fid+'.factor.yaml')).read_text())
        f=next(f for f in factor['facts'] if f['id']==fid+'_fact_name_optional_ambiguity')
        self.assertEqual(f['status'],'needs_verification')
        lines=(ROOT/'work/doc2spec/full_general_corpus/general/utility'/(fid+'.txt')).read_text().splitlines()
        selected='\n'.join('\n'.join(lines[int(a)-1:int(b)]) for a,b in re.findall(r'L(\d+)-L(\d+)',f['source_anchor']))
        self.assertIn('IMPDP PLUGGABLE DATABASE pdb_name CREATE SOURCE',selected)
        self.assertIn('如不指定',selected)
