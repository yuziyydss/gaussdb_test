"""No database: actual surviving ordinary DDL is the only inline PK proof."""
import unittest

from core.shared_column_contract import check_rendered_insert_primary_key
from core.finite_sql_contract import ReviewNeeded, Contradiction

DDL='CREATE TABLE t_pk (id INTEGER PRIMARY KEY, note VARCHAR(64));'
SQL="INSERT INTO t_pk (id, note) VALUES (1, 'a') ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note;"


class InlinePrimaryKeyTests(unittest.TestCase):
    def check(self, setup=None, sql=SQL):
        return check_rendered_insert_primary_key(sql,[DDL] if setup is None else setup,
                                                profile_target='t_pk (id, note)',key_columns=['id'])

    def test_valid_inline_key_and_no_target_nothing(self):
        self.assertEqual(self.check()['primary_key'],['id'])
        result=self.check(sql=SQL[:SQL.index('ON CONFLICT')]+'ON CONFLICT DO NOTHING;')
        self.assertFalse(result['runtime_proven'])
        self.assertEqual(result['table'],'t_pk')

    def test_not_null_or_name_does_not_prove_uniqueness(self):
        for replacement in ('NOT NULL',''):
            with self.subTest(replacement=replacement),self.assertRaises(Contradiction):
                self.check([DDL.replace('PRIMARY KEY',replacement)])

    def test_literal_keywords_do_not_create_a_primary_key(self):
        with self.assertRaisesRegex(Contradiction,'primary_key_mismatch'):
            self.check(["CREATE TABLE t_pk (id INTEGER NOT NULL, note TEXT DEFAULT 'PRIMARY KEY');"])

    def test_actual_conflict_key_must_match_primary_key(self):
        with self.assertRaisesRegex(Contradiction,'primary_key_conflict_target_mismatch'):
            self.check(sql=SQL.replace('ON CONFLICT (id)','ON CONFLICT (note)'))

    def test_altered_dropped_and_duplicate_creates_are_not_proof(self):
        for setup in ([DDL,'ALTER TABLE t_pk DROP CONSTRAINT key_name;'],
                      [DDL,'DROP TABLE t_pk;'],[DDL,DDL]):
            with self.subTest(setup=setup),self.assertRaises(ReviewNeeded):
                self.check(setup)

    def test_table_constraints_and_suffixes_are_unproved_not_silently_accepted(self):
        for ddl in ('CREATE TABLE t_pk (id INTEGER, note VARCHAR(64), PRIMARY KEY (id));',
                    DDL[:-1]+' WITH (ORIENTATION = ROW);',
                    'CREATE TABLE t_pk (id INTEGER PRIMARY KEY, note TEXT PRIMARY KEY);'):
            with self.subTest(ddl=ddl),self.assertRaises(ReviewNeeded):
                self.check([ddl])

    def test_wrong_identity_and_opaque_namespace_are_rejected(self):
        with self.assertRaises(Contradiction):
            self.check(sql=SQL.replace('INTO t_pk','INTO another_table'))
        with self.assertRaises(ReviewNeeded):
            self.check(['SET search_path TO other;',DDL])


if __name__=='__main__':unittest.main()
