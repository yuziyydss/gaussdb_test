from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from scripts.manage_extraction_queue import (
    QueueError,
    find_task,
    inventory_state,
    read_state,
    render_task,
    select_pending_task,
    set_task_status,
    validate_task_artifact,
    verify_task,
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

    def test_verify_is_the_only_path_to_static_complete(self):
        state = inventory_state(self.corpus, self.specs)
        task = find_task(state, "doc2spec_general_ddl_create_view")
        task["status"] = "generated"
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
