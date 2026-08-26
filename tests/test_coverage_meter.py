"""单元测试：验证 SpecCoverageMeter 与 Gap Report 缺口分析器。"""
import os
import unittest

from core.spec_model import SpecRegistry
from core.coverage_meter import SpecCoverageMeter, SpecCoverageReport


class TestCoverageMeter(unittest.TestCase):

    def setUp(self):
        self.base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.registry = SpecRegistry(self.base_dir)
        self.registry.load_all()
        self.meter = SpecCoverageMeter(self.registry)

    def test_compute_coverage_metrics(self):
        report = self.meter.compute_coverage()

        self.assertIsInstance(report, SpecCoverageReport)
        self.assertGreater(report.total_slot_values, 0)
        self.assertGreater(report.covered_slot_values, 0)
        self.assertGreater(report.syntax_coverage_pct, 0.0)
        self.assertGreaterEqual(report.type_coverage_pct, 0.0)
        self.assertGreater(report.overall_spec_coverage_pct, 0.0)

        # 检查是否有详细分项
        self.assertIn("syntax_create_table", report.syntax_details)
        self.assertIn("syntax_select", report.syntax_details)
        self.assertIn("matrix_gaussdb_core", report.matrix_details)

    def test_markdown_gap_report_generation(self):
        report = self.meter.compute_coverage()
        md = report.generate_markdown_gap_report()

        self.assertIn("# GaussDB 文档特性覆盖率与测试缺口报告", md)
        self.assertIn("覆盖率核心指标总览", md)
        self.assertIn("文档特性未覆盖缺口清单", md)
        self.assertIn("语法规范分项覆盖明细", md)

    def test_coverage_to_dict_summary(self):
        report = self.meter.compute_coverage()
        data = report.to_dict()

        self.assertIn("overall_spec_coverage_pct", data)
        self.assertIn("summary", data)
        self.assertIn("gaps", data)
        self.assertIsInstance(data["gaps"], list)


if __name__ == "__main__":
    unittest.main()
