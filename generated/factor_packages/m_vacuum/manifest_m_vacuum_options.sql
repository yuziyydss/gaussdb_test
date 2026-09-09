-- generated_from: manifest_m_vacuum_options
-- static_only: true
-- case_count: 16

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_vacuum_options_ff61ddb03213
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_8079be9a7689
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_verbose_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (VERBOSE, ANALYZE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_08bc3e62d871
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze_verbose", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE) m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_b540a299e871
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_verbose", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (VERBOSE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_c047d7d7fd4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_freeze_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FREEZE, ANALYZE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_76d0739e1fc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_full_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FULL, ANALYZE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_b8cf7ef5ddf5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_4d95e9b75c3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE) m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_349ff08ef177
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_verbose_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (VERBOSE, ANALYZE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_8e0d6454bff0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_verbose_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (VERBOSE, ANALYZE) m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_3ebd6e40bbb2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_all", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze_verbose", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE) m_vacuum_source;
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_c97b13782647
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_analyze_verbose", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_25fe8b79ba0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_freeze_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FREEZE, ANALYZE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_1d6a9a4a9279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_freeze_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FREEZE, ANALYZE) m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_2cddb448ad53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_full_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FULL, ANALYZE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;

-- case_id: manifest_m_vacuum_options_dea0e789b25b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_vacuum_columns_two", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_full_analyze", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (FULL, ANALYZE) m_vacuum_source (id, qty);
-- fixture_teardown:
DROP TABLE m_vacuum_source;
