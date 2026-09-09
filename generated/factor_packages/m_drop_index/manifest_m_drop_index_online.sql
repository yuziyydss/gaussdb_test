-- generated_from: manifest_m_drop_index_online
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_index_online_16389c4589da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_default", "form": "m_drop_index_form_ordinary", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_on", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_drop_index_fact_online_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX CONCURRENTLY m_b03_existing_index;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_online_ae33b7c59074
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_restrict", "form": "m_drop_index_form_ordinary", "if_exists": "m_drop_index_if_exists_yes", "online": "m_drop_index_online_on", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_drop_index_fact_online_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX CONCURRENTLY IF EXISTS m_b03_existing_index RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_online_4591473582bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_restrict", "form": "m_drop_index_form_ordinary", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_on", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_drop_index_fact_online_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX CONCURRENTLY m_b03_existing_index RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_online_8ff221e47d79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_default", "form": "m_drop_index_form_ordinary", "if_exists": "m_drop_index_if_exists_yes", "online": "m_drop_index_online_on", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_drop_index_fact_online_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX CONCURRENTLY IF EXISTS m_b03_existing_index;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;
