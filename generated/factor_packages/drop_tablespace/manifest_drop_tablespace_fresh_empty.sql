-- generated_from: manifest_drop_tablespace_fresh_empty
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_tablespace_fresh_empty_c0703be6a887
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_tablespace_if_exists_none", "tablespace_name": "drop_tablespace_tablespace_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fresh_empty_relative_tablespace"], "fact_refs": ["drop_tablespace_fact_runtime_contract"], "key": "dedicated_directory_cleanup"}]
-- fixture_setup:
CREATE TABLESPACE g_drop_tbspc RELATIVE LOCATION 'g_drop_tbspc';
-- test_sql:
DROP TABLESPACE g_drop_tbspc;
-- fixture_teardown:
DROP TABLESPACE IF EXISTS g_drop_tbspc;

-- case_id: manifest_drop_tablespace_fresh_empty_09689af12f49
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_tablespace_if_exists_yes", "tablespace_name": "drop_tablespace_tablespace_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fresh_empty_relative_tablespace"], "fact_refs": ["drop_tablespace_fact_runtime_contract"], "key": "dedicated_directory_cleanup"}]
-- fixture_setup:
CREATE TABLESPACE g_drop_tbspc RELATIVE LOCATION 'g_drop_tbspc';
-- test_sql:
DROP TABLESPACE IF EXISTS g_drop_tbspc;
-- fixture_teardown:
DROP TABLESPACE IF EXISTS g_drop_tbspc;
