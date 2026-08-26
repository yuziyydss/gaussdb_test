"""单元测试：验证 TLP 蜕变测试 Oracle 与 CSP 约束求解器。"""
import unittest

from core.oracle import TLPOracle, TLPQueryGroup, MetamorphicExecutor
from core.constraint_solver import ConstraintRule, ConstraintSolver
from core.factor_model import FactorDef, ParamDef, EquivalenceClass
from core.generator import generate_cases


class TestOracleAndCSP(unittest.TestCase):

    def test_tlp_query_group_generation(self):
        sql = "SELECT col_1 FROM t_orders WHERE col_1 > 100 ORDER BY col_1 ASC"
        group = TLPOracle.generate_tlp_group(sql)

        self.assertIsNotNone(group)
        self.assertEqual(group.table_name, "t_orders")
        self.assertEqual(group.predicate, "col_1 > 100")
        self.assertEqual(group.q_all, "SELECT count(*) FROM t_orders")
        self.assertEqual(group.q_orig, "SELECT count(*) FROM t_orders WHERE col_1 > 100")
        self.assertEqual(group.q_true, "SELECT count(*) FROM t_orders WHERE (col_1 > 100) IS TRUE")
        self.assertEqual(group.q_false, "SELECT count(*) FROM t_orders WHERE (col_1 > 100) IS FALSE")
        self.assertEqual(group.q_null, "SELECT count(*) FROM t_orders WHERE (col_1 > 100) IS NULL")

    def test_tlp_count_verification_assertions(self):
        # 1. 正常情况: count_all=100, true=40, false=50, null=10, orig=40
        ok, msg = TLPOracle.verify_tlp_counts(
            count_all=100, count_orig=40, count_true=40, count_false=50, count_null=10
        )
        self.assertTrue(ok)

        # 2. 完备性违背: 分区总和 != count_all
        bad1, msg1 = TLPOracle.verify_tlp_counts(
            count_all=100, count_orig=40, count_true=40, count_false=50, count_null=5
        )
        self.assertFalse(bad1)
        self.assertIn("完备性违背", msg1)

        # 3. 谓词真值违背: orig != true
        bad2, msg2 = TLPOracle.verify_tlp_counts(
            count_all=100, count_orig=30, count_true=40, count_false=50, count_null=10
        )
        self.assertFalse(bad2)
        self.assertIn("谓词真值违背", msg2)

    def test_csp_constraint_rule_evaluation(self):
        # 规则 1: 临时表不能用列存
        rule1 = ConstraintRule("table_modifier == 'TEMPORARY' => storage_engine != 'CSTORE'")
        self.assertTrue(rule1.evaluate({"table_modifier": "TEMPORARY", "storage_engine": "USTORE"}))
        self.assertTrue(rule1.evaluate({"table_modifier": "", "storage_engine": "CSTORE"}))
        self.assertFalse(rule1.evaluate({"table_modifier": "TEMPORARY", "storage_engine": "CSTORE"}))

        # 规则 2: in 表达式
        rule2 = ConstraintRule("table_modifier in ['TEMPORARY', 'TEMP'] => table_option != 'TABLESPACE pg_default'")
        self.assertFalse(rule2.evaluate({"table_modifier": "TEMP", "table_option": "TABLESPACE pg_default"}))
        self.assertTrue(rule2.evaluate({"table_modifier": "TEMP", "table_option": ""}))

        # 规则 3: 点分嵌套变量 (如 fixture.col_type)
        rule3 = ConstraintRule("fixture.storage_engine == 'CSTORE' => table.constraint != 'PRIMARY KEY'")
        self.assertFalse(rule3.evaluate({"fixture.storage_engine": "CSTORE", "table.constraint": "PRIMARY KEY"}))
        self.assertTrue(rule3.evaluate({"fixture.storage_engine": "USTORE", "table.constraint": "PRIMARY KEY"}))

    def test_tlp_schema_qualified_and_complex_clauses(self):
        sql = 'SELECT * FROM public."t_orders" WHERE amount > 1000.5 GROUP BY id HAVING count(*) > 1 ORDER BY id DESC LIMIT 5;'
        group = TLPOracle.generate_tlp_group(sql)
        self.assertIsNotNone(group)
        self.assertEqual(group.table_name, 'public."t_orders"')
        self.assertEqual(group.predicate, 'amount > 1000.5')
        param_mod = ParamDef(
            classes=[
                EquivalenceClass(name="normal", values=[""]),
                EquivalenceClass(name="temp", values=["TEMPORARY"]),
            ]
        )
        param_opt = ParamDef(
            classes=[
                EquivalenceClass(name="none", values=[""]),
                EquivalenceClass(name="tbs", values=["TABLESPACE pg_default"]),
            ]
        )
        factor = FactorDef(
            id="test_fac_csp",
            name="Test Fac CSP",
            template="CREATE {table_modifier} TABLE t () {table_option}",
            params={"table_modifier": param_mod, "table_option": param_opt},
            constraints=[
                "table_modifier == 'TEMPORARY' => table_option != 'TABLESPACE pg_default'"
            ]
        )

        cases = generate_cases(factor, strategy="full_cartesian")
        # 原始笛卡尔积是 2 x 2 = 4 条，经过 CSP 过滤后应该是 3 条 (TEMPORARY + TABLESPACE 被剪枝)
        self.assertEqual(len(cases), 3)
        for c in cases:
            self.assertFalse(c.params.get("table_modifier") == "TEMPORARY" and c.params.get("table_option") == "TABLESPACE pg_default")


if __name__ == "__main__":
    unittest.main()
