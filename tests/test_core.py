"""自动化单元测试：验证因子加载、组合算法、多 SQLSTATE 容错与沙箱执行器。"""
import os
import unittest

from core.factor_model import EquivalenceClass, ParamDef, FactorDef
from core.generator import generate_cases, GeneratedCase
from core.executor import Executor, ExecConfig, ExecResult
from core.registry import FactorRegistry
from core.reporter import generate_report


class TestFactorCore(unittest.TestCase):

    def test_equivalence_class_sqlstates_normalization(self):
        # 1. 只有单个 expected_sqlstate
        ec1 = EquivalenceClass(name="c1", values=["val1"], expected="error", expected_sqlstate="22P02")
        self.assertEqual(ec1.expected_sqlstates, ["22P02"])

        # 2. 只有 expected_sqlstates 列表
        ec2 = EquivalenceClass(name="c2", values=["val2"], expected="error", expected_sqlstates=["22P02", "42804"])
        self.assertEqual(ec2.expected_sqlstate, "22P02")
        self.assertEqual(ec2.expected_sqlstates, ["22P02", "42804"])

        # 3. 正常 success
        ec3 = EquivalenceClass(name="c3", values=["val3"], expected="success")
        self.assertEqual(ec3.expected_sqlstates, [])

    def test_factor_merge_expected_multi_sqlstates(self):
        param1 = ParamDef(
            classes=[
                EquivalenceClass(name="p1_err", values=["bad1"], expected="error", expected_sqlstates=["42704", "42601"]),
                EquivalenceClass(name="p1_ok", values=["good1"], expected="success"),
            ]
        )
        param2 = ParamDef(
            classes=[
                EquivalenceClass(name="p2_err", values=["bad2"], expected="error", expected_sqlstates=["22P02"]),
                EquivalenceClass(name="p2_ok", values=["good2"], expected="success"),
            ]
        )
        factor = FactorDef(
            id="test_fac",
            name="Test Factor",
            template="SELECT {p1}, {p2}",
            params={"p1": param1, "p2": param2},
        )

        # 两个都 ok
        exp, ss = factor.merge_expected({"p1": "good1", "p2": "good2"})
        self.assertEqual(exp, "success")
        self.assertEqual(ss, [])

        # 一个 error
        exp, ss = factor.merge_expected({"p1": "bad1", "p2": "good2"})
        self.assertEqual(exp, "error")
        self.assertEqual(set(ss), {"42704", "42601"})

        # 两个都 error
        exp, ss = factor.merge_expected({"p1": "bad1", "p2": "bad2"})
        self.assertEqual(exp, "error")
        self.assertEqual(set(ss), {"42704", "42601", "22P02"})

    def test_executor_verdict_multi_sqlstate_matching(self):
        # 命中候选集中的任意一个 -> PASS
        r1 = ExecResult(
            case_id="c1",
            sql="SELECT 1",
            status="error",
            expected="error",
            expected_sqlstates=["22P02", "42804"],
            actual_sqlstate="42804",
        )
        r1.compute_verdict()
        self.assertEqual(r1.verdict, "pass")

        # 未命中候选集 -> FAIL
        r2 = ExecResult(
            case_id="c2",
            sql="SELECT 1",
            status="error",
            expected="error",
            expected_sqlstates=["22P02", "42804"],
            actual_sqlstate="58000",
        )
        r2.compute_verdict()
        self.assertEqual(r2.verdict, "fail")

        # 兼容旧版单一 expected_sqlstate
        r3 = ExecResult(
            case_id="c3",
            sql="SELECT 1",
            status="error",
            expected="error",
            expected_sqlstate="23502",
            actual_sqlstate="23502",
        )
        r3.compute_verdict()
        self.assertEqual(r3.verdict, "pass")

        # 负向用例不能再以“任意报错”通过：必须命中 SQLSTATE 或目标消息 Oracle。
        no_oracle = ExecResult(
            case_id="c4",
            sql="SELECT bad",
            status="error",
            expected="error",
            error_msg="unrelated failure",
        )
        no_oracle.compute_verdict()
        self.assertEqual(no_oracle.verdict, "fail")

        regex_match = ExecResult(
            case_id="c5",
            sql="SELECT DISTINCT col_1 ORDER BY col_2",
            status="error",
            expected="error",
            expected_error_category="distinct_order_expression_not_selected",
            expected_error_regex=r"(?i)(distinct|select list)",
            error_msg="ORDER BY expressions must appear in select list for SELECT DISTINCT",
        )
        regex_match.compute_verdict()
        self.assertEqual(regex_match.verdict, "pass")

        wrong_error = ExecResult(
            case_id="c6",
            sql="SELECT DISTINCT col_1 ORDER BY col_2",
            status="error",
            expected="error",
            expected_error_category="distinct_order_expression_not_selected",
            expected_error_regex=r"(?i)(distinct|select list)",
            error_msg="relation does not exist",
        )
        wrong_error.compute_verdict()
        self.assertEqual(wrong_error.verdict, "fail")

        fixture_error = ExecResult(
            case_id="c7",
            sql="SELECT 1",
            status="fixture_error",
            expected="error",
            expected_error_regex=".*",
        )
        fixture_error.compute_verdict()
        self.assertEqual(fixture_error.verdict, "fail")

    def test_yaml_factors_loading_and_generation(self):
        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        factors_dir = os.path.join(base_dir, "factors")
        registry = FactorRegistry(factors_dir)
        factors = registry.load()

        self.assertIn("create_table", factors)
        self.assertIn("insert_values", factors)

        # 生成 create_table 用例
        ct_cases = generate_cases(factors["create_table"], strategy="pairwise", registry=registry)
        self.assertGreater(len(ct_cases), 0)

        # 生成 insert_values 用例 (含 matrix 跨表类型生成)
        ins_cases = generate_cases(factors["insert_values"], strategy="equivalence", registry=registry)
        self.assertGreater(len(ins_cases), 0)
        # 验证生成的用例带 expected_sqlstates
        has_multi_ss = any(len(c.expected_sqlstates) > 1 for c in ins_cases)
        self.assertTrue(has_multi_ss)

    def test_executor_runs_fixture_test_and_teardown_in_order(self):
        statements = []

        class RecordingCursor:
            def execute(self, sql):
                statements.append(sql)

            def close(self):
                pass

        class RecordingConnection:
            def cursor(self):
                return RecordingCursor()

        executor = Executor(ExecConfig(enabled=True, use_sandbox=False))
        executor._conn = RecordingConnection()
        executor._check_alive = lambda: True
        case = GeneratedCase(
            factor_id="fixture_test",
            case_id="fixture_test_1",
            strategy="pairwise",
            params={},
            sql="SELECT col_1 FROM t_fixture;",
            setup_sqls=[
                "CREATE TABLE t_fixture (col_1 INTEGER);",
                "INSERT INTO t_fixture VALUES (1);",
            ],
            teardown_sqls=["DROP TABLE IF EXISTS t_fixture;"],
        )
        result = executor.execute_one(case)
        self.assertEqual(result.verdict, "pass")
        self.assertEqual(statements, [
            "CREATE TABLE t_fixture (col_1 INTEGER);",
            "INSERT INTO t_fixture VALUES (1);",
            "SELECT col_1 FROM t_fixture;",
            "DROP TABLE IF EXISTS t_fixture;",
        ])

    def test_executor_fixture_failure_cannot_satisfy_negative_case(self):
        statements = []

        class FailingCursor:
            def execute(self, sql):
                statements.append(sql)
                if sql.startswith("CREATE TABLE"):
                    raise RuntimeError("fixture relation creation failed")

            def close(self):
                pass

        class FailingConnection:
            def cursor(self):
                return FailingCursor()

        executor = Executor(ExecConfig(enabled=True, use_sandbox=False))
        executor._conn = FailingConnection()
        executor._check_alive = lambda: True
        case = GeneratedCase(
            factor_id="fixture_test",
            case_id="fixture_test_negative",
            strategy="pairwise",
            params={},
            sql="SELECT invalid_syntax;",
            expected="error",
            expected_error_category="target_syntax_error",
            expected_error_regex="syntax",
            setup_sqls=["CREATE TABLE t_fixture (col_1 INTEGER);"],
            teardown_sqls=["DROP TABLE IF EXISTS t_fixture;"],
        )
        result = executor.execute_one(case)
        self.assertEqual(result.status, "fixture_error")
        self.assertEqual(result.verdict, "fail")
        self.assertNotIn(case.sql, statements)
        self.assertIn("DROP TABLE IF EXISTS t_fixture;", statements)

    def test_reporter_and_exec_batch_mock(self):
        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        factors_dir = os.path.join(base_dir, "factors")
        reports_dir = os.path.join(base_dir, "reports")
        registry = FactorRegistry(factors_dir)
        registry.load()

        factor = registry.get("create_table")
        cases = generate_cases(factor, strategy="pairwise", registry=registry)
        executor = Executor(ExecConfig(enabled=False))
        results = executor.execute_batch(cases)
        self.assertEqual(len(results), len(cases))

        html_path = generate_report(cases, results, factor.name, "pairwise", reports_dir)
        self.assertTrue(os.path.exists(html_path))


if __name__ == "__main__":
    unittest.main()
