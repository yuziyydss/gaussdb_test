from __future__ import annotations

import hashlib
import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

from scripts.manage_extraction_queue import (
    QueueError,
    apply_factor_dependency_graph,
    ensure_verify_writeback_safe,
    factor_package_sha256,
    find_task,
    inventory_state,
    print_summary,
    read_state,
    render_task,
    select_pending_task,
    set_task_status,
    static_completion_freshness,
    validate_state,
    validate_task_artifact,
    verify_task,
    verification_toolchain_sha256,
    write_state,
)


class ExtractionQueueTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.corpus = self.root / "corpus"
        self.specs = self.root / "specs"
        self.general_source = self.corpus / "general" / "ddl" / "create_view.txt"
        self.compat_source = self.corpus / "m_compat" / "dml" / "select.md"
        self.general_source.parent.mkdir(parents=True)
        self.compat_source.parent.mkdir(parents=True)
        self.general_source.write_text("CREATE VIEW\n语法说明\n", encoding="utf-8")
        self.compat_source.write_text("SELECT\n兼容模式说明\n", encoding="utf-8")

    def _write_source_catalog(self) -> Path:
        # A catalog-backed inventory is a closed set: sources not named by the
        # catalog are not allowed to become provenance-free tasks.
        self.compat_source.unlink(missing_ok=True)
        self.parent_pdf = self.root / "gaussdb-rf-cent.pdf"
        self.parent_pdf.write_bytes(b"%PDF-1.5\nsource document\n")
        catalog_path = self.root / "document_catalog.json"
        catalog_path.write_text(json.dumps({
            "schema_version": 1,
            "document_id": "gaussdb-centralized-reference-v10",
            "parent_pdf_path": str(self.parent_pdf),
            "parent_pdf_sha256": hashlib.sha256(
                self.parent_pdf.read_bytes()
            ).hexdigest(),
            "product_version": "V2.0-10.0.0",
            "document_version": "01 (2026-04-30)",
            "extraction_rule_version": "gaussdb-pdf-sections-v1",
            "chapters": [
                {
                    "source_relpath": "general/ddl/create_view.txt",
                    "variant": "general",
                    "category": "ddl",
                    "section_number": "1.13.9.60",
                    "title": "CREATE VIEW",
                    "outline_path": ["1 SQL 参考", "1.13 SQL语法", "1.13.9.60 CREATE VIEW"],
                    "start_destination": {
                        "physical_page": 1636,
                        "printed_page": "1587",
                        "pdf_top": 84.0,
                        "y_from_top": 84.0,
                        "coordinate_unit": "pt",
                    },
                    "end_destination": {
                        "physical_page": 1642,
                        "printed_page": "1593",
                        "pdf_top": 492.0,
                        "y_from_top": 492.0,
                        "coordinate_unit": "pt",
                        "exclusive": True,
                    },
                    "physical_page_start": 1636,
                    "physical_page_end": 1642,
                    "printed_page_start": "1587",
                    "printed_page_end": "1593",
                    "chapter_sha256": hashlib.sha256(
                        self.general_source.read_bytes()
                    ).hexdigest(),
                }
            ],
        }, ensure_ascii=False), encoding="utf-8")
        return catalog_path

    @staticmethod
    def _write_minimal_task_artifact(
        task, *, include_main_catalog_ref: bool = True
    ) -> None:
        output_dir = Path(task["output_dir"])
        output_dir.mkdir(parents=True, exist_ok=True)
        catalog_ref = ""
        if include_main_catalog_ref and task.get("chapter_sha256"):
            catalog_ref = (
                "  catalog_chapter_ref:\n"
                f"    document_id: {task['document_id']}\n"
                f"    source_relpath: {task['source_relpath']}\n"
                f"    chapter_sha256: {task['chapter_sha256']}\n"
            )
        (output_dir / "create_view.factor.yaml").write_text(
            "id: create_view\n"
            "source:\n"
            f"  version: {task['product_version']}\n"
            f"  artifact_sha256: {task['chapter_sha256']}\n"
            f"  parent_pdf_sha256: {task['parent_pdf_sha256']}\n"
            f"  extraction_rule_version: {task['extraction_rule_version']}\n"
            f"{catalog_ref}",
            encoding="utf-8",
        )
        (output_dir / "create_view.source.yaml").write_text(
            "factor_ref: create_view\n"
            f"artifact_sha256: {task['chapter_sha256']}\n"
            f"source_line_count: {task['source_line_count']}\n",
            encoding="utf-8",
        )

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_inventory_derives_isolated_factor_ids_and_round_trips(self):
        state = inventory_state(self.corpus, self.specs)
        self.assertEqual(len(state["tasks"]), 2)
        tasks = {item["task_id"]: item for item in state["tasks"]}
        self.assertEqual(
            tasks["doc2spec_general_ddl_create_view"]["factor_id"],
            "create_view",
        )
        self.assertEqual(
            tasks["doc2spec_m_compat_dml_select"]["factor_id"],
            "m_compat_select",
        )
        self.assertEqual(
            tasks["doc2spec_general_ddl_create_view"]["source_line_count"], 2
        )

        state_path = self.root / "work" / "queue.json"
        write_state(state_path, state)
        self.assertEqual(read_state(state_path), state)

    def test_inventory_preserves_unchanged_state_and_resets_changed_source(self):
        state = inventory_state(self.corpus, self.specs)
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "static_complete"
        task["attempt"] = 2

        unchanged = inventory_state(self.corpus, self.specs, state)
        unchanged_task = find_task(unchanged, task["task_id"])
        self.assertEqual(unchanged_task["status"], "static_complete")
        self.assertEqual(unchanged_task["attempt"], 2)

        self.general_source.write_text("CREATE VIEW\n更新后的说明\n", encoding="utf-8")
        changed = inventory_state(self.corpus, self.specs, unchanged)
        changed_task = find_task(changed, task["task_id"])
        self.assertEqual(changed_task["status"], "pending")
        self.assertIn("SHA-256", changed_task["message"])

    def test_pending_tasks_follow_factor_dependency_order_and_reject_cycles(self):
        state = inventory_state(self.corpus, self.specs)
        apply_factor_dependency_graph(
            state,
            {
                "create_view": {"m_compat_select"},
                "m_compat_select": set(),
            },
        )
        selected = select_pending_task(state)
        self.assertEqual(selected["factor_id"], "m_compat_select")

        apply_factor_dependency_graph(
            state,
            {
                "create_view": {"m_compat_select"},
                "m_compat_select": {"create_view"},
            },
        )
        with self.assertRaisesRegex(QueueError, "任务依赖存在环"):
            validate_state(state)

    def test_dependency_package_change_marks_only_consumer_stale(self):
        state = inventory_state(self.corpus, self.specs)
        tasks = {task["factor_id"]: task for task in state["tasks"]}
        consumer = tasks["create_view"]
        dependency = tasks["m_compat_select"]
        apply_factor_dependency_graph(
            state,
            {
                "create_view": {"m_compat_select"},
                "m_compat_select": set(),
            },
        )
        for task in (consumer, dependency):
            package_dir = Path(task["output_dir"])
            package_dir.mkdir(parents=True, exist_ok=True)
            (package_dir / f"{task['factor_id']}.factor.yaml").write_text(
                f"kind: factor\nid: {task['factor_id']}\n",
                encoding="utf-8",
            )
        consumer["status"] = "static_complete"
        consumer["verification_snapshot"] = {
            "factor_package_sha256": factor_package_sha256(Path(consumer["output_dir"])),
            "toolchain_sha256": verification_toolchain_sha256(),
            "source_sha256": consumer["source_sha256"],
            "dependencies": {
                "m_compat_select": {
                    "factor_package_sha256": factor_package_sha256(
                        Path(dependency["output_dir"])
                    ),
                    "source_sha256": dependency["source_sha256"],
                }
            },
        }

        fresh, reasons = static_completion_freshness(
            consumer, corpus_root=self.corpus, state=state
        )
        self.assertTrue(fresh, reasons)

        original_dependency_source = dependency["source_sha256"]
        dependency["source_sha256"] = "0" * 64
        fresh, reasons = static_completion_freshness(
            consumer, corpus_root=self.corpus, state=state
        )
        self.assertFalse(fresh)
        self.assertIn(
            "dependency_source_changed:m_compat_select",
            reasons,
        )
        dependency["source_sha256"] = original_dependency_source

        # Editing the real chapter without inventory refresh must invalidate
        # consumers too; the queued digest is not the current source content.
        original_text = self.compat_source.read_text(encoding="utf-8")
        self.compat_source.write_text(original_text + "changed chapter\n", encoding="utf-8")
        fresh, reasons = static_completion_freshness(
            consumer, corpus_root=self.corpus, state=state
        )
        self.assertFalse(fresh)
        self.assertIn("dependency_source_changed:m_compat_select", reasons)
        self.compat_source.write_text(original_text, encoding="utf-8")

        dependency_factor = (
            Path(dependency["output_dir"])
            / f"{dependency['factor_id']}.factor.yaml"
        )
        dependency_factor.write_text(
            dependency_factor.read_text(encoding="utf-8") + "description: changed\n",
            encoding="utf-8",
        )
        fresh, reasons = static_completion_freshness(
            consumer, corpus_root=self.corpus, state=state
        )
        self.assertFalse(fresh)
        self.assertEqual(
            [reason for reason in reasons if reason.startswith("dependency_")],
            ["dependency_factor_package_changed:m_compat_select"],
        )

    def test_inventory_loads_pdf_source_catalog_into_task_envelope(self):
        catalog_path = self._write_source_catalog()

        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )

        task = find_task(state, "doc2spec_general_ddl_create_view")
        self.assertEqual(state["source_catalog_path"], str(catalog_path.resolve()))
        self.assertEqual(task["document_id"], "gaussdb-centralized-reference-v10")
        self.assertEqual(task["parent_pdf_path"], str(self.parent_pdf.resolve()))
        self.assertEqual(
            task["parent_pdf_sha256"],
            hashlib.sha256(self.parent_pdf.read_bytes()).hexdigest(),
        )
        self.assertEqual(task["product_version"], "V2.0-10.0.0")
        self.assertEqual(task["document_version"], "01 (2026-04-30)")
        self.assertEqual(task["extraction_rule_version"], "gaussdb-pdf-sections-v1")
        self.assertEqual(
            task["outline_path"],
            ["1 SQL 参考", "1.13 SQL语法", "1.13.9.60 CREATE VIEW"],
        )
        self.assertEqual(task["start_destination"]["physical_page"], 1636)
        self.assertEqual(task["start_destination"]["y_from_top"], 84.0)
        self.assertEqual(task["end_destination"]["physical_page"], 1642)
        self.assertEqual(task["end_destination"]["y_from_top"], 492.0)
        self.assertEqual(task["physical_page_start"], 1636)
        self.assertEqual(task["physical_page_end"], 1642)
        self.assertEqual(task["printed_page_start"], "1587")
        self.assertEqual(task["printed_page_end"], "1593")
        self.assertEqual(task["chapter_sha256"], task["source_sha256"])
        self.assertEqual(len(state["tasks"]), 1)

    def test_catalog_inventory_rejects_uncataloged_source_file(self):
        catalog_path = self._write_source_catalog()
        extra = self.corpus / "general" / "ddl" / "not_in_catalog.txt"
        extra.write_text("CREATE SOMETHING\n", encoding="utf-8")

        with self.assertRaisesRegex(QueueError, "catalog 外"):
            inventory_state(
                self.corpus,
                self.specs,
                source_catalog_path=catalog_path,
            )

    def test_catalog_byte_drift_resets_preserved_static_completion(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "static_complete"
        task["verification_snapshot"] = {"sentinel": True}

        catalog_path.write_bytes(catalog_path.read_bytes() + b"\n")
        updated = inventory_state(self.corpus, self.specs, state)
        updated_task = find_task(updated, task["task_id"])

        self.assertEqual(updated_task["status"], "pending")
        self.assertNotIn("verification_snapshot", updated_task)
        self.assertIn("sidecar", updated_task["message"])

    def test_inventory_rejects_catalog_chapter_hash_mismatch(self):
        catalog_path = self._write_source_catalog()
        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
        catalog["chapters"][0]["chapter_sha256"] = "b" * 64
        catalog_path.write_text(json.dumps(catalog), encoding="utf-8")

        with self.assertRaisesRegex(QueueError, "chapter_sha256"):
            inventory_state(
                self.corpus,
                self.specs,
                source_catalog_path=catalog_path,
            )

    def test_removed_source_is_retained_as_blocked_for_audit(self):
        state = inventory_state(self.corpus, self.specs)
        self.compat_source.unlink()
        updated = inventory_state(self.corpus, self.specs, state)
        task = find_task(updated, "doc2spec_m_compat_dml_select")
        self.assertFalse(task["source_present"])
        self.assertEqual(task["status"], "blocked")

    def test_status_machine_prevents_fake_static_completion(self):
        state = inventory_state(self.corpus, self.specs)
        task = select_pending_task(state, variant="general", category="ddl")
        set_task_status(task, "in_progress")
        set_task_status(task, "generated")
        with self.assertRaisesRegex(QueueError, "verify"):
            set_task_status(task, "static_complete")
        with self.assertRaisesRegex(QueueError, "非法状态迁移"):
            set_task_status(task, "pending")

    def test_rendered_task_contains_envelope_without_embedding_source(self):
        state = inventory_state(self.corpus, self.specs)
        task = find_task(state, "doc2spec_general_ddl_create_view")
        template = self.root / "template.md"
        template.write_text(
            "{{TASK_ID}}\n{{SOURCE_PATH}}\n{{FACTOR_ID}}\n{{SOURCE_CONTENT}}\n",
            encoding="utf-8",
        )
        output = self.root / "task.md"
        render_task(state, task, template, output)
        rendered = output.read_text(encoding="utf-8")
        self.assertIn(task["task_id"], rendered)
        self.assertIn("create_view", rendered)
        self.assertIn("原文未内嵌", rendered)
        self.assertNotIn("语法说明", rendered)

    def test_rendered_catalog_task_contains_pdf_provenance(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        template = self.root / "pdf-template.md"
        template.write_text(
            "{{DOCUMENT_ID}}\n{{PARENT_PDF_SHA256}}\n{{PRODUCT_VERSION}}\n"
            "{{OUTLINE_PATH}}\n{{START_DESTINATION}}\n{{END_DESTINATION}}\n",
            encoding="utf-8",
        )

        output = self.root / "pdf-task.md"
        render_task(state, task, template, output)
        rendered = output.read_text(encoding="utf-8")

        self.assertIn("gaussdb-centralized-reference-v10", rendered)
        self.assertIn(task["parent_pdf_sha256"], rendered)
        self.assertIn("V2.0-10.0.0", rendered)
        self.assertIn("1.13.9.60 CREATE VIEW", rendered)
        self.assertNotIn("{{", rendered)

    def test_verify_is_the_only_path_to_static_complete(self):
        state = inventory_state(self.corpus, self.specs)
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "generated"
        output_dir = Path(task["output_dir"])
        output_dir.mkdir(parents=True, exist_ok=True)
        (output_dir / "create_view.factor.yaml").write_text(
            "kind: factor\n", encoding="utf-8"
        )
        successful = {"command": ["check"], "returncode": 0, "output": "OK"}
        with patch(
            "scripts.manage_extraction_queue.run_check",
            side_effect=[successful, successful, successful],
        ), patch(
            "scripts.manage_extraction_queue.validate_task_artifact",
            return_value=successful,
        ):
            self.assertTrue(verify_task(state, task, self.root / "generated"))
        self.assertEqual(task["status"], "static_complete")
        self.assertIn("不代表数据库行为", task["message"])
        self.assertEqual(
            task["verification_snapshot"]["factor_package_sha256"],
            factor_package_sha256(output_dir),
        )
        self.assertEqual(
            task["verification_snapshot"]["toolchain_sha256"],
            verification_toolchain_sha256(),
        )

    def test_catalog_backed_verify_accepts_matching_source_envelope(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "generated"
        self._write_minimal_task_artifact(task)
        successful = {"command": ["check"], "returncode": 0, "output": "OK"}

        with patch(
            "scripts.manage_extraction_queue.run_check",
            side_effect=[successful, successful, successful],
        ):
            self.assertTrue(verify_task(state, task, self.root / "generated"))

        self.assertEqual(task["status"], "static_complete")
        snapshot = task["verification_snapshot"]
        self.assertEqual(snapshot["source_sha256"], task["source_sha256"])
        self.assertEqual(snapshot["catalog_sha256"], task["source_catalog_sha256"])
        self.assertEqual(snapshot["parent_pdf_sha256"], task["parent_pdf_sha256"])

    def test_verify_snapshot_includes_external_factor_dependency_hashes(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        apply_factor_dependency_graph(
            state,
            {"create_view": {"shared_select"}},
        )
        task["status"] = "generated"
        self._write_minimal_task_artifact(task)
        dependency_dir = self.specs / "shared" / "shared_select"
        dependency_dir.mkdir(parents=True)
        dependency_source_sha256 = "a" * 64
        (dependency_dir / "shared_select.factor.yaml").write_text(
            "kind: factor\n"
            "id: shared_select\n"
            "source:\n"
            f"  artifact_sha256: {dependency_source_sha256}\n",
            encoding="utf-8",
        )
        successful = {"command": ["check"], "returncode": 0, "output": "OK"}

        with patch(
            "scripts.manage_extraction_queue.run_check",
            side_effect=[successful, successful, successful],
        ):
            self.assertTrue(verify_task(state, task, self.root / "generated"))

        dependency_snapshot = task["verification_snapshot"]["dependencies"]
        self.assertEqual(set(dependency_snapshot), {"shared_select"})
        self.assertEqual(
            dependency_snapshot["shared_select"]["source_sha256"],
            dependency_source_sha256,
        )
        self.assertEqual(
            dependency_snapshot["shared_select"]["factor_package_sha256"],
            factor_package_sha256(dependency_dir),
        )

    def test_source_catalog_and_parent_pdf_drift_make_static_completion_stale(self):
        drifts = {
            "source": "source_changed_after_verify",
            "catalog": "catalog_changed_after_verify",
            "parent_pdf": "parent_pdf_changed_after_verify",
        }
        successful = {"command": ["check"], "returncode": 0, "output": "OK"}

        for drift, expected_reason in drifts.items():
            with self.subTest(drift=drift):
                self.general_source.write_text(
                    "CREATE VIEW\n语法说明\n", encoding="utf-8"
                )
                catalog_path = self._write_source_catalog()
                state = inventory_state(
                    self.corpus,
                    self.specs,
                    source_catalog_path=catalog_path,
                )
                task = find_task(state, "doc2spec_general_ddl_create_view")
                task["status"] = "generated"
                self._write_minimal_task_artifact(task)
                with patch(
                    "scripts.manage_extraction_queue.run_check",
                    side_effect=[successful, successful, successful],
                ):
                    self.assertTrue(
                        verify_task(state, task, self.root / "generated")
                    )

                if drift == "source":
                    self.general_source.write_text(
                        "CREATE VIEW\nchanged\n", encoding="utf-8"
                    )
                elif drift == "catalog":
                    catalog_path.write_bytes(catalog_path.read_bytes() + b"\n")
                else:
                    self.parent_pdf.write_bytes(b"changed pdf")

                fresh, reasons = static_completion_freshness(
                    task, corpus_root=self.corpus
                )
                self.assertFalse(fresh)
                self.assertIn(expected_reason, reasons)

                output = io.StringIO()
                with redirect_stdout(output):
                    print_summary(state)
                self.assertIn("static_complete=0", output.getvalue())
                self.assertIn("static_complete_stale=1", output.getvalue())

    def test_claim_and_verify_can_reprocess_stale_static_complete(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "generated"
        self._write_minimal_task_artifact(task)
        successful = {"command": ["check"], "returncode": 0, "output": "OK"}
        with patch(
            "scripts.manage_extraction_queue.run_check",
            side_effect=[successful, successful, successful],
        ):
            self.assertTrue(verify_task(state, task, self.root / "generated"))

        with self.assertRaisesRegex(QueueError, "没有符合"):
            select_pending_task(state, variant="general", category="ddl")

        factor_path = Path(task["output_dir"]) / "create_view.factor.yaml"
        factor_path.write_text(
            factor_path.read_text(encoding="utf-8") + "description: changed\n",
            encoding="utf-8",
        )
        self.assertIs(
            select_pending_task(state, variant="general", category="ddl"),
            task,
        )

        with patch(
            "scripts.manage_extraction_queue.run_check",
            side_effect=[successful, successful, successful],
        ):
            self.assertTrue(verify_task(state, task, self.root / "generated"))
        fresh, reasons = static_completion_freshness(
            task, corpus_root=self.corpus
        )
        self.assertTrue(fresh, reasons)

    def test_catalog_backed_verify_requires_matching_main_source_catalog_ref(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")

        self._write_minimal_task_artifact(
            task,
            include_main_catalog_ref=False,
        )
        missing = validate_task_artifact(task, state=state)
        self.assertEqual(missing["returncode"], 1)
        self.assertIn("factor.source.catalog_chapter_ref", missing["output"])

        self._write_minimal_task_artifact(task)
        factor_path = Path(task["output_dir"]) / "create_view.factor.yaml"
        factor_path.write_text(
            factor_path.read_text(encoding="utf-8").replace(
                task["document_id"], "wrong-document-id"
            ),
            encoding="utf-8",
        )
        mismatched = validate_task_artifact(task, state=state)
        self.assertEqual(mismatched["returncode"], 1)
        self.assertIn("factor.source.catalog_chapter_ref", mismatched["output"])

    def test_catalog_backed_verify_rejects_factor_product_version_mismatch(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "generated"
        self._write_minimal_task_artifact(task)
        factor_path = Path(task["output_dir"]) / "create_view.factor.yaml"
        factor_path.write_text(
            factor_path.read_text(encoding="utf-8").replace(
                task["product_version"], "V2.0-9.0.0"
            ),
            encoding="utf-8",
        )

        self.assertFalse(verify_task(state, task, self.root / "generated"))

        envelope = task["checks"]["task_envelope"]
        self.assertEqual(envelope["returncode"], 1)
        self.assertIn("factor.source.version", envelope["output"])

    def test_catalog_chapter_ref_is_resolved_against_same_pdf_catalog(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        self._write_minimal_task_artifact(task)
        ledger_path = Path(task["output_dir"]) / "create_view.source.yaml"
        ledger_path.write_text(
            "factor_ref: create_view\n"
            f"artifact_sha256: {task['chapter_sha256']}\n"
            f"source_line_count: {task['source_line_count']}\n"
            "supplemental_sources:\n"
            "  - id: same_pdf_create_view\n"
            "    document: GaussDB SQL参考\n"
            f"    version: {task['product_version']}\n"
            "    retrieval_date: '2026-09-04'\n"
            "    source_anchor: CREATE VIEW\n"
            "    catalog_chapter_ref:\n"
            f"      document_id: {task['document_id']}\n"
            f"      source_relpath: {task['source_relpath']}\n"
            f"      chapter_sha256: {task['chapter_sha256']}\n",
            encoding="utf-8",
        )

        self.assertEqual(
            validate_task_artifact(task, state=state)["returncode"],
            0,
        )

        ledger_path.write_text(
            ledger_path.read_text(encoding="utf-8").replace(
                f"      chapter_sha256: {task['chapter_sha256']}",
                f"      chapter_sha256: {'b' * 64}",
            ),
            encoding="utf-8",
        )
        rejected = validate_task_artifact(task, state=state)
        self.assertEqual(rejected["returncode"], 1)
        self.assertIn("catalog_chapter_ref.chapter_sha256", rejected["output"])

    def test_catalog_backed_verify_rejects_provenance_mismatches(self):
        mutations = {
            "hash": lambda catalog: self.parent_pdf.write_bytes(
                b"%PDF-1.5\nchanged source document\n"
            ),
            "page_range": lambda catalog: catalog["chapters"][0].update(
                {"physical_page_end": 1643}
            ),
            "variant": lambda catalog: catalog["chapters"][0].update(
                {"variant": "m_compat"}
            ),
        }
        expected_messages = {
            "hash": "SHA-256",
            "page_range": "physical_page_end",
            "variant": "variant",
        }

        for mismatch, mutate in mutations.items():
            with self.subTest(mismatch=mismatch):
                self.general_source.write_text("CREATE VIEW\n语法说明\n", encoding="utf-8")
                catalog_path = self._write_source_catalog()
                state = inventory_state(
                    self.corpus,
                    self.specs,
                    source_catalog_path=catalog_path,
                )
                task = find_task(state, "doc2spec_general_ddl_create_view")
                task["status"] = "generated"
                self._write_minimal_task_artifact(task)

                catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
                mutate(catalog)
                catalog_path.write_text(json.dumps(catalog), encoding="utf-8")

                self.assertFalse(verify_task(state, task, self.root / "generated"))
                self.assertEqual(task["status"], "needs_review")
                envelope = task["checks"]["task_envelope"]
                self.assertEqual(envelope["returncode"], 1)
                self.assertIn(expected_messages[mismatch], envelope["output"])

    def test_current_source_hash_drift_is_reported_once(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        task = find_task(state, "doc2spec_general_ddl_create_view")
        self._write_minimal_task_artifact(task)
        self.general_source.write_text("CREATE VIEW\n已变化说明\n", encoding="utf-8")

        result = validate_task_artifact(task, state=state)

        self.assertEqual(result["returncode"], 1)
        self.assertEqual(
            result["output"].count("当前章节文本 SHA-256 与任务快照不一致"),
            1,
        )
        self.assertNotIn(
            "source catalog chapter_sha256 与任务章节文本 SHA-256 不一致",
            result["output"],
        )

    def test_verify_writeback_guard_rejects_queue_or_catalog_drift(self):
        catalog_path = self._write_source_catalog()
        state = inventory_state(
            self.corpus,
            self.specs,
            source_catalog_path=catalog_path,
        )
        snapshot = dict(find_task(state, "doc2spec_general_ddl_create_view"))

        changed_task = dict(snapshot)
        changed_task["physical_page_end"] += 1
        with self.assertRaisesRegex(QueueError, "physical_page_end"):
            ensure_verify_writeback_safe(state, snapshot, changed_task)

        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
        catalog["document_version"] = "02"
        catalog_path.write_text(json.dumps(catalog), encoding="utf-8")
        with self.assertRaisesRegex(QueueError, "verify 期间来源证据已变化"):
            ensure_verify_writeback_safe(state, snapshot, snapshot)

    def test_task_envelope_rejects_old_package_for_changed_source(self):
        state = inventory_state(self.corpus, self.specs)
        task = find_task(state, "doc2spec_general_ddl_create_view")
        output_dir = Path(task["output_dir"])
        output_dir.mkdir(parents=True)
        (output_dir / "create_view.factor.yaml").write_text(
            "id: create_view\nsource:\n  artifact_sha256: old-sha\n",
            encoding="utf-8",
        )
        (output_dir / "create_view.source.yaml").write_text(
            "factor_ref: create_view\n"
            "artifact_sha256: old-sha\n"
            "source_line_count: 2\n",
            encoding="utf-8",
        )
        result = validate_task_artifact(task)
        self.assertEqual(result["returncode"], 1)
        self.assertIn("SHA-256", result["output"])


if __name__ == "__main__":
    unittest.main()
