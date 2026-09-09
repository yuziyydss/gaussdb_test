-- generated_from: manifest_m_vacuum_analyze
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_vacuum_analyze_666776e251e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM ANALYZE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_82126e9cd2c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_yes", "full": "m_vacuum_full_yes", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FULL FREEZE VERBOSE ANALYZE m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_d9f49653f618
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM VERBOSE ANALYZE m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_649ce571bf52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_yes", "full": "m_vacuum_full_yes", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FULL FREEZE ANALYZE m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_d78f39dfe9d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM ANALYZE m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_f11164b034e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_yes", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FREEZE VERBOSE ANALYZE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_analyze_1be529076aff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_analyze", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_yes", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FULL ANALYZE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;
