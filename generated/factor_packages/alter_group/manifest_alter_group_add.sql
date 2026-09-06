-- generated_from: manifest_alter_group_add
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_group_add_14c7952f6af1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_group_form_add", "members": "alter_group_members_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER GROUP b9_role_a ADD USER b9_role_b;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_group_add_413f40f1fb36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_group_form_add", "members": "alter_group_members_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER GROUP b9_role_a ADD USER b9_role_b, b9_role_c;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
