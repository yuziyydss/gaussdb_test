-- generated_from: manifest_m_create_group_finite
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_group_finite_2a7d8efad155
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_default", "inherit": "m_create_group_inherit_yes", "password_keyword": "m_create_group_password_keyword_password", "with_keyword": "m_create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_group_parent PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_e2d7bf47368f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_zero", "inherit": "m_create_group_inherit_no", "password_keyword": "m_create_group_password_keyword_identified", "with_keyword": "m_create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_group_parent CONNECTION LIMIT 0 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_ca45b4ab2f00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_unlimited", "inherit": "m_create_group_inherit_no", "password_keyword": "m_create_group_password_keyword_password", "with_keyword": "m_create_group_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new WITH NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_group_parent CONNECTION LIMIT -1 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_a7cd610b2f63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_default", "inherit": "m_create_group_inherit_yes", "password_keyword": "m_create_group_password_keyword_identified", "with_keyword": "m_create_group_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new WITH NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_group_parent IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_bc84f34ababc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_unlimited", "inherit": "m_create_group_inherit_yes", "password_keyword": "m_create_group_password_keyword_identified", "with_keyword": "m_create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_group_parent CONNECTION LIMIT -1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_5265c4a19c32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_zero", "inherit": "m_create_group_inherit_yes", "password_keyword": "m_create_group_password_keyword_password", "with_keyword": "m_create_group_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new WITH NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_group_parent CONNECTION LIMIT 0 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;

-- case_id: manifest_m_create_group_finite_e8bcf524c364
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_group_connection_limit_default", "inherit": "m_create_group_inherit_no", "password_keyword": "m_create_group_password_keyword_password", "with_keyword": "m_create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_group_parent PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;
