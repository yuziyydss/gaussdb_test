"""单元测试：验证 FastAPI Web 与 API 路由。"""
import unittest

try:
    from fastapi.testclient import TestClient
    from main import app, executor
    HAS_FASTAPI = True
except ImportError:
    HAS_FASTAPI = False


class TestApiRoutes(unittest.TestCase):

    def setUp(self):
        if not HAS_FASTAPI:
            self.skipTest("fastapi 或 httpx 依赖未安装，跳过 API 集成测试")
        self.client = TestClient(app)

    def test_index_page(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn("GaussDB 测试因子库", response.text)
        self.assertIn("表全生命周期场景", response.text)

    def test_factor_detail_and_generate(self):
        # 因子详情
        r1 = self.client.get("/factor/create_table")
        self.assertEqual(r1.status_code, 200)

        # 生成用例
        r2 = self.client.post("/generate", data={"factor_id": "create_table", "strategy": "pairwise"})
        self.assertEqual(r2.status_code, 200)
        self.assertIn("CREATE", r2.text)

    def test_scenarios_views_and_api(self):
        # 场景链可视化片段
        r1 = self.client.get("/scenarios")
        self.assertEqual(r1.status_code, 200)
        self.assertIn("表全生命周期业务场景", r1.text)

        # 场景链执行
        r2 = self.client.post("/scenarios/execute", data={"scenario_id": "sc_order_lifecycle"})
        self.assertEqual(r2.status_code, 200)
        self.assertIn("时序状态机执行记录", r2.text)
        self.assertIn("SchemaContext", r2.text)

        # JSON API
        r3 = self.client.get("/api/scenarios/generate_default")
        self.assertEqual(r3.status_code, 200)
        data = r3.json()
        self.assertEqual(data["scenario_id"], "sc_order_lifecycle")
        self.assertGreater(len(data["cases"]), 0)

    def test_db_config_modal_and_save(self):
        # 打开弹窗
        r1 = self.client.get("/api/db-config-modal")
        self.assertEqual(r1.status_code, 200)
        self.assertIn("GaussDB 数据库连接配置", r1.text)

        # 保存配置
        r2 = self.client.post("/api/db-config", data={
            "host": "127.0.0.1",
            "port": "5432",
            "database": "postgres",
            "user": "gaussdb",
            "password": "pwd",
            "enabled": "",
            "use_sandbox": "true"
        })
        self.assertEqual(r2.status_code, 200)
        self.assertEqual(executor.config.host, "127.0.0.1")
        self.assertFalse(executor.config.enabled)
        self.assertTrue(executor.config.use_sandbox)


if __name__ == "__main__":
    unittest.main()
