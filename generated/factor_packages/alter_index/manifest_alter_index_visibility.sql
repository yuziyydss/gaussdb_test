-- generated_from: manifest_alter_index_visibility
-- static_only: true
-- case_count: 4

-- case_id: manifest_alter_index_visibility_a93b4eebd243
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_visible", "if_exists": "alter_index_if_exists_absent", "index_name": "alter_index_index_name_regular", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_low", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- environment_requirements: [{"allowed_values": ["normal_or_committed"], "fact_refs": ["alter_index_fact_upgrade"], "key": "upgrade_stage"}, {"allowed_values": ["true"], "fact_refs": ["alter_index_fact_visible_gate", "alter_index_fact_invisible_gate"], "key": "visibility_keywords_enabled"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
DROP INDEX IF EXISTS idx_ai_missing;
DROP INDEX IF EXISTS idx_ai_new;
CREATE INDEX idx_ai_regular ON t_ci_astore(id);
-- test_sql:
ALTER INDEX idx_ai_regular VISIBLE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_new;
DROP INDEX IF EXISTS idx_ai_regular;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_alter_index_visibility_82277ece4a5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_invisible", "if_exists": "alter_index_if_exists_present", "index_name": "alter_index_index_name_regular", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_low", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- environment_requirements: [{"allowed_values": ["normal_or_committed"], "fact_refs": ["alter_index_fact_upgrade"], "key": "upgrade_stage"}, {"allowed_values": ["true"], "fact_refs": ["alter_index_fact_visible_gate", "alter_index_fact_invisible_gate"], "key": "visibility_keywords_enabled"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
DROP INDEX IF EXISTS idx_ai_missing;
DROP INDEX IF EXISTS idx_ai_new;
CREATE INDEX idx_ai_regular ON t_ci_astore(id);
-- test_sql:
ALTER INDEX IF EXISTS idx_ai_regular INVISIBLE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_new;
DROP INDEX IF EXISTS idx_ai_regular;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_alter_index_visibility_28370238f953
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_visible", "if_exists": "alter_index_if_exists_present", "index_name": "alter_index_index_name_regular", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_low", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- environment_requirements: [{"allowed_values": ["normal_or_committed"], "fact_refs": ["alter_index_fact_upgrade"], "key": "upgrade_stage"}, {"allowed_values": ["true"], "fact_refs": ["alter_index_fact_visible_gate", "alter_index_fact_invisible_gate"], "key": "visibility_keywords_enabled"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
DROP INDEX IF EXISTS idx_ai_missing;
DROP INDEX IF EXISTS idx_ai_new;
CREATE INDEX idx_ai_regular ON t_ci_astore(id);
-- test_sql:
ALTER INDEX IF EXISTS idx_ai_regular VISIBLE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_new;
DROP INDEX IF EXISTS idx_ai_regular;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_alter_index_visibility_3982689357ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_invisible", "if_exists": "alter_index_if_exists_absent", "index_name": "alter_index_index_name_regular", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_low", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- environment_requirements: [{"allowed_values": ["normal_or_committed"], "fact_refs": ["alter_index_fact_upgrade"], "key": "upgrade_stage"}, {"allowed_values": ["true"], "fact_refs": ["alter_index_fact_visible_gate", "alter_index_fact_invisible_gate"], "key": "visibility_keywords_enabled"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
DROP INDEX IF EXISTS idx_ai_missing;
DROP INDEX IF EXISTS idx_ai_new;
CREATE INDEX idx_ai_regular ON t_ci_astore(id);
-- test_sql:
ALTER INDEX idx_ai_regular INVISIBLE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_new;
DROP INDEX IF EXISTS idx_ai_regular;
DROP TABLE IF EXISTS t_ci_astore CASCADE;
