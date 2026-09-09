-- generated_from: manifest_m_reindex_online
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_reindex_online_f456de69d7c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"force": "m_reindex_force_none", "online": "m_reindex_online_on", "target": "m_reindex_target_index"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_reindex_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_reindex_fact_online"], "key": "execution_context"}, {"allowed_values": ["verified_non_pcr_btree_or_ubtree"], "fact_refs": ["m_reindex_fact_online"], "key": "index_storage"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
REINDEX INDEX CONCURRENTLY m_b03_existing_index;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_reindex_online_711f5aef6e0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"force": "m_reindex_force_yes", "online": "m_reindex_online_on", "target": "m_reindex_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_reindex_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_reindex_fact_online"], "key": "execution_context"}, {"allowed_values": ["verified_non_pcr_btree_or_ubtree"], "fact_refs": ["m_reindex_fact_online"], "key": "index_storage"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
REINDEX TABLE CONCURRENTLY m_b01_source FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_reindex_online_f58fb48e083b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"force": "m_reindex_force_yes", "online": "m_reindex_online_on", "target": "m_reindex_target_index"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_reindex_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_reindex_fact_online"], "key": "execution_context"}, {"allowed_values": ["verified_non_pcr_btree_or_ubtree"], "fact_refs": ["m_reindex_fact_online"], "key": "index_storage"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
REINDEX INDEX CONCURRENTLY m_b03_existing_index FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_reindex_online_4c7440c3ea2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"force": "m_reindex_force_none", "online": "m_reindex_online_on", "target": "m_reindex_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_reindex_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_reindex_fact_online"], "key": "execution_context"}, {"allowed_values": ["verified_non_pcr_btree_or_ubtree"], "fact_refs": ["m_reindex_fact_online"], "key": "index_storage"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
REINDEX TABLE CONCURRENTLY m_b01_source;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;
