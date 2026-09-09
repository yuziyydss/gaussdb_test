-- generated_from: manifest_m_analyze_ordinary
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_analyze_ordinary_bf75f5995b4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_all", "verbose": "m_analyze_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_f0da3faadcdf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_id", "verbose": "m_analyze_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE m_b01_source (id);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_59b06ee8a425
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_two", "verbose": "m_analyze_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE m_b01_source (id, qty);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_18e659daf69d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_multi", "verbose": "m_analyze_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE m_b01_source ((id, qty));
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_5e767f70219f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_all", "verbose": "m_analyze_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE VERBOSE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_d4a19c2cb3d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_id", "verbose": "m_analyze_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE VERBOSE m_b01_source (id);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_ce9657112cd7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_two", "verbose": "m_analyze_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE VERBOSE m_b01_source (id, qty);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_analyze_ordinary_cd404638f8c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_analyze_columns_multi", "verbose": "m_analyze_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE VERBOSE m_b01_source ((id, qty));
-- fixture_teardown:
DROP TABLE m_b01_source;
