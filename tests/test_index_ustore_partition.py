"""Finite USTORE LOCAL capability comes from actual DDL, not profile labels."""
import copy
import unittest

from core import index_partition_contract as contract

SETUP = ['CREATE TABLE g_ci_ustore_local (id INTEGER) WITH (storage_type=ustore) '
         'PARTITION BY RANGE (id) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));']
SQL = 'CREATE INDEX idx_ci_ustore_local ON g_ci_ustore_local USING ubtree (id) LOCAL;'
PROPS = dict(index_partition_contract='ustore_range_local', storage_engine='USTORE',
             partitioned=True, subpartitioned=False, partition_keys=['id'],
             partition_layout=[dict(name='p1', upper=10), dict(name='p2', upper=20)])
GATES = dict(actor_authority=['create_any_index'], table_creation_authority=['create_any_table'],
             case_namespace=['isolated_user_schema'], track_counts=['on'], track_activities=['on'])
TEARDOWN = ['DROP TABLE g_ci_ustore_local RESTRICT;']


class UstorePartitionContractTests(unittest.TestCase):
    def check(self, sql=SQL, setup=SETUP, teardown=TEARDOWN, properties=PROPS, gates=GATES):
        return contract.check_ustore_local_index(sql, setup, teardown,
                  target='g_ci_ustore_local', properties=properties, gates=gates)

    def test_actual_engine_key_and_layout_without_statistics_claim(self):
        result = self.check()
        self.assertEqual(result['storage_engine'], 'USTORE')
        self.assertEqual(result['table_layout'], PROPS['partition_layout'])
        self.assertEqual(result['method'], 'ubtree')
        for flag in ['runtime_proven', 'cleanup_ownership_proven', 'statistics_proven']:
            self.assertIs(result[flag], False)

    def test_false_engine_bounds_or_profile_cannot_pass(self):
        for before, after in [('storage_type=ustore', 'storage_type=astore'),
                              ('id INTEGER', 'id TEXT'), ('RANGE (id)', 'RANGE (other)'),
                              ('THAN (20)', 'THAN (5)'), ('PARTITION p2', 'PARTITION p1')]:
            with self.subTest(after=after), self.assertRaises(ValueError):
                self.check(setup=[SETUP[0].replace(before, after)])
        props = copy.deepcopy(PROPS)
        props['partition_layout'][0]['upper'] = 11
        with self.assertRaises(ValueError):
            self.check(properties=props)

    def test_unreviewed_index_options_and_unsafe_cleanup_are_rejected(self):
        for sql in [SQL.replace('ubtree', 'btree'), SQL.replace('LOCAL', 'GLOBAL'),
                    SQL.replace('INDEX', 'UNIQUE INDEX', 1), SQL.replace('(id) LOCAL', '(other) LOCAL'),
                    SQL.replace('LOCAL;', 'LOCAL WITH (active_pages = 16);'),
                    SQL.replace('idx_ci_ustore_local', 'g_ci_ustore_local')]:
            with self.subTest(sql=sql), self.assertRaises(ValueError):
                self.check(sql=sql)
        with self.assertRaises(ValueError):
            self.check(teardown=['DROP TABLE g_ci_ustore_local CASCADE;'])

    def test_tracking_and_fresh_ownership_gates_are_required(self):
        for key in GATES:
            with self.subTest(key=key), self.assertRaises(ValueError):
                self.check(gates={k:v for k,v in GATES.items() if k != key})
        with self.assertRaises(ValueError):
            self.check(setup=['DROP TABLE IF EXISTS g_ci_ustore_local;'] + SETUP)
