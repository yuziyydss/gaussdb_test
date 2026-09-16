"""Finite storage checks shared by explicit writes, defaults and literal seeds."""
import unittest
from core.finite_sql_contract import inspect_write


class StringLengthContractTests(unittest.TestCase):
    def test_explicit_insert_and_update_cannot_ignore_varchar_length(self):
        ddl = 'CREATE TABLE t (note VARCHAR(2));'
        for sql in ("INSERT INTO t VALUES ('long')", "UPDATE t SET note='long'"):
            result = inspect_write(sql, [ddl])
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertIn('string_length_unknown', [i['code'] for i in result['issues']])

    def test_ascii_boundaries_and_sql_quote_unescaping(self):
        for literal in ("'a'", "'ab'", "''''", "'a'''"):
            for sql in (f'INSERT INTO t VALUES ({literal})', f'UPDATE t SET note={literal}'):
                result = inspect_write(sql, ['CREATE TABLE t (note VARCHAR(2));'])
                self.assertEqual(result['status'], 'checked', result)
                self.assertIn('shared_ascii_string_literal_lengths', result['checks'])
                self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_multibyte_encoding_and_escape_processing_remain_review(self):
        for literal in ("'中'", "'a\\nb'"):
            for sql in (f'INSERT INTO t VALUES ({literal})', f'UPDATE t SET note={literal}'):
                result = inspect_write(sql, ['CREATE TABLE t (note VARCHAR(8));'])
                self.assertEqual(result['status'], 'needs_review', result)

    def test_default_and_explicit_write_share_the_same_bounded_decision(self):
        for literal, status in (("'ab'", 'checked'), ("'long'", 'needs_review'), ("'中'", 'needs_review')):
            ddl = f'CREATE TABLE t (note VARCHAR(2) DEFAULT {literal});'
            for sql in ('INSERT INTO t DEFAULT VALUES', 'UPDATE t SET note=DEFAULT',
                        f'INSERT INTO t VALUES ({literal})', f'UPDATE t SET note={literal}'):
                result = inspect_write(sql, [ddl])
                self.assertEqual(result['status'], status, result)

    def test_view_alias_uses_base_length_not_only_type_family(self):
        setup = ['CREATE TABLE t (note VARCHAR(2));', 'CREATE VIEW v(label) AS SELECT note FROM t;']
        for sql in ("INSERT INTO v VALUES ('long')", "UPDATE v SET label='long'"):
            self.assertEqual(inspect_write(sql, setup)['status'], 'needs_review')

    def test_no_arbitrary_length_proof_for_expressions_or_unsupported_ddl(self):
        result = inspect_write('UPDATE t SET note=note', ['CREATE TABLE t (note VARCHAR(2));'])
        self.assertNotIn('shared_ascii_string_literal_lengths', result['checks'])
        for ddl in ('CREATE TABLE t (note VARCHAR(2 CHAR))', 'CREATE TABLE t (note custom_type)'):
            result = inspect_write("INSERT INTO t VALUES ('a')", [ddl])
            self.assertNotIn('shared_ascii_string_literal_lengths', result['checks'])
