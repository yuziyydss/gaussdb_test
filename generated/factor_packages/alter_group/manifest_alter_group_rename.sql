-- generated_from: manifest_alter_group_rename
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_group_rename_0ac70b732e8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_group_form_rename", "members": "alter_group_members_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
SELECT 1 / (1 - COUNT(*)) AS assert_group_name_absent FROM gs_roles WHERE rolname = 'b9_group_renamed';
-- test_sql:
ALTER GROUP b9_role_a RENAME TO b9_group_renamed;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_group_renamed;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
