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

    def test_factor_package_v1_pages_and_generation_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("Factor Packages V1", index.text)
        self.assertIn("CREATE VIEW", index.text)

        detail = self.client.get("/specs/factor/create_view")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("待验证问题", detail.text)
        self.assertIn("cv_open_security_barrier_bare", detail.text)
        self.assertIn("原文覆盖账本", detail.text)
        self.assertIn("64 / 64", detail.text)
        self.assertIn("71 / 71 行已登记", detail.text)
        self.assertIn("生成模型：完整", detail.text)

        audit_api = self.client.get("/api/specs/v1/audit/create_view")
        self.assertEqual(audit_api.status_code, 200)
        audit = audit_api.json()
        self.assertEqual(audit["source_units"]["accounted"], 64)
        self.assertEqual(audit["source_units"]["total"], 64)
        self.assertEqual(audit["source_units"]["line_coverage"]["missing"], [])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

        manifest_id = "manifest_create_view_basic_positive"
        manifest_page = self.client.get(f"/specs/manifest/{manifest_id}")
        self.assertEqual(manifest_page.status_code, 200)
        self.assertIn("Bindings 使用稳定值 ID", manifest_page.text)

        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("可行 Pair", generated_html.text)
        self.assertIn("146", generated_html.text)
        self.assertNotIn("执行并生成报告", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 18)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertEqual(payload["report"]["missing_pairs"], [])
        self.assertTrue(all(case["sql"].endswith(";") for case in payload["cases"]))

    def test_insert_factor_is_visible_and_generates_from_web_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("INSERT", index.text)

        detail = self.client.get("/specs/factor/insert")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("276 / 276 行已登记", detail.text)
        self.assertIn("生成模型：完整", detail.text)
        self.assertIn("insert_open_plan_hint_profile", detail.text)

        manifest_id = "manifest_insert_core_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("INSERT INTO", generated_html.text)
        self.assertIn("101", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 21)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["setup_sqls"] for case in payload["cases"]))

    def test_create_index_factor_is_visible_and_generates_from_web_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("CREATE INDEX", index.text)

        detail = self.client.get("/specs/factor/create_index")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("164 / 164 行已登记", detail.text)
        self.assertIn("生成模型：完整", detail.text)
        self.assertIn("ci_open_partition_default_scope", detail.text)

        manifest_id = "manifest_create_index_regular_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("CREATE", generated_html.text)
        self.assertIn("INDEX", generated_html.text)
        self.assertIn("486", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 149)
        self.assertEqual(payload["report"]["covered_pair_count"], 486)
        self.assertEqual(payload["report"]["feasible_pair_count"], 486)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["setup_sqls"] for case in payload["cases"]))

    def test_alter_table_factor_is_visible_and_generates_from_web_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("ALTER TABLE", index.text)

        detail = self.client.get("/specs/factor/alter_table")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("566 / 566 行已登记", detail.text)
        self.assertIn("生成模型：完整", detail.text)
        self.assertIn("at_open_online_environment_fixture", detail.text)

        manifest_id = "manifest_alter_table_core_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("ALTER TABLE", generated_html.text)
        self.assertIn("622", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 188)
        self.assertEqual(payload["report"]["covered_pair_count"], 622)
        self.assertEqual(payload["report"]["feasible_pair_count"], 622)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["setup_sqls"] for case in payload["cases"]))

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
