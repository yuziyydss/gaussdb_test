-- generated_from: manifest_grant_object_all_positive
-- static_only: true
-- case_count: 39

-- case_id: manifest_grant_object_all_positive_60319d774021
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_51bdcb6e30a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_66bb4ac7849b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_b2086089b52c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES (col_1, col_2) ON grant_schema.grant_table TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_09efb973c89f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_65dae3ac1eba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES (col_1, col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_9587a7fb3e14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_a53bc15b8116
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SEQUENCE grant_schema.grant_seq TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_dc656bd939cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_1d19255c4df1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_545c334cc5c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_1c80c623329b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_8e5bcc148281
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_364c08a1f1ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_c685b5d8ec25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL (col_1, col_2) ON grant_schema.grant_table TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_0a32fc2ef2dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_780d65ed25d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON ALL TABLES IN SCHEMA grant_schema TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_f07a4cf0ddab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON grant_schema.grant_seq TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_4f8d51d8776a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON TABLE grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_6c99b2eac986
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_d0a7d54afdfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON SEQUENCE grant_schema.grant_seq TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_b3888236052f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_60141e4da1de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON LARGE SEQUENCE grant_schema.grant_seq TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_390a7408b00e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA grant_schema TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_9b56c801b246
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES ON SCHEMA grant_schema TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_e2ac57bc6726
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES (col_1, col_2) ON TABLE grant_schema.grant_table TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_f8c603b82b0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL PRIVILEGES (col_1, col_2) ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_8ea3d556401d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON TABLE grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_f65ef281932f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_5caa008e1489
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_70246210d667
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_825095688d7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SEQUENCE grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_729ed24f5ae3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON grant_schema.grant_seq TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_46cb3e88ad76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_338dd08cf09c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_e464d177066c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_372d22c43b01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_all", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL ON SCHEMA grant_schema TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_8bbb73c92183
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_positive_1ba58ff5ba7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment"], "key": "executor_role"}, {"allowed_values": ["preprovisioned"], "fact_refs": ["grant_fact_existing_identifiers"], "key": "grant_named_principals"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE
