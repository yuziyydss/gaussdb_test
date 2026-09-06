-- generated_from: manifest_alter_role_unlock
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_role_unlock_1bcff48f8933
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_role_assignment_to", "form": "alter_role_form_unlock", "options": "alter_role_options_nologin", "reset_target": "alter_role_reset_target_one", "value": "alter_role_value_postgres", "with_keyword": "alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
ALTER ROLE b9_role_a ACCOUNT LOCK;
-- test_sql:
ALTER ROLE b9_role_a ACCOUNT UNLOCK;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_a;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
