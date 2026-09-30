"""Other System Functions Wave 7 summary checks coverage and totals."""
import json, subprocess, sys, unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
SUMMARY_PATH = ROOT / 'generated/core_other_system_wave7_summary_v1/summary.json'

class CoreOtherSystemWave7SummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.summary=json.loads(SUMMARY_PATH.read_text(encoding='utf-8'))

    def test_identity_and_catalog(self):
        s=self.summary
        self.assertEqual(s['kind'],'core_other_system_wave7_summary')
        self.assertEqual(s['id'],'core_other_system_wave7_summary_v1')
        self.assertEqual(s['catalog']['section_number'],'1.6.60')
        self.assertEqual((s['catalog']['physical_page_start'],s['catalog']['physical_page_end_inclusive']),(1058,1114))
        self.assertRegex(s['catalog']['chapter_sha256'],r'[0-9a-f]{64}')

    def test_page_union_is_complete(self):
        c=self.summary['coverage']
        self.assertEqual(c['mode'],'page_union')
        self.assertEqual((c['covered_page_count'],c['required_page_count']),(57,57))
        self.assertEqual(c['missing_pages'],[]); self.assertEqual(c['extra_pages'],[])
        self.assertEqual(c['overlap_page_count'],0); self.assertEqual(c['overlap_pages'],[])
        self.assertTrue(c['complete'])

    def test_totals_and_unique_ids(self):
        s=self.summary['summary']
        self.assertEqual((s['wave_count'],s['fact_count'],s['unique_fact_id_count']),(2,51,51))
        self.assertEqual((s['open_question_count'],s['unique_open_question_id_count']),(4,4))
        self.assertEqual(s['fact_type_counts'],{'constraint':1,'environment':5,'syntax':45})
        self.assertEqual(s['confirmed_fact_count'],51)
        self.assertEqual(s['open_question_count_by_status'],{'open':4})
        self.assertTrue(all(s[k] for k in ('all_sources_resolved','all_fact_ids_unique','all_open_question_ids_unique','page_coverage_complete')))
        self.assertFalse(s['database_executed']); self.assertFalse(s['runtime_verified'])

    def test_wave_rows_are_complete(self):
        waves=self.summary['waves']
        self.assertEqual([w['wave'] for w in waves],['7-9','7-10'])
        self.assertEqual(sum(w['fact_count'] for w in waves),51)
        self.assertEqual(sum(w['open_question_count'] for w in waves),4)
        self.assertTrue(all(w['source_resolved'] for w in waves))
        self.assertEqual(waves[0]['physical_page_start'],1058)
        self.assertEqual(waves[-1]['physical_page_end_inclusive'],1114)

    def test_written_summary_is_current(self):
        result=subprocess.run([sys.executable,str(ROOT/'scripts/build_core_other_system_wave7_summary.py'),'--check'],cwd=ROOT,text=True,capture_output=True)
        self.assertEqual(result.returncode,0,result.stdout+result.stderr)
        self.assertEqual(json.loads(SUMMARY_PATH.read_text(encoding='utf-8')),self.summary)

if __name__=='__main__': unittest.main()
