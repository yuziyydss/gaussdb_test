-- generated_from: manifest_m_copy_query_legacy
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_copy_query_legacy_9a5238be104c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_180328ec0bbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_two", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_730157a0097e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_reverse", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_57f72680c09a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_25a634f51241
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_id", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id FROM m_b01_source ORDER BY id) TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_5236e16726c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_two", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_8950cff93469
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_pipe", "options": "m_copy_options_text", "projection": "m_copy_projection_two", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT id, qty FROM m_b01_source ORDER BY id) TO STDOUT DELIMITER '|';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_30cb61d0697c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_default", "options": "m_copy_options_text", "projection": "m_copy_projection_reverse", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_copy_query_legacy_9098cc3b489a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_copy_columns_all", "legacy": "m_copy_legacy_csv", "options": "m_copy_options_text", "projection": "m_copy_projection_reverse", "style": "m_copy_style_legacy", "target": "m_copy_target_query", "with_keyword": "m_copy_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_copy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_copy_fact_authority"], "key": "table_authority"}, {"allowed_values": ["copy_out_stream_runner_required"], "fact_refs": ["m_copy_fact_stream"], "key": "result_transport"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COPY (SELECT qty, id FROM m_b01_source ORDER BY id) TO STDOUT CSV;
-- fixture_teardown:
DROP TABLE m_b01_source;
