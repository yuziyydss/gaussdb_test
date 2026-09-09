-- generated_from: manifest_m_alter_user_options
-- static_only: true
-- case_count: 16

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_user_options_478cc52e3b99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_login", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing NOLOGIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_1a027f81ebbf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_createdb", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH NOCREATEDB;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_b227e44b2f10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_createrole", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing NOCREATEROLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_296108d7e057
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_inherit", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing INHERIT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_07a210a32e8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_inherit", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing NOINHERIT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_a882c463b7c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_one", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing CONNECTION LIMIT 1;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_2b1b8c7da374
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_lock", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing ACCOUNT LOCK;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_5ecf8b6f9496
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_unlock", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing ACCOUNT UNLOCK;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_a3878bde163e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_createdb", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing NOCREATEDB;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_fd117812d723
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_login", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH NOLOGIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_8f1915d4637d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_createrole", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH NOCREATEROLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_4a4b9d4ee373
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_inherit", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH INHERIT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_5b5e8a81b713
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_no_inherit", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH NOINHERIT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_6f3c4c1b779c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_one", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH CONNECTION LIMIT 1;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_c55261461183
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_lock", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH ACCOUNT LOCK;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_options_cac48a5b5b07
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_options", "option": "m_alter_user_option_unlock", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing WITH ACCOUNT UNLOCK;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;
