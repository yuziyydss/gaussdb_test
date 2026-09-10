"""Top-level general RETURNING must resolve outputs, not only write inputs."""
import hashlib
import json
from pathlib import Path
import unittest
from core.finite_sql_contract import inspect_write


class ReturningColumnContractTests(unittest.TestCase):
    setup=['CREATE TABLE t (id INTEGER, note TEXT)', 'CREATE TABLE s (key INTEGER, label TEXT)']

    def inspect(self,sql,scope='general',setup=None):
        return inspect_write(sql,self.setup if setup is None else setup,conflict_source_scope=scope)

    def test_real_missing_column_repro_for_insert_and_update(self):
        for sql in ('INSERT INTO t(id) VALUES(1) RETURNING missing',
                    'UPDATE t SET id=1 RETURNING missing'):
            r=self.inspect(sql)
            self.assertEqual(r['status'],'rejected',r)
            self.assertEqual(r['issues'][0]['code'],'missing_column')

    def test_direct_columns_alias_and_star_expose_only_type_families(self):
        for sql in ('INSERT INTO t(id) VALUES(1) RETURNING id,note AS payload',
                    'UPDATE t AS dst SET note=\'x\' RETURNING dst.id,dst.note AS payload'):
            r=self.inspect(sql)
            self.assertEqual(r['status'],'checked',r)
            self.assertEqual(r['returning_output']['columns'],[
                {'name':'id','type_family':'integer'},{'name':'payload','type_family':'text'}])
            self.assertIn('finite_returning_output_columns',r['checks'])
        for output in ('*','t.*'):
            r=self.inspect('INSERT INTO t(id) VALUES(1) RETURNING '+output)
            self.assertEqual([c['name'] for c in r['returning_output']['columns']],['id','note'])

    def test_duplicate_output_names_are_not_view_column_errors(self):
        r=self.inspect('UPDATE t SET id=1 RETURNING id,id AS id')
        self.assertEqual(r['status'],'checked',r)
        self.assertEqual([c['name'] for c in r['returning_output']['columns']],['id','id'])

    def test_one_actual_from_source_is_a_separate_namespace(self):
        for output in ('id,src.label AS source_label','t.id,label AS source_label'):
            r=self.inspect("UPDATE t SET note='x' FROM s AS src WHERE id=src.key RETURNING "+output)
            self.assertEqual(r['status'],'checked',r)
            self.assertEqual(r['returning_output']['columns'][1],{'name':'source_label','type_family':'text'})
        r=self.inspect("UPDATE t SET note='x' FROM s AS src RETURNING src.missing")
        self.assertEqual(r['status'],'rejected',r)

    def test_from_ambiguity_and_unqualified_star_stay_review(self):
        for output in ('*','id'):
            r=self.inspect('UPDATE t SET note=\'x\' FROM s AS src RETURNING '+output,
                           setup=[self.setup[0],'CREATE TABLE s(id INTEGER)'])
            self.assertEqual(r['status'],'needs_review',r)
        r=self.inspect("UPDATE t SET note='x' FROM s AS src RETURNING t.*,src.*")
        self.assertEqual(r['status'],'checked',r)
        self.assertEqual(len(r['returning_output']['columns']),4)

    def test_alias_hides_unproved_qualifiers_and_query_source_is_not_returning_target(self):
        for sql in ('UPDATE t AS dst SET id=1 RETURNING other.id',
                    'INSERT INTO t(id) SELECT key FROM s RETURNING s.key'):
            self.assertEqual(self.inspect(sql)['status'],'needs_review')

    def test_untyped_or_unparsed_output_expressions_are_not_checked(self):
        for output in ('NULL','DEFAULT','TRUE','CURRENT_DATE','USER','SYSDATE','t.ctid',
                       'vendor_fn(id)','id + 1','id,',
                       '$tag$RETURNING missing$tag$','id INTO some_table'):
            r=self.inspect('INSERT INTO t(id) VALUES(1) RETURNING '+output)
            self.assertEqual(r['status'],'needs_review',r)

    def test_mode_and_statement_shape_do_not_borrow_general_returning_rules(self):
        for scope in ('m_compat','unreviewed',None):
            self.assertEqual(self.inspect('UPDATE t SET id=1 RETURNING id',scope)['status'],'needs_review')
        for sql in ('REPLACE INTO t(id) VALUES(1) RETURNING id',
                    'UPDATE t AS a,s AS b SET a.id=1 RETURNING a.id'):
            self.assertEqual(self.inspect(sql)['status'],'needs_review')

    def test_strings_nested_returning_and_absence_do_not_fake_outer_projection(self):
        for sql in ("INSERT INTO t(note) VALUES('RETURNING missing')",'UPDATE t SET id=1'):
            r=self.inspect(sql)
            self.assertEqual(r['status'],'checked',r)
            self.assertNotIn('returning_output',r)
        r=self.inspect('WITH x AS (INSERT INTO t(id) VALUES(1) RETURNING id) INSERT INTO t(id) SELECT id FROM x')
        self.assertEqual(r['status'],'checked',r)
        self.assertNotIn('returning_output',r)

    def test_outer_cte_returning_still_checks_actual_target(self):
        sql='WITH x(n) AS (VALUES(1)) INSERT INTO t(id) SELECT n FROM x RETURNING '
        self.assertEqual(self.inspect(sql+'id')['status'],'checked')
        self.assertEqual(self.inspect(sql+'missing')['status'],'rejected')

    def test_view_and_derived_outputs_use_the_exposed_columns_not_hidden_base(self):
        setup=self.setup+['CREATE VIEW v(k,payload) AS SELECT id,note FROM t']
        for sql in ('UPDATE v SET k=1 RETURNING payload',
                    'UPDATE (SELECT id,note FROM t) AS dst SET id=1 RETURNING dst.note'):
            self.assertEqual(self.inspect(sql,setup=setup)['status'],'checked')
        self.assertEqual(self.inspect('UPDATE v SET k=1 RETURNING note',setup=setup)['status'],'rejected')


class ReturningColumnContractIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.root=Path(__file__).resolve().parents[1]
        cls.registry=FactorPackageRegistry(cls.root/'specs');cls.registry.load_all()

    def test_actual_source_facts_and_rendered_from_output(self):
        for fid,fact_id in (('insert','insert_fact_returning_output'),('update','update_fact_returning')):
            factor=self.registry.factors[fid]
            source=self.root/'work/doc2spec/full_general_corpus/general/dml'/(fid+'.txt')
            self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),factor.source.artifact_sha256)
            fact=next(f for f in factor.facts if f.id==fact_id)
            self.assertEqual(fact.status,'confirmed')
        report=json.loads((self.root/'generated/factor_packages/generation_report.json').read_text())
        c=report['manifests']['manifest_update_returning_from_positive']['cases'][0]
        r=inspect_write(c['sql'],c['setup_sqls'])
        self.assertEqual(r['status'],'checked',r)
        self.assertEqual(r['returning_output']['columns'],[
            {'name':'id','type_family':'integer'},{'name':'source_label','type_family':'text'}])
        from scripts.audit_rendered_sql_contracts import audit_report
        audited=audit_report({'manifests':{'actual':{'cases':[c]}}})
        self.assertFalse(audited['database_executed'])
        self.assertEqual(audited['cases'][0]['write_contract'],r)

    def test_real_generators_reject_missing_output_with_positive_input_unchanged(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        generator=FactorPackageSQLGenerator(self.registry)
        for fid in ('insert','update'):
            factor=self.registry.factors[fid]
            value=next(v for c in factor.dimensions['returning_clause'].classes for v in c.values
                       if v.id==fid+'_returning_expression')
            original=value.render
            manifest=self.registry.manifests['manifest_'+fid+'_declared_default_positive'].model_copy(deep=True)
            manifest.bindings['returning_clause']=[value.id]
            try:
                value.render=' RETURNING missing_output_column'
                with self.assertRaisesRegex(GenerationValidationError,'missing_column'):
                    generator.generate_with_report(manifest)
            finally:
                value.render=original
            cases,report=generator.generate_with_report(manifest)
            self.assertTrue(cases)
            self.assertTrue(report.pairwise_complete)
            self.assertTrue(all(inspect_write(c.sql,c.setup_sqls)['status']=='checked' for c in cases))


if __name__=='__main__': unittest.main()
