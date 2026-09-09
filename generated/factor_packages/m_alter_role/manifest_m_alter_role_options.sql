-- generated_from: manifest_m_alter_role_options
-- static_only: true
-- case_count: 16

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_role_options_0bd034269592
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_login", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing NOLOGIN;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_49f04d4b4aa2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_createdb", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH NOCREATEDB;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_1a034fa42e2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_createrole", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing NOCREATEROLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_76319a06e773
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_one", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing CONNECTION LIMIT 1;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_5f57c7126603
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_lock", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing ACCOUNT LOCK;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_16c5addab238
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_unlock", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing ACCOUNT UNLOCK;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_a90aa538bb2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_disable", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_3e4af2e38290
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_identified_disable", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_7ecd7c133746
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_createdb", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing NOCREATEDB;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_a61586601df1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_login", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH NOLOGIN;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_7b7773ff82c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_no_createrole", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH NOCREATEROLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_090857b7c4d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_one", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH CONNECTION LIMIT 1;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_0cec09b12c20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_lock", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH ACCOUNT LOCK;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_64ea535c92d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_unlock", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH ACCOUNT UNLOCK;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_4f99a9528c95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_disable", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_role_options_3fb0fe6dbdd9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_role_form_options", "option": "m_alter_role_option_identified_disable", "parameter_change": "m_alter_role_parameter_change_default", "with_keyword": "m_alter_role_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER ROLE m_b04_role_existing WITH IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
