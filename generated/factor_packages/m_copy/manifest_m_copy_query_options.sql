-- generated_from: manifest_m_copy_query_options
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_copy_query_options_5a5addf74f57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_4de25ef304aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_two", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT WITH (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_f5f18bfb8417
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_reverse", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_20f619bc7bc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT WITH (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_4b868c25e455
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_two", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_fb55d35c373a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_reverse", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT WITH (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_1075c68ae589
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_0389668b5918
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_cc730cb40935
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_id", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT WITH (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_85eb4f6b3575
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_two", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_35813d1fed76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_two", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'text');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_7aca443572d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text_pipe", "projection": "m_copy_projection_two", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_47da0a3edc54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv", "projection": "m_copy_projection_reverse", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_abf4dc105655
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_pipe", "projection": "m_copy_projection_reverse", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv', DELIMITER '|');
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_options_4dddf7e20896
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_csv_noheader", "projection": "m_copy_projection_reverse", "style": "m_copy_style_options", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT (FORMAT 'csv', HEADER FALSE);
-- fixture_teardown:
DROP TABLE m_b01_source;
