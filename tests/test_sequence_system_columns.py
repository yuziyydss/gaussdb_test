"""Actual system-column prerequisites, without claiming target errors executed."""
from pathlib import Path
import copy
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]


class SequenceSystemColumnTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def manifest(self,column):
        mid='manifest_create_sequence_system_'+column+'_a_negative'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.r.manifests[mid]

    def test_two_real_system_targets_keep_oracle_and_runtime_gaps(self):
        for column in ('rowid','rowno'):
            cases,report=self.g.generate_with_report(self.manifest(column))
            self.assertEqual(len(cases),1)
            c=cases[0]
            self.assertIn(' OWNED BY g_a3_cs_system_owner.'+column,c.sql)
            self.assertEqual(c.setup_sqls,['CREATE TABLE g_a3_cs_system_owner (id INTEGER) WITH (hasrowid = on);'])
            self.assertEqual(c.expected,'error')
            self.assertEqual(c.expected_oracle_status,'needs_verification')
            self.assertEqual(c.expected_sqlstates,[])
            self.assertEqual(c.expected_error_category,'system_column_ownership_forbidden')
            self.assertFalse(report.missing_pairs)
        fixture=self.r.fixtures['fixture_create_sequence_system_owner']
        self.assertEqual([c.name for c in fixture.provides.tables[0].columns],['id'])

    def test_wrong_user_column_setup_is_rejected_even_if_provides_claims_table(self):
        m=self.manifest('rowid')
        original=self.g._compile_fixture_lifecycle
        for mutate in [lambda s:[s[0].replace('id INTEGER','id INTEGER, rowid INTEGER')],
                       lambda s:[s[0].replace('hasrowid = on','hasrowid = off')],
                       lambda s:s+['SELECT 1;']]:
            with patch.object(self.g,'_compile_fixture_lifecycle',side_effect=lambda refs:(mutate(original(refs)[0]),original(refs)[1])):
                with self.assertRaisesRegex(GenerationValidationError,'system_column_contract'):
                    self.g.generate_with_report(m)

    def test_missing_mode_or_claimed_calibrated_error_is_rejected(self):
        for change in ('mode','oracle'):
            m=self.manifest('rowno').model_copy(deep=True)
            if change=='mode':
                m.environment_requirements=[]
            else:
                m.expected.oracle_status='confirmed'
            with self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(m)

    def test_removed_boolean_marker_cannot_disable_finite_target_guard(self):
        m=self.manifest('rowid')
        resolve=self.r.resolve_dimension_values
        lifecycle=self.g._compile_fixture_lifecycle
        def unmarked(fid):
            values=copy.deepcopy(resolve(fid))
            values['owned_by_clause']['cs_owned_rowid_a_invalid'].attributes['owned_by_clause.properties.system_column']=False
            return values
        def no_system_columns(refs):
            setup,cleanup=lifecycle(refs)
            return [s.replace('hasrowid = on','hasrowid = off') for s in setup],cleanup
        with patch.object(self.r,'resolve_dimension_values',side_effect=unmarked),patch.object(self.g,'_compile_fixture_lifecycle',side_effect=no_system_columns):
            with self.assertRaisesRegex(GenerationValidationError,'system_column_contract'):
                self.g.generate_with_report(m)
