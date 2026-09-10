"""Same SQL text is not a global test identity: chapters can document aliases."""
import unittest
from types import SimpleNamespace

from scripts.generate_factor_package_sql import record_sql_provenance
from core.spec_generator import GenerationValidationError
from core.candidate_identity import setup_signature


class SQLProvenanceTests(unittest.TestCase):
    def test_cross_factor_overlap_retains_both_case_origins(self):
        origins = {}
        record_sql_provenance(origins, "begin", "m_begin", [SimpleNamespace(sql="BEGIN;", case_id="b1")])
        record_sql_provenance(origins, "start_transaction", "m_start", [SimpleNamespace(sql="BEGIN;", case_id="s1")])
        self.assertEqual(len(origins), 1)
        self.assertEqual([x["case_id"] for x in origins["BEGIN;"]], ["b1", "s1"])
        self.assertEqual({x["factor_id"] for x in origins["BEGIN;"]}, {"begin", "start_transaction"})

    def test_same_factor_duplicate_still_fails(self):
        origins = {}
        record_sql_provenance(origins, "begin", "m1", [SimpleNamespace(sql="BEGIN;", case_id="b1")])
        with self.assertRaises(GenerationValidationError):
            record_sql_provenance(origins, "begin", "m2", [SimpleNamespace(sql="BEGIN;", case_id="b2")])

    def test_same_target_with_two_actual_seed_inputs_is_not_a_duplicate(self):
        origins={};setups={}
        for cid,seed in (('six','INSERT INTO t VALUES (1),(2);'),('null','INSERT INTO t VALUES (NULL);')):
            record_sql_provenance(origins,'m_select',cid,[SimpleNamespace(
                sql='SELECT COUNT(x) FROM t;',case_id=cid,setup_sqls=['CREATE TABLE t(x INT);',seed])],setups)
        self.assertEqual(len(origins),1)
        self.assertEqual([x['case_id'] for x in origins['SELECT COUNT(x) FROM t;']],['six','null'])

    def test_new_ids_expectations_or_cleanup_do_not_disguise_duplicate_setup(self):
        origins={};setups={}
        original=SimpleNamespace(sql='SELECT COUNT(x) FROM t;',case_id='a',setup_sqls=['CREATE TABLE t(x INT);'])
        record_sql_provenance(origins,'m_select','a',[original],setups)
        for attrs in ({'expected':'error'},{'teardown_sqls':['DROP TABLE t;']},{'fixture_refs':['other_name']},
                      {'setup_sqls':['  CREATE TABLE t(x INT);  ']}):
            candidate=SimpleNamespace(**{**vars(original),'case_id':'b',**attrs})
            with self.subTest(attrs=attrs),self.assertRaises(GenerationValidationError):
                record_sql_provenance(origins,'m_select','b',[candidate],setups)

    def test_missing_prior_setup_evidence_does_not_enable_a_second_candidate(self):
        origins={}
        record_sql_provenance(origins,'m_select','a',[SimpleNamespace(sql='SELECT 1;',case_id='a')])
        with self.assertRaises(GenerationValidationError):
            record_sql_provenance(origins,'m_select','b',
                [SimpleNamespace(sql='SELECT 1;',case_id='b',setup_sqls=['CREATE TABLE t(x INT);'])],{})

    def test_setup_identity_preserves_literal_content_order_and_rejects_nonstatements(self):
        self.assertEqual(setup_signature([' SELECT 1; ']),('SELECT 1',))
        self.assertNotEqual(setup_signature(["SELECT 'a  b';"]),setup_signature(["SELECT 'a b';"]))
        self.assertNotEqual(setup_signature(['SELECT 1;','SELECT 2;']),setup_signature(['SELECT 2;','SELECT 1;']))
        for raw in (None,'SELECT 1;', [''],[' ; '],[None]):
            with self.subTest(raw=raw),self.assertRaises(ValueError):setup_signature(raw)
