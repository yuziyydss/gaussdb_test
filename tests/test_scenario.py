"""单元测试：验证 Scenario Pipeline 场景链与时序状态机。"""
import os
import unittest

from core.registry import FactorRegistry
from core.symbol_table import SchemaContext
from core.scenario import ScenarioDef, ScenarioStepDef, ScenarioEngine


class TestScenarioEngine(unittest.TestCase):

    def setUp(self):
        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        factors_dir = os.path.join(base_dir, "factors")
        self.registry = FactorRegistry(factors_dir)
        self.registry.load()
        self.engine = ScenarioEngine(self.registry)

    def test_full_lifecycle_scenario_generation(self):
        # 定义一个完整业务链路场景: [建表] -> [插入数据] -> [查询数据] -> [修改表结构]
        scenario = ScenarioDef(
            id="sc_table_lifecycle",
            name="表全生命周期业务场景",
            description="测试建表、数据插入、查询及加列全流程状态迁移",
            steps=[
                ScenarioStepDef(
                    step_name="01_create",
                    factor_id="create_table",
                    strategy="equivalence",
                    params_override={"table_name": "t_order_flow"},
                ),
                ScenarioStepDef(
                    step_name="02_insert",
                    factor_id="insert_values",
                    strategy="equivalence",
                    bind_from_context=True,
                ),
                ScenarioStepDef(
                    step_name="03_select",
                    factor_id="select_basic",
                    strategy="equivalence",
                    bind_from_context=True,
                ),
                ScenarioStepDef(
                    step_name="04_alter",
                    factor_id="alter_table",
                    strategy="equivalence",
                    params_override={"action": "ADD COLUMN col_new VARCHAR(50)"},
                    bind_from_context=True,
                ),
            ]
        )

        cases = self.engine.generate_scenario(scenario)
        self.assertEqual(len(cases), 1)

        case = cases[0]
        self.assertEqual(len(case.step_cases), 4)

        # 检查各步骤 SQL 是否成功绑定上下文中的表名
        sqls = case.all_sqls
        self.assertIn("t_order_flow", sqls[0])
        self.assertIn("t_order_flow", sqls[1])
        self.assertIn("t_order_flow", sqls[2])
        self.assertIn("t_order_flow", sqls[3])

        # 检查最终 SchemaContext 状态
        final_ctx = case.final_context
        self.assertTrue(final_ctx.has_table("t_order_flow"))
        tbl = final_ctx.get_table("t_order_flow")
        self.assertEqual(tbl.row_count_estimate, 1)
        self.assertIn("col_new", tbl.column_names())


if __name__ == "__main__":
    unittest.main()
