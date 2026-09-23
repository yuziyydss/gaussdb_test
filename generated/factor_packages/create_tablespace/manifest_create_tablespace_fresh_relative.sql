-- generated_from: manifest_create_tablespace_fresh_relative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_tablespace_fresh_relative_f16b0f408d04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "create_tablespace_directory_fresh", "maxsize": "create_tablespace_maxsize_none", "options": "create_tablespace_options_none", "owner": "create_tablespace_owner_none", "relative": "create_tablespace_relative_yes", "tablespace_name": "create_tablespace_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}, {"allowed_values": ["current_system_administrator"], "fact_refs": ["create_tablespace_fact_body_56"], "key": "tablespace_owner_mode"}]
-- fixture_setup:
CREATE TABLESPACE g_create_tbspc RELATIVE LOCATION 'g_create_tbspc';
-- test_sql:
CREATE TABLESPACE g_create_tbspc RELATIVE LOCATION 'g_create_tbspc';
-- fixture_teardown:
DROP TABLESPACE g_create_tbspc;
