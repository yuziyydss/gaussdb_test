-- generated_from: manifest_m_create_role_finite
-- static_only: true
-- case_count: 10

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_role_finite_1566eefee15c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_default", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_47b505c360a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_unlimited", "membership_keyword": "m_create_role_membership_keyword_group", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_identified", "with_keyword": "m_create_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new WITH NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN GROUP m_b04_role_parent CONNECTION LIMIT -1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_8a8c7444c911
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_zero", "membership_keyword": "m_create_role_membership_keyword_group", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN GROUP m_b04_role_parent CONNECTION LIMIT 0 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_bcc36904d5f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_one", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_identified", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent CONNECTION LIMIT 1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_fd5ea23c56c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_max", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new WITH NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent CONNECTION LIMIT 2147483647 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_07d7d8021644
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_unlimited", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent CONNECTION LIMIT -1 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_6c2d078fd2ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_max", "membership_keyword": "m_create_role_membership_keyword_group", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_identified", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN GROUP m_b04_role_parent CONNECTION LIMIT 2147483647 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_6c15b14cbb6e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_one", "membership_keyword": "m_create_role_membership_keyword_group", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new WITH NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN GROUP m_b04_role_parent CONNECTION LIMIT 1 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_15fc1a8ca2aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_zero", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_identified", "with_keyword": "m_create_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new WITH NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent CONNECTION LIMIT 0 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;

-- case_id: manifest_m_create_role_finite_b80d0041354e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_role_connection_limit_default", "membership_keyword": "m_create_role_membership_keyword_group", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_identified", "with_keyword": "m_create_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new WITH NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN GROUP m_b04_role_parent IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;
