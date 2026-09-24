-- generated_from: manifest_autohint_purge_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_autohint_purge_fresh_syntax_cdbf2e6d00a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "autohint_purge_command_fixed"}
-- environment_requirements: [{"allowed_values": ["super_or_admin"], "fact_refs": ["autohint_purge_fact_body_9"], "key": "actor_authority"}]
-- test_sql:
AUTOHINT PURGE;
