"""MERGE ON column/type shape is separate from matching rows and action WHERE."""
import hashlib
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class MergeOnFilterContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INTEGER, n INTEGER, note VARCHAR(64))',
             'CREATE TABLE s (id INTEGER, n INTEGER, note VARCHAR(64))']
    action = 'WHEN MATCHED THEN UPDATE SET n = src.n'

    def check(self, condition='dst.id = src.id AND src.id > 0', *, action=None, setup=None, scope='general'):
        return inspect_write('MERGE INTO t dst USING s src ON ('+condition+') '+(self.action if action is None else action),
                             self.setup if setup is None else setup, conflict_source_scope=scope)

    def test_source_greater_than_literal_is_finite_for_both_equality_orders(self):
        for condition in ('dst.id = src.id AND src.id > 0', 'src.id = dst.id AND src.n > -7',
                          'DST.ID=SRC.ID\nAND SRC.N>+7'):
            r=self.check(condition)
            self.assertEqual(r['status'], 'checked', r)
            self.assertIn('merge_source_integer_on_filter', r['checks'])
            self.assertEqual(r['scope'], 'finite_write_shape_only')
            self.assertNotIn('expected_rows', r)

    def test_nullable_column_is_not_a_proof_of_truth_or_matched_rows(self):
        r=self.check()
        self.assertEqual(r['status'], 'checked', r)
        self.assertNotIn('matched_rows', r)
        self.assertNotIn('runtime_proven', r)
        self.assertNotIn('predicate_true', r['checks'])

    def test_unresolved_filter_columns_and_aliases_need_identity_review(self):
        r=self.check('dst.id = src.id AND src.absent > 0')
        self.assertEqual(r['status'], 'needs_review', r)
        for alias in ('dst', 'other'):
            self.assertEqual(self.check(f'dst.id = src.id AND {alias}.n > 0')['status'], 'needs_review')

    def test_implicit_system_columns_are_not_mislabeled_as_missing_user_columns(self):
        for name in ('ctid','tableoid','xmin','rowid','rowno'):
            r=self.check(f'dst.id = src.id AND src.{name} > 0')
            self.assertEqual(r['status'],'needs_review',r)

    def test_non_integer_column_and_literal_coercions_remain_unknown(self):
        for condition in ('dst.id = src.id AND src.note > 0', 'dst.id = src.id AND src.id > NULL',
                          "dst.id = src.id AND src.id > '0'", 'dst.id = src.id AND src.id > 0.5',
                          'dst.id = src.id AND src.id > DEFAULT', 'dst.id = src.id AND src.id > 2147483648'):
            self.assertEqual(self.check(condition)['status'], 'needs_review', condition)
        self.assertEqual(self.check('dst.id = src.id AND src.n > 0',setup=[self.setup[0],
            'CREATE TABLE s (id INTEGER, n NUMERIC(8,2), note VARCHAR(64))'])['status'], 'needs_review')

    def test_shared_signed_domain_bounds_are_conservative_not_predicate_errors(self):
        for typ,inside,outside in [('SMALLINT','32767','32768'),('BIGINT','9223372036854775807','9223372036854775808')]:
            setup=[self.setup[0],f'CREATE TABLE s (id INTEGER, n {typ}, note VARCHAR(64))']
            for literal,status in ((inside,'checked'),(outside,'needs_review')):
                r=self.check('dst.id = src.id AND src.n > '+literal,setup=setup,
                             action='WHEN MATCHED THEN UPDATE SET note = src.note')
                self.assertEqual(r['status'],status,r)

    def test_only_one_complete_source_filter_not_arbitrary_boolean_expression(self):
        for condition in ('dst.id = src.id OR src.id > 0', 'dst.id = src.id AND src.id > 0 OR src.n > 0',
                          'dst.id = src.id AND src.id > 0 AND src.n > 0',
                          'dst.id = src.id AND src.id > (SELECT 0)', 'dst.id = src.id AND src.id >= 0',
                          'dst.id = src.id AND src.id > 0;', 'dst.id = src.id AND src.id > 0 /*x*/',
                          'dst.id = src.id AND src.id > ０'):
            self.assertEqual(self.check(condition)['status'],'needs_review',condition)

    def test_all_actions_are_still_checked_after_on_predicate(self):
        for action,code in [('WHEN MATCHED THEN UPDATE SET id = src.id','merge_join_key_update_not_supported'),
                            ('','merge_action_required'),
                            (self.action+' '+self.action,'duplicate_merge_when_clause'),
                            ('WHEN NOT MATCHED THEN INSERT (id) VALUES (src.id), (src.id)','merge_multiple_values_not_supported')]:
            r=self.check(action=action)
            self.assertEqual(r['status'],'rejected',r)
            self.assertEqual(r['issues'][0]['code'],code)
        for action in (self.action+' WHERE dst.n > 0', 'WHEN MATCHED THEN UPDATE SET n = src.n + 1'):
            self.assertEqual(self.check(action=action)['status'],'needs_review')

    def test_unknown_modes_and_filtered_view_source_do_not_borrow_general_proof(self):
        for scope in ('m_compat','unknown',None):
            self.assertEqual(self.check(scope=scope)['status'],'needs_review')
        self.assertEqual(self.check(setup=[self.setup[0], 'CREATE TABLE b (id INTEGER,n INTEGER,note VARCHAR(64))',
                         'CREATE VIEW s AS SELECT id,n,note FROM b WHERE id > 0'])['status'],'needs_review')


class MergeOnFilterConsumersTests(unittest.TestCase):
    def test_five_actual_ordinary_consumers_not_the_view_or_where_variants(self):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        root=Path(__file__).resolve().parents[1]
        r=FactorPackageRegistry(root/'specs');r.load_all()
        cases=FactorPackageSQLGenerator(r).generate_cases_for_manifest(r.manifests['manifest_merge_regular_positive'])
        selected=[c for c in cases if c.params['on_condition']=='merge_on_id_equal_positive'
                  and c.params['source_profile'] in ('merge_source_table_as','merge_source_table_bare_alias')
                  and ' WHERE ' not in c.sql]
        self.assertEqual(len(selected),5)
        for c in selected:
            result=inspect_write(c.sql,c.setup_sqls)
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('merge_source_integer_on_filter',result['checks'])
            # Preserve the existing manifest's intended expectation; it is
            # not a runtime verification status.
            self.assertEqual(c.expected_scope,'syntax_and_semantics')
        source=root/'work/doc2spec/full_general_corpus/general/dml/merge_into.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),r.factors['merge_into'].source.artifact_sha256)


if __name__=='__main__':
    unittest.main()
