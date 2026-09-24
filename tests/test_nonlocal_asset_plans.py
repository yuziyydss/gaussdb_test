"""Source-grounded planned requirements are not execution gates or receipts."""
import re
import unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]


class NonlocalAssetPlanTests(unittest.TestCase):
    def scenario(self, category, fid):
        package = ROOT/'specs'/category/fid
        factor = yaml.safe_load((package/(fid+'.factor.yaml')).read_text())
        scene = yaml.safe_load((package/'scenarios/documented_contracts.scenario.yaml').read_text())
        self.assertEqual(scene['status'], 'planned')
        self.assertFalse(any(step.get('candidate') or step.get('sql') for step in scene['steps']))
        return scene

    def test_tablespace_plans_require_filesystem_and_nontransactional_evidence(self):
        for fid in ('create_tablespace','alter_tablespace','drop_tablespace'):
            scene = self.scenario('ddl',fid)
            self.assertTrue({'nontransactional_execution_review','tablespace_filesystem_inventory',
                             'owned_tablespace_receipts','partial_failure_recovery_review'} <= set(scene['execution_requirements']),fid)
            self.assertIn('不能', ''.join(scene['preconditions']))

    def test_dictionary_plans_require_global_state_not_only_schema_isolation(self):
        for fid in ('create_weak_password_dictionary','drop_weak_password_dictionary'):
            scene = self.scenario('ddl',fid)
            self.assertTrue({'global_security_state_authorization','confidential_dictionary_baseline',
                             'exclusive_disposable_environment','precise_restore_review'} <= set(scene['execution_requirements']),fid)

    def test_autohint_execution_and_history_scope_remain_distinct(self):
        for fid in ('autohint','autohint_drop_model','autohint_purge'):
            scene = self.scenario('utility',fid)
            self.assertIn('hint_history_ownership_review',scene['execution_requirements'])
        self.assertIn('query_execution_resource_budget',self.scenario('utility','autohint')['execution_requirements'])
        self.assertIn('matching_sql_identity',self.scenario('utility','autohint_drop_model')['execution_requirements'])
        self.assertIn('all_history_purge_authorization',self.scenario('utility','autohint_purge')['execution_requirements'])

    def test_ambiguous_dictionary_syntax_cites_both_conflicting_shapes(self):
        fid='create_weak_password_dictionary'
        factor=yaml.safe_load((ROOT/'specs/ddl'/fid/(fid+'.factor.yaml')).read_text())
        fact=next(f for f in factor['facts'] if f['id']==fid+'_fact_tuple_ambiguity')
        self.assertEqual(fact['status'],'confirmed')
        chapter=(ROOT/'work/doc2spec/full_general_corpus/general/ddl'/ (fid+'.txt')).read_text().splitlines()
        selected='\n'.join('\n'.join(chapter[int(a)-1:int(b)]) for a,b in re.findall(r'L(\d+)-L(\d+)',fact['source_anchor']))
        self.assertIn("[WITH VALUES]",selected)
        self.assertIn("('********'),('********')",selected)

    def test_hint_runtime_gaps_cite_execution_and_all_history_sources(self):
        for fid, markers in [('autohint',['历史Hint探索记录','执行初始查询']),
                             ('autohint_purge',['所有历史探索结果'])]:
            factor=yaml.safe_load((ROOT/'specs/utility'/fid/(fid+'.factor.yaml')).read_text())
            fact=next(f for f in factor['facts'] if f['id']==fid+'_fact_runtime_contract')
            self.assertEqual(fact['status'],'confirmed')
            self.assertEqual(fact['type'],'environment')
            lines=(ROOT/'work/doc2spec/full_general_corpus/general/utility'/(fid+'.txt')).read_text().splitlines()
            excerpt='\n'.join('\n'.join(lines[int(a)-1:int(b)]) for a,b in re.findall(r'L(\d+)-L(\d+)',fact['source_anchor']))
            for marker in markers:
                self.assertIn(marker,excerpt,fid)
