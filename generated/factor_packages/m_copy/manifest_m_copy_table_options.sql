-- generated_from: manifest_m_copy_table_options
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_copy_table_options_99c3f4b7a0e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_56f6324c7779
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT WITH (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_f84af3cf9fe0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_b03eea2131aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT WITH (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_3a1124f7490c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_0189d5378f24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT WITH (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_7f08cd733297
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_acdfdc954ca5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_f5a3822d8732
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT WITH (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_d7c485539cc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_834cb9b7442f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_1395be86261b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_17f6c7052dfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_31b68746879f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_options_8854e31fc884
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;
