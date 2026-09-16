"""Expose existing type proof without laundering it into complete write proof."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT = Path(__file__).resolve().parents[1]


class CommonTypeEvidenceAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        g = FactorPackageSQLGenerator(cls.r)
        cls.report = {'manifests': {}}
        for mid in ('manifest_insert_common_type_pg', 'manifest_insert_common_type_a_integer'):
            cases, _ = g.generate_with_report(cls.r.manifests[mid])
            cls.report['manifests'][mid] = {'cases': [c.to_dict() for c in cases]}

    def audit(self, report=None):
        from scripts.audit_common_type_evidence import audit_report
        return audit_report(self.report if report is None else report, self.r)

    def test_four_cases_keep_partial_write_scope_and_current_type_evidence(self):
        before = copy.deepcopy(self.report)
        result = self.audit()
        self.assertEqual(self.report, before)
        self.assertEqual(result['summary']['type_status'], {'checked_types': 4})
        for row in result['cases']:
            self.assertEqual(row['finite_write_status'], 'needs_review')
            self.assertFalse(row['full_write_proven'])
            self.assertFalse(row['runtime_proven'])
            self.assertTrue(row['type_evidence'][0]['exact_assignment_types'])

    def test_changed_sql_setup_mode_or_identity_cannot_reuse_old_proof(self):
        for field, value in (
            ('sql', 'INSERT INTO missing VALUES (1);'),
            ('setup_sqls', ['CREATE TABLE g_common_target(result TEXT)']),
            ('environment_requirements', []),
            ('case_id', 'forged'),
            ('consumed_dimension_ids', []),
        ):
            report = copy.deepcopy(self.report)
            case = next(iter(report['manifests'].values()))['cases'][0]
            case[field] = value
            with self.subTest(field=field):
                row = self.audit(report)['cases'][0]
                self.assertEqual(row['type_status'], 'needs_review')
                self.assertEqual(row['type_evidence'], [])

    def test_duplicate_ids_are_an_error_not_extra_coverage(self):
        report = copy.deepcopy(self.report)
        cases = next(iter(report['manifests'].values()))['cases']
        cases[1]['case_id'] = cases[0]['case_id']
        with self.assertRaisesRegex(ValueError, 'Duplicate'):
            self.audit(report)
