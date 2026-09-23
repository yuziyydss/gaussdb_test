-- generated_from: manifest_alter_tablespace_fresh_rename
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_tablespace_fresh_rename_2db5f0ffba56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_tablespace_action_rename", "tablespace_name": "alter_tablespace_tablespace_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_tablespace_fact_body_8"], "key": "tablespace_alter_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_tablespace::create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}]
-- fixture_setup:
CREATE TABLESPACE g_alter_tbspc RELATIVE LOCATION 'g_alter_tbspc';
-- test_sql:
ALTER TABLESPACE g_alter_tbspc RENAME TO g_alter_tbspc_renamed;
-- fixture_teardown:
DROP TABLESPACE IF EXISTS g_alter_tbspc;
DROP TABLESPACE IF EXISTS g_alter_tbspc_renamed;
