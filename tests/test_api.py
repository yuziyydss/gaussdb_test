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
        self.assertIn("把产品文档变成", response.text)
        self.assertIn("本地 PDF 是唯一产品事实源", response.text)
        self.assertNotIn("Legacy V0", response.text)

    def test_default_coverage_uses_pdf_factor_packages_not_legacy_meter(self):
        response = self.client.get("/coverage")
        self.assertEqual(response.status_code, 200)
        self.assertIn("PDF 证据与测试因子覆盖", response.text)
        self.assertIn("静态 SQL 候选，不是实机通过记录", response.text)

        payload = self.client.get("/api/coverage/summary").json()
        self.assertEqual(payload["factor_count"], len(payload["factors"]))
        self.assertGreaterEqual(payload["factor_count"], 5)
        self.assertEqual(
            payload["manifest_count"],
            sum(
                audit["manifests"]["total"]
                for audit in payload["factors"].values()
            ),
        )
        self.assertEqual(
            payload["generated_case_count"],
            sum(
                audit["manifests"]["generated_case_count"]
                for audit in payload["factors"].values()
            ),
        )
        self.assertGreater(payload["generated_case_count"], 0)
        progress = payload['progress']
        self.assertEqual(progress['with_candidates_count'], sum(
            a['manifests']['generated_case_count'] > 0 for a in payload['factors'].values()))
        self.assertEqual(progress['static_covered_count'], sum(
            a['display_progress']['static_status'] == 'covered' for a in payload['factors'].values()))
        self.assertIsNone(progress['runtime_verified_count'])
        self.assertEqual(payload['factors']['alter_language']['display_progress']['static_status'], 'no_cases')
        self.assertNotIn('五章校准包', response.text)
        self.assertIn('无用例，不计通过', response.text)
        self.assertIn('未接入证据', response.text)
        self.assertEqual(payload["catalog"]["cataloged"], 224)
        self.assertEqual(payload["catalog"]["extracted"], payload["factor_count"])
        self.assertEqual(payload["catalog"]["package_bound"], payload["factor_count"])
        self.assertEqual(
            payload["static_complete_count"],
            sum(audit["conclusions"]["static_coverage_complete"] for audit in payload["factors"].values()),
        )
        # New simple chapters may close statically without any DB execution.
        rollback = payload["factors"]["rollback"]["conclusions"]
        self.assertTrue(rollback["static_coverage_complete"])
        self.assertFalse(rollback["behavior_coverage_complete"])

    def test_progress_export_and_zero_case_detail_do_not_claim_completion(self):
        response = self.client.get('/api/coverage/export-md')
        self.assertEqual(response.status_code, 200)
        self.assertIn('全部因子包：四阶段进度', response.text)
        row = next(line for line in response.text.splitlines() if line.startswith('| alter_language |'))
        self.assertIn('无候选', row)
        self.assertIn('无用例，不计通过', row)
        self.assertIn('未接入证据', row)
        detail = self.client.get('/specs/factor/alter_language')
        self.assertEqual(detail.status_code, 200)
        self.assertIn('无用例，不计通过', detail.text)
        self.assertNotIn('闭环完成', detail.text)
        self.assertNotIn('全部 100%', detail.text)

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
        self.assertIn("PDF-first Factor Packages", index.text)
        self.assertIn("CREATE VIEW", index.text)

        detail = self.client.get("/specs/factor/create_view")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("待验证问题", detail.text)
        self.assertIn("cv_open_security_barrier_bare", detail.text)
        self.assertIn("原文覆盖账本", detail.text)
        self.assertIn("116 / 116", detail.text)
        self.assertIn("406 / 406 行已登记", detail.text)
        self.assertIn("有候选（非全域覆盖）", detail.text)

        audit_api = self.client.get("/api/specs/v1/audit/create_view")
        self.assertEqual(audit_api.status_code, 200)
        audit = audit_api.json()
        self.assertEqual(audit["source_units"]["accounted"], 116)
        self.assertEqual(audit["source_units"]["total"], 116)
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
        self.assertIn("918 / 918 行已登记", detail.text)
        self.assertIn("有候选（非全域覆盖）", detail.text)
        self.assertIn("有缺口", detail.text)
        self.assertIn("insert_open_plan_hint_profile", detail.text)

        manifest_id = "manifest_insert_core_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("INSERT INTO", generated_html.text)
        self.assertIn("110", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 24)
        self.assertEqual(payload["report"]["covered_pair_count"], 110)
        self.assertEqual(payload["report"]["feasible_pair_count"], 110)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["setup_sqls"] for case in payload["cases"]))

    def test_select_factor_is_pdf_bound_and_generates_from_web_api(self):
        detail = self.client.get("/specs/factor/select")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("2333 / 2333 行已登记", detail.text)
        self.assertIn("有候选（非全域覆盖）", detail.text)
        self.assertIn("select_open_plan_hint_profile", detail.text)

        manifest_id = "manifest_select_core_positive"
        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 42)
        self.assertEqual(payload["report"]["covered_pair_count"], 679)
        self.assertEqual(payload["report"]["feasible_pair_count"], 679)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["sql"].endswith(";") for case in payload["cases"]))

    def test_create_index_factor_is_visible_and_generates_from_web_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("CREATE INDEX", index.text)

        detail = self.client.get("/specs/factor/create_index")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("899 / 899 行已登记", detail.text)
        self.assertIn("有候选（非全域覆盖）", detail.text)
        self.assertIn("有缺口", detail.text)
        self.assertIn("ci_open_unique_local_missing_partition_key", detail.text)

        manifest_id = "manifest_create_index_regular_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("CREATE", generated_html.text)
        self.assertIn("INDEX", generated_html.text)
        self.assertIn("708", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 229)
        self.assertEqual(payload["report"]["covered_pair_count"], 708)
        self.assertEqual(payload["report"]["feasible_pair_count"], 708)
        self.assertTrue(payload["report"]["pairwise_complete"])
        self.assertTrue(all(case["setup_sqls"] for case in payload["cases"]))

    def test_alter_table_factor_is_visible_and_generates_from_web_api(self):
        index = self.client.get("/")
        self.assertEqual(index.status_code, 200)
        self.assertIn("ALTER TABLE", index.text)

        detail = self.client.get("/specs/factor/alter_table")
        self.assertEqual(detail.status_code, 200)
        self.assertIn("1636 / 1636 行已登记", detail.text)
        self.assertIn("有候选（非全域覆盖）", detail.text)
        self.assertIn("有缺口", detail.text)
        self.assertIn("at_open_online_environment_fixture", detail.text)

        manifest_id = "manifest_alter_table_core_positive"
        generated_html = self.client.post(
            "/specs/manifest/generate", data={"manifest_id": manifest_id}
        )
        self.assertEqual(generated_html.status_code, 200)
        self.assertIn("ALTER TABLE", generated_html.text)
        self.assertIn("741", generated_html.text)

        generated_api = self.client.get(f"/api/specs/v1/generate/{manifest_id}")
        self.assertEqual(generated_api.status_code, 200)
        payload = generated_api.json()
        self.assertEqual(payload["count"], 188)
        self.assertEqual(payload["report"]["covered_pair_count"], 741)
        self.assertEqual(payload["report"]["feasible_pair_count"], 741)
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
