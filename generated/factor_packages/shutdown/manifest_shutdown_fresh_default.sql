-- generated_from: manifest_shutdown_fresh_default
-- static_only: true
-- case_count: 3

-- case_id: manifest_shutdown_fresh_default_759f0ac5cda0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "shutdown_mode_default"}
-- environment_requirements: [{"allowed_values": ["admin"], "fact_refs": ["shutdown_fact_privilege"], "key": "shutdown_privilege"}]
-- test_sql:
SHUTDOWN;

-- case_id: manifest_shutdown_fresh_default_f020ca805f4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "shutdown_mode_fast"}
-- environment_requirements: [{"allowed_values": ["admin"], "fact_refs": ["shutdown_fact_privilege"], "key": "shutdown_privilege"}]
-- test_sql:
SHUTDOWN FAST;

-- case_id: manifest_shutdown_fresh_default_8fc647d3a21d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "shutdown_mode_immediate"}
-- environment_requirements: [{"allowed_values": ["admin"], "fact_refs": ["shutdown_fact_privilege"], "key": "shutdown_privilege"}]
-- test_sql:
SHUTDOWN IMMEDIATE;
