"""Ordinary, source-backed MERGE shape/column proofs are not execution proofs."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from core.finite_sql_contract import inspect_write


class MergeColumnContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INTEGER, note VARCHAR(64), n INTEGER DEFAULT 7)',
             'CREATE TABLE s (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER)']
    prefix = 'MERGE INTO t AS dst USING s AS src ON (dst.id = src.id) '
    update = 'WHEN MATCHED THEN UPDATE SET note = src.note, n = DEFAULT'
    insert = 'WHEN NOT MATCHED THEN INSERT (id, note) VALUES (src.id, src.note)'

    def inspect(self, body, *, prefix=None, setup=None, scope='general'):
        return inspect_write((self.prefix if prefix is None else prefix)+body,
                             self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def expect(self, body, status, code=None, **kwargs):
        result = self.inspect(body, **kwargs)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertEqual(result['issues'][0]['code'], code, result)
        return result

    def test_both_clause_orders_and_individual_actions(self):
        for body in (self.update, self.insert, self.update+' '+self.insert, self.insert+' '+self.update):
            result=self.expect(body, 'checked')
            self.assertEqual(result['scope'], 'finite_write_shape_only')
            self.assertIn('merge_ordinary_source_target_columns', result['checks'])

    def test_tuple_update_and_default_values_reuse_defaults(self):
        for body in ('WHEN MATCHED THEN UPDATE SET (note, n) = (src.note, DEFAULT)',
                     'WHEN NOT MATCHED THEN INSERT DEFAULT VALUES'):
            result=self.expect(body,'checked')
            self.assertIn('shared_ordinary_defaults',result['checks'])

    def test_documented_action_restrictions(self):
        self.expect('', 'rejected', 'merge_action_required')
        for body in (self.update+' '+self.update, self.insert+' '+self.insert):
            self.expect(body,'rejected','duplicate_merge_when_clause')
        self.expect('WHEN MATCHED THEN UPDATE SET id = src.id','rejected','merge_join_key_update_not_supported')
        self.expect(self.insert+', (src.id, src.note)','rejected','merge_multiple_values_not_supported')

    def test_missing_columns_and_arity(self):
        for body in ('WHEN MATCHED THEN UPDATE SET absent = src.note',
                     'WHEN MATCHED THEN UPDATE SET note = src.absent',
                     'WHEN NOT MATCHED THEN INSERT (absent) VALUES (1)'):
            self.expect(body,'rejected','missing_column')
        for body in ('WHEN MATCHED THEN UPDATE SET (note,n) = (src.note)',
                     'WHEN NOT MATCHED THEN INSERT (id,n) VALUES (1)'):
            self.expect(body,'rejected','arity')

    def test_default_and_explicit_null_cannot_hide_not_null(self):
        setup=['CREATE TABLE t (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER)',self.setup[1]]
        for body in ('WHEN NOT MATCHED THEN INSERT DEFAULT VALUES',
                     'WHEN NOT MATCHED THEN INSERT (note) VALUES (src.note)',
                     'WHEN NOT MATCHED THEN INSERT (id) VALUES (NULL)'):
            self.expect(body,'rejected','null_not_allowed',setup=setup)

    def test_source_domains_and_nullability_are_not_guessed(self):
        for source in ('CREATE TABLE s (id BIGINT, note VARCHAR(64), n INTEGER)',
                       'CREATE TABLE s (id INTEGER, note VARCHAR(100), n INTEGER)'):
            self.expect(self.insert,'needs_review',setup=[self.setup[0],source])
        target='CREATE TABLE t (id INTEGER, note VARCHAR(64) NOT NULL, n INTEGER)'
        self.expect(self.update,'needs_review',setup=[target,self.setup[1]])

    def test_literal_domain_and_quoted_keywords(self):
        self.expect("WHEN MATCHED THEN UPDATE SET note = 'WHEN MATCHED THEN x'",'checked')
        self.expect("WHEN MATCHED THEN UPDATE SET note = 'x'' WHEN MATCHED THEN y'",'checked')
        self.expect("WHEN MATCHED THEN UPDATE SET note = '"+'x'*65+"'",'needs_review')
        self.expect('WHEN MATCHED THEN UPDATE SET n = 2147483648','needs_review','assignment_range_unknown')
        self.expect('WHEN MATCHED THEN UPDATE SET n = src.n + 1','needs_review')

    def test_case_where_and_complex_on_stay_review(self):
        for body in ('WHEN MATCHED THEN UPDATE SET n = CASE WHEN MATCHED THEN 1 ELSE 2 END',
                     self.update+' WHERE dst.n > 0', self.insert+' WHERE dst.id > 0'):
            self.expect(body,'needs_review')
        self.expect(self.update,'needs_review',prefix=self.prefix.replace('dst.id = src.id','dst.id = src.id AND dst.n > 0'))

    def test_complex_views_subqueries_partitions_and_ctes_stay_review(self):
        for prefix in ('MERGE INTO t dst USING (SELECT * FROM s WHERE id > 0) src ON (dst.id=src.id) ',
                       'MERGE INTO t PARTITION(p1) dst USING s src ON(dst.id=src.id) ',
                       'WITH c AS (SELECT id,note,n FROM s) MERGE INTO t dst USING c src ON(dst.id=src.id) '):
            self.expect(self.update,'needs_review',prefix=prefix)
        self.expect(self.update,'needs_review',prefix=self.prefix.replace('USING s','USING v'),
                    setup=self.setup+['CREATE VIEW v AS SELECT id, note, n FROM s WHERE id > 0'])

    def test_mode_aliases_and_opaque_setup_do_not_supply_proof(self):
        for scope in ('m_compat','unreviewed',None):
            self.expect(self.update,'needs_review',scope=scope)
        for prefix in (self.prefix.replace(' AS dst',''), self.prefix.replace('src','dst'),
                       self.prefix.replace('src.id','src.absent')):
            self.assertNotEqual(self.inspect(self.update,prefix=prefix)['status'],'checked')
        self.expect(self.update,'needs_review',setup=self.setup+['SET search_path=public'])

    def test_unparsed_lexical_or_target_domains_stay_review(self):
        for body in ('WHEN MATCHED THEN UPDATE SET note = $x$WHEN MATCHED THEN$x$',
                     'WHEN MATCHED THEN UPDATE SET n = dst.n',
                     'WHEN MATCHED THEN UPDATE SET n = n',
                     'WHEN MATCHED THEN UPDATE SET n = 1, n = 2',
                     'WHEN NOT MATCHED THEN INSERT(id,id) VALUES(1,2)'):
            self.expect(body,'needs_review')

    def test_dangling_comma_is_not_a_proved_multiple_values_violation(self):
        for tail in (',', ', garbage', ', (src.id,src.note) trailing'):
            self.expect(self.insert+tail,'needs_review')

    def test_reversed_join_alias_case_and_complete_unlisted_insert(self):
        self.expect(self.update, 'checked', prefix=self.prefix.replace('dst.id = src.id','src.id = dst.id'))
        self.expect('WHEN NOT MATCHED THEN INSERT VALUES (src.id, src.note, src.n)', 'checked')
        self.expect('WHEN MATCHED THEN UPDATE SET n = 1', 'checked',
                    prefix=self.prefix.replace(' AS ', ' ').replace('src.id','SRC.ID'))

    def test_dynamic_defaults_and_generated_columns_do_not_become_null(self):
        for ddl in ('CREATE TABLE t (id INTEGER, note VARCHAR(64), n INTEGER DEFAULT nextval(\'seq\'))',
                    'CREATE TABLE t (id INTEGER, note VARCHAR(64), n INTEGER GENERATED ALWAYS AS (id+1) STORED)'):
            self.expect(self.update,'needs_review',setup=[ddl,self.setup[1]])


class MergeColumnContractIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        cls.root=Path(__file__).resolve().parents[1]
        cls.registry=FactorPackageRegistry(cls.root/'specs'); cls.registry.load_all()
        cls.generator=FactorPackageSQLGenerator(cls.registry)

    def test_source_identity_and_ledger_link_the_actual_rules(self):
        factor=self.registry.factors['merge_into']
        source=self.root/'work/doc2spec/full_general_corpus/general/dml/merge_into.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),factor.source.artifact_sha256)
        ledger=self.registry.source_ledgers[factor.source_ledger_ref]
        facts={f.id:f for f in factor.facts}
        for fid in ('merge_fact_join_key_immutable','merge_fact_action_required',
                    'merge_fact_no_duplicate_clause','merge_fact_no_multiple_values','merge_fact_default_behavior'):
            self.assertEqual(facts[fid].status,'confirmed')
            self.assertTrue(any(fid in u.fact_refs for u in ledger.units),fid)

    def test_all_real_cases_keep_errors_and_unknowns_separate(self):
        from collections import Counter
        from scripts.audit_rendered_sql_contracts import audit_report
        entries={}
        for mid,m in self.registry.manifests.items():
            if m.factor_ref != 'merge_into':
                continue
            cases,report=self.generator.generate_with_report(m)
            self.assertTrue(report.pairwise_complete)
            entries[mid]={'cases':[dict(case_id=c.case_id,factor_id=c.factor_id,expected=c.expected,
                sql=c.sql,setup_sqls=c.setup_sqls,teardown_sqls=c.teardown_sqls) for c in cases]}
            for c in cases:
                if c.expected=='error':
                    result=inspect_write(c.sql,c.setup_sqls)
                    self.assertEqual(result['status'],'rejected',result)
                    self.assertEqual(result['issues'][0]['code'],c.expected_error_category)
                    self.assertEqual(c.expected_oracle_status,'needs_verification')
                    self.assertEqual(c.expected_sqlstates,[])
        audit=audit_report({'manifests':entries})
        self.assertFalse(audit['database_executed'])
        self.assertEqual(len(entries),9)
        self.assertEqual(audit['summary']['cases'],45)
        self.assertEqual(Counter(c['write_contract']['status'] for c in audit['cases']),
                         Counter(checked=41,rejected=4))
        self.assertEqual(audit['summary']['positive_rejected'],0)

    def test_existing_generation_gate_rejects_forged_valid_profile_render(self):
        from core.spec_generator import GenerationValidationError
        matrix=self.registry.matrices['matrix_merge_action_profiles']
        profile=next(p for p in matrix.profiles if p.id=='merge_action_matched_only')
        manifest=self.registry.manifests['manifest_merge_regular_positive'].model_copy(deep=True)
        manifest.bindings.update(target_profile=['merge_target_regular_as'],
                                 source_profile=['merge_source_table_as'],
                                 on_condition=['merge_on_id_equal'],
                                 action_profile=[profile.id])
        original=profile.render
        try:
            for render,code in (
                ('', 'merge_action_required'),
                ('WHEN MATCHED THEN UPDATE SET id = src.id','merge_join_key_update_not_supported'),
                (original+' '+original,'duplicate_merge_when_clause'),
                ('WHEN NOT MATCHED THEN INSERT (id) VALUES (src.id), (src.id)',
                 'merge_multiple_values_not_supported')):
                # Keep validity/properties/expected positive; only render is
                # corrupted so the combination rules cannot catch this for us.
                profile.render=render
                with self.assertRaisesRegex(GenerationValidationError,code):
                    self.generator.generate_with_report(manifest)
        finally:
            profile.render=original
        cases,report=self.generator.generate_with_report(manifest)
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected,'success')


class MergeAuditCLITests(unittest.TestCase):
    def test_positive_contradiction_fails_cli_and_fingerprints_merge_checker(self):
        root=Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory() as temp:
            report, output=Path(temp)/'input.json',Path(temp)/'audit.json'
            case=dict(case_id='merge_fixture_probe',factor_id='merge_into',expected='success',
                      sql=MergeColumnContractTests.prefix,
                      setup_sqls=MergeColumnContractTests.setup,teardown_sqls=[])
            report.write_text(json.dumps({'manifests':{'probe':{'cases':[case]}}}))
            cmd=[sys.executable,str(root/'scripts/audit_rendered_sql_contracts.py'),
                 '--generation-report',str(report),'--output',str(output)]
            result=subprocess.run(cmd,cwd=root,capture_output=True,text=True,timeout=30)
            self.assertEqual(result.returncode,1,result.stderr)
            audit=json.loads(output.read_text())
            self.assertEqual(audit['summary']['positive_rejected'],1)
            self.assertFalse(audit['database_executed'])
            path='core/merge_column_contract.py'
            self.assertEqual(audit['checker_files_sha256'][path],hashlib.sha256((root/path).read_bytes()).hexdigest())
            # A valid control must still pass the same CLI; do not invert the gate.
            case['sql']+=MergeColumnContractTests.update
            report.write_text(json.dumps({'manifests':{'probe':{'cases':[case]}}}))
            result=subprocess.run(cmd,cwd=root,capture_output=True,text=True,timeout=30)
            self.assertEqual(result.returncode,0,result.stderr)
            self.assertEqual(json.loads(output.read_text())['summary']['write_contract'],{'checked':1})


if __name__ == '__main__':
    unittest.main()
