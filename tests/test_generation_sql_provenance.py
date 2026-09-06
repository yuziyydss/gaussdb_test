"""Same SQL text is not a global test identity: chapters can document aliases."""
import unittest
from types import SimpleNamespace

from scripts.generate_factor_package_sql import record_sql_provenance
from core.spec_generator import GenerationValidationError


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
