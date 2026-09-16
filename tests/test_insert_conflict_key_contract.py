"""Same-key PG tuple assignment is not arbitrary key mutation or DUPLICATE KEY."""
import unittest

DDL = 'CREATE TABLE g_insert_pg_key (id INTEGER PRIMARY KEY, note VARCHAR(64));'
SEED = "INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'existing'), (-1, 'blocked');"
SQL = ("INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'alpha') "
       'ON CONFLICT (id) DO UPDATE SET (id, note) = (EXCLUDED.id, EXCLUDED.note) '
       'WHERE g_insert_pg_key.id > 0;')
GATES = {'compatibility_mode':['PG'], 'actor_authority':['fixture_creator_insert_select_update'],
         'case_namespace':['isolated_user_schema']}


class ConflictKeyTests(unittest.TestCase):
    def check(self, sql=SQL, setup=None, gates=None):
        from core.insert_conflict_key_contract import check_same_key_tuple
        return check_same_key_tuple(sql, setup or [DDL, SEED], ['DROP TABLE g_insert_pg_key;'],
                                    GATES if gates is None else gates)

    def test_three_actual_input_branches(self):
        for values, branch, rows in [
            ("(101, 'alpha')", 'update_same_key', [[-1,'blocked'],[101,'alpha']]),
            ("(102, 'beta')", 'insert_new_key', [[-1,'blocked'],[101,'existing'],[102,'beta']]),
            ("(-1, 'ignored')", 'where_filtered', [[-1,'blocked'],[101,'existing']]),
        ]:
            result = self.check(SQL.replace("(101, 'alpha')", values))
            self.assertEqual(result['branch'], branch)
            self.assertEqual(result['planned_rows'], rows)
            self.assertFalse(result['runtime_proven'])

    def test_actual_key_ddl_seed_and_mode_not_labels(self):
        for setup in [[DDL.replace('PRIMARY KEY','NOT NULL'), SEED],
                      [DDL.replace('INTEGER','BIGINT'), SEED],
                      [DDL,SEED, 'CREATE UNIQUE INDEX extra ON g_insert_pg_key(note);'],
                      [DDL,SEED.replace("(-1, 'blocked')", "(101, 'duplicate')")]]:
            with self.subTest(setup=setup), self.assertRaises(ValueError):self.check(setup=setup)
        for gates in ({}, dict(GATES, compatibility_mode=['M'])):
            with self.assertRaises(ValueError):self.check(gates=gates)

    def test_key_change_arity_subquery_predicate_and_duplicate_inputs_fail_closed(self):
        for old,new in [('EXCLUDED.id','EXCLUDED.id + 1'), ('EXCLUDED.id','102'),
                        ('EXCLUDED.id, EXCLUDED.note','EXCLUDED.note, EXCLUDED.id'),
                        ('EXCLUDED.id, EXCLUDED.note','EXCLUDED.id'),
                        ('WHERE g_insert_pg_key.id > 0','WHERE EXCLUDED.id > 0'),
                        ("VALUES (101, 'alpha')", "VALUES (101, 'alpha'), (101, 'beta')"),
                        ('ON CONFLICT (id) DO UPDATE SET','ON DUPLICATE KEY UPDATE'),
                        ('EXCLUDED.note',"(SELECT 'alpha')")]:
            with self.subTest(new=new), self.assertRaises(ValueError):self.check(SQL.replace(old,new))

if __name__ == '__main__':unittest.main()
