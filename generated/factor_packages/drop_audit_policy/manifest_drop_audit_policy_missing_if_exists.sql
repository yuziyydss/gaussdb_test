-- generated_from: manifest_drop_audit_policy_missing_if_exists
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_audit_policy_missing_if_exists_a3488ae85dba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_audit_policy_if_exists_yes", "policy_name": "drop_audit_policy_policy_name_missing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_audit_policy_fact_privilege"], "key": "security_policy_admin"}]
-- test_sql:
DROP AUDIT POLICY IF EXISTS b10_audit_missing;
