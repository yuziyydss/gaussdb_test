-- generated_from: manifest_m_vacuum_plain
-- static_only: true
-- case_count: 5

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_vacuum_plain_7c887ef69726
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_plain", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_plain_fb0448f37fc9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_plain", "freeze": "m_vacuum_freeze_yes", "full": "m_vacuum_full_yes", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FULL FREEZE VERBOSE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_plain_587bfadb6b35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_plain", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM VERBOSE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_plain_eae31296bc0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_plain", "freeze": "m_vacuum_freeze_yes", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FREEZE m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_plain_ded1248f6e6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_plain", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_yes", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM FULL m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;
