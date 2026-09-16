-- generated_from: manifest_m_insert_string_utf8
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_string_utf8_3b7b5666e174
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_empty", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_f3731e9f1ffc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_ascii_short", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'a');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_67c21abd3774
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_ascii_edge", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'ab');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_33cb31ea658f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_han_short", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'中');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_5efc1b2b427f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_han_edge", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'中文');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_c9781e83b6cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_four_byte", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'😀好');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_8f2f848f876b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_quote", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,'a''');
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_e6f6a64a1b15
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_default", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7,DEFAULT);
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;

-- case_id: manifest_m_insert_string_utf8_659227c150af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_string_omitted", "target_profile": "m_insert_target_profile_string_utf8", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "server_encoding"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "client_encoding"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_connection"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_database"}, {"allowed_values": ["utf8mb4"], "fact_refs": ["m_insert_fact_string_encoding"], "key": "character_set_results"}]
-- fixture_setup:
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
-- test_sql:
INSERT INTO m_insert_utf8_source VALUES (7);
-- fixture_teardown:
DROP TABLE m_insert_utf8_source RESTRICT;
