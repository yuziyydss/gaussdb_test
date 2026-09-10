"""Live audits once, then the same evidence through HTML/JSON/Markdown views."""
import copy
import unittest
from unittest.mock import patch

from fastapi.testclient import TestClient
import main
from core.progress_reporting import factor_progress
from tests.test_generation_diagnostics import audit


class GenerationDiagnosticsViewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.report = main._factor_package_coverage_report()

    def setUp(self):
        self.client = TestClient(main.app)

    def test_live_full_package_report_has_no_unexplained_flags(self):
        p = self.report['progress']
        self.assertEqual(p['generation_diagnostics_unavailable_count'], 0)
        self.assertEqual(p['package_count'], len(main.factor_package_registry.factors))
        self.assertEqual(p['generation_model_satisfied_count'] + p['generation_model_gap_count'],
                         p['with_candidates_count'])
        for fid,row in self.report['factors'].items():
            d=row['display_progress']['generation_diagnostics']
            self.assertNotIn(d['status'],['inconsistent','unavailable'],fid)
            self.assertEqual(d['status']=='satisfied',row['conclusions']['generation_model_complete'],fid)

    def test_api_overview_and_markdown_share_the_same_live_diagnostics(self):
        original=copy.deepcopy(self.report)
        with patch.object(main,'_factor_package_coverage_report',return_value=self.report):
            payload=self.client.get('/api/coverage/summary')
            page=self.client.get('/coverage')
            export=self.client.get('/api/coverage/export-md')
        for response in [payload,page,export]:self.assertEqual(response.status_code,200)
        self.assertEqual(payload.json()['progress'],self.report['progress'])
        for text in [page.text,export.text]:
            self.assertIn('生成模型',text)
            self.assertIn('条件值尚未纳入',text)
            self.assertIn('不是生成异常',text)
        self.assertEqual(self.report,original)

    def test_actual_detail_renders_conditional_ids_and_separate_oracles(self):
        response=self.client.get('/specs/factor/create_resource_pool')
        self.assertEqual(response.status_code,200)
        self.assertIn('为什么未完整',response.text)
        self.assertIn('create_resource_pool_options_dop_one',response.text)
        self.assertIn('create_resource_pool_fact_dop_centralized_conflict',response.text)
        self.assertIn('不代表每条事实都是上方每个缺口的原因',response.text)
        response=self.client.get('/specs/factor/create_index')
        self.assertEqual(response.status_code,200)
        self.assertIn('另列：错误Oracle待校准',response.text)
        self.assertIn('manifest_create_index_include_method_negative',response.text)

    def test_diagnostics_autoescape_untrusted_error_messages(self):
        row=audit(); row['conclusions']['generation_model_complete']=False
        row['manifests']['errors']={'bad':'<script>alert(1)</script>'}
        html=main.templates.env.get_template('_generation_diagnostics.html').render(progress=factor_progress(row))
        self.assertNotIn('<script>',html)
        self.assertIn('&lt;script&gt;',html)


if __name__=='__main__':unittest.main()
