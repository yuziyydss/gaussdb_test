-- generated_from: manifest_merge_action_required_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_merge_action_required_negative_5e009bd3dfe7
-- expected: error
-- expected_error_category: merge_action_required
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_none_invalid", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source AS src ON (dst.id = src.id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;
