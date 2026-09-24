-- generated_from: manifest_drop_row_level_security_policy_missing_if_exists
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_row_level_security_policy_missing_if_exists_be3c7a2f429f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_none", "if_exists": "drop_row_level_security_policy_if_exists_yes", "long_form": "drop_row_level_security_policy_long_form_short", "policy_name": "drop_row_level_security_policy_policy_name_missing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- test_sql:
DROP POLICY IF EXISTS b10_rls_missing ON b10_rls_source;
