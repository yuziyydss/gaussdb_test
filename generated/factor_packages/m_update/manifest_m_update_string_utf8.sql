-- generated_from: manifest_m_update_string_utf8
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_update_string_utf8_fe5cd595fba2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_empty", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = '' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_323b7e300dfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_ascii_short", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = 'a' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_bb0fa8800552
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_ascii_edge", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = 'ab' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_3bcae9271163
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_han_short", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = '中' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_8abb944c702e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_han_edge", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = '中文' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_e3135c85deb4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_four_byte", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = '😀好' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_4db24ed37961
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_quote", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = 'a''' WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;

-- case_id: manifest_m_update_string_utf8_0a08d88c0586
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_string_default", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_string_utf8", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_update_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_update_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_update_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_update_utf8_source VALUES (2,'旧');
-- test_sql:
UPDATE m_update_utf8_source SET note = DEFAULT WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_update_utf8_source RESTRICT;
