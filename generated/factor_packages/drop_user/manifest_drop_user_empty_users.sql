-- generated_from: manifest_drop_user_empty_users
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_user_empty_users_8f0b7f14077a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_user_behavior_default", "if_exists": "drop_user_if_exists_none", "targets": "drop_user_targets_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_user_fact_privilege_schema"], "key": "user_drop_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP USER b9_user_a;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_drop_user_empty_users_12eb1fb405dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_user_behavior_restrict", "if_exists": "drop_user_if_exists_none", "targets": "drop_user_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_user_fact_privilege_schema"], "key": "user_drop_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP USER b9_user_a, b9_user_b RESTRICT;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_drop_user_empty_users_5052709b1bb6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_user_behavior_restrict", "if_exists": "drop_user_if_exists_yes", "targets": "drop_user_targets_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_user_fact_privilege_schema"], "key": "user_drop_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP USER IF EXISTS b9_user_a RESTRICT;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_drop_user_empty_users_108dd0463986
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_user_behavior_default", "if_exists": "drop_user_if_exists_yes", "targets": "drop_user_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_user_fact_privilege_schema"], "key": "user_drop_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP USER IF EXISTS b9_user_a, b9_user_b;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;
