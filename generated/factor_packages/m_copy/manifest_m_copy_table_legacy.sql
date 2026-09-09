-- generated_from: manifest_m_copy_table_legacy
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_copy_table_legacy_29f4f018eb18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_c1889e9fb8a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_24604d22de33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_dc2cdbd78e59
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_ff3c2ab44c22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_3957db27e3ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_a20e9657d87b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_id", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id) TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_f01d7f3ee5ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_table_legacy_628221040e86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_two", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_table", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY m_b01_source (id, qty) TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;
