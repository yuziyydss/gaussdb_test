-- generated_from: manifest_impdp_pluggable_database_recover_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_impdp_pluggable_database_recover_fresh_syntax_ce8e902939f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "impdp_pluggable_database_recover_command_fixed"}
-- environment_requirements: [{"allowed_values": ["authoritative"], "fact_refs": ["impdp_pluggable_database_recover_fact_tool_only"], "key": "backup_tool_context"}]
-- test_sql:
IMPDP PLUGGABLE DATABASE RECOVER;
