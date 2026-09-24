-- generated_from: manifest_drop_client_master_key_fresh_syntax
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_client_master_key_fresh_syntax_a111ec536390
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v0", "if_exists": "drop_client_master_key_if_exists_none", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY g_drop_client_master_key;

-- case_id: manifest_drop_client_master_key_fresh_syntax_8e6dceecf911
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v1", "if_exists": "drop_client_master_key_if_exists_yes", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY IF EXISTS g_drop_client_master_key CASCADE;

-- case_id: manifest_drop_client_master_key_fresh_syntax_c1d0cf123ead
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v2", "if_exists": "drop_client_master_key_if_exists_none", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY g_drop_client_master_key RESTRICT;

-- case_id: manifest_drop_client_master_key_fresh_syntax_bb795567497d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v1", "if_exists": "drop_client_master_key_if_exists_none", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY g_drop_client_master_key CASCADE;

-- case_id: manifest_drop_client_master_key_fresh_syntax_1fa34f812060
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v0", "if_exists": "drop_client_master_key_if_exists_yes", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY IF EXISTS g_drop_client_master_key;

-- case_id: manifest_drop_client_master_key_fresh_syntax_7f386f932dd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_client_master_key_behavior_v2", "if_exists": "drop_client_master_key_if_exists_yes", "key_names": "drop_client_master_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cmk_owner_or_drop_privilege"], "fact_refs": ["drop_client_master_key_fact_privilege"], "key": "cmk_drop_privilege"}]
-- test_sql:
DROP CLIENT MASTER KEY IF EXISTS g_drop_client_master_key RESTRICT;
