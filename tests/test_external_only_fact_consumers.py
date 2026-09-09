"""A real cross-package gate counts; export/ledger bookkeeping alone does not."""
import copy
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry, FactorPackageLoadError
from core.factor_coverage_auditor import FactorCoverageAuditor


class ExternalOnlyFactConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.load_error = None
        try:
            cls.registry.load_all()
        except FactorPackageLoadError as exc:
            # Keep parsed entities for negative probes even on the initial RED run.
            cls.load_error = str(exc)

    def test_export_consumed_only_by_external_gate_loads_and_audits(self):
        self.assertIsNone(self.load_error)
        audit = FactorCoverageAuditor(self.registry).audit('m_create_index')
        fact = 'm_create_index_fact_authority'
        self.assertNotIn(fact, audit['facts']['unconsumed_confirmed'])
        self.assertIn('m_prepare:environment_gate', audit['facts']['external_consumers'][fact])

    def probe(self, mutate):
        registry = copy.deepcopy(self.registry)
        mutate(registry)
        errors = []
        registry._validate_references(errors)
        return '\n'.join(errors)

    def test_export_without_actual_consumer_still_fails(self):
        def mutate(registry):
            manifest = registry.manifests['manifest_m_prepare_create_index']
            manifest.environment_requirements = [g for g in manifest.environment_requirements
                                                if g.key not in ('ddl_authority','namespace_scope')]
        errors = self.probe(mutate)
        self.assertIn("confirmed facts 没有规格消费者: ['m_create_index_fact_authority']", errors)

    def test_unexported_fact_cannot_be_consumed(self):
        errors = self.probe(lambda r: r.factors['m_create_index'].exported_fact_refs.remove(
            'm_create_index_fact_authority'))
        self.assertIn("不存在的 fact 'm_create_index::m_create_index_fact_authority'", errors)
        self.assertIn("confirmed facts 没有规格消费者: ['m_create_index_fact_authority']", errors)

    def test_wrong_cross_consumer_type_still_fails(self):
        def mutate(registry):
            manifest = registry.manifests['manifest_m_prepare_create_index']
            manifest.environment_requirements = [g for g in manifest.environment_requirements
                                                if g.key not in ('ddl_authority','namespace_scope')]
            registry.syntaxes['syntax_m_prepare'].source_fact_refs.append(
                'm_create_index::m_create_index_fact_authority')
        errors = self.probe(mutate)
        self.assertIn("type='environment' 不能由 syntax 消费", errors)
        self.assertIn("confirmed facts 没有规格消费者: ['m_create_index_fact_authority']", errors)


if __name__ == '__main__':
    unittest.main()
