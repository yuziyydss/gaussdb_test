-- generated_from: manifest_grant_object_positive
-- static_only: true
-- case_count: 103

-- case_id: manifest_grant_object_positive_de6dc93e6978
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_0652fcc0a4b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8d9b0a7a8ba8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_update", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_a5ed203b4787
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_delete", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_61b87e3b2e20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SEQUENCE grant_schema.grant_seq TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_50b8faf4bc74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON grant_schema.grant_seq TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_51b894477659
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_c5f91279cbd3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_usage", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_dc7260b74234
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_create", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT CREATE ON SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1ebd38f46a69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_c4ca3166bfd9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_6f5960d0be0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_cb37214bcd9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON ALL SEQUENCES IN SCHEMA grant_schema TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_60842ec3c4ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON TABLE grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_43f916036467
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_references", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_37d4d961dbc9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_cf4514ca7960
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_index", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON ALL TABLES IN SCHEMA grant_schema TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_7cefc5d7960b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON TABLE grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_add955f3f758
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_37f53d425813
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_19dfc9ea1752
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON TABLE grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_e2c6a6d032cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON SEQUENCE grant_schema.grant_seq TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_5f05432d16e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_539b6e42498b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_7bc2992f7c5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON LARGE SEQUENCE grant_schema.grant_seq TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2235fc51e8c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_usage", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SCHEMA grant_schema TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_54f1219634d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_insert", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_e88694742d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON grant_schema.grant_seq TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_7eb8d0473711
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_101c49aba4e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_references", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_d9beb9cc3d34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON grant_schema.grant_table TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_91383cc5589a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON TABLE grant_schema.grant_table TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_229b29f4b51c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2e1b1e4e19fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON SEQUENCE grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_053ff44c18db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_54ff29f6beab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON TABLE grant_schema.grant_table TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2bc849c16126
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_index", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON TABLE grant_schema.grant_table TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_19638532d9eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON grant_schema.grant_table TO grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_16ef280a8d1c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_9a7b5ea1bd01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_c36def0228e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_comment", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_422afc8b8c4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_create", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT CREATE ON SCHEMA grant_schema TO grant_recipient, grant_recipient_two WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_3c2b081de671
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON TABLE grant_schema.grant_table TO GROUP grant_recipient WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1b3c41d4b918
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_df3e8a61ea91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8d44ce28af8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_select", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_183615f236f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_70e1fd76b545
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON TABLE grant_schema.grant_table TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4219e48fc492
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_b15b1e1511a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_references", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON TABLE grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_9467536dce6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_a9799f4d8144
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_index", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_a563c0952b2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_5f63e773c559
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SEQUENCE grant_schema.grant_seq TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_20b7deb8cf43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_23bedc8a608c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8a55b0b3d46e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8fd8e9bb2c8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_88eb6c52207b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_b1e073818da3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_two_roles", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON grant_schema.grant_table TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4f64ff4612a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_a03a5e0f114f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8458fb95182a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_ce49ba7e9d94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_831f80601b08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4122b3b11f6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_cc1ef91e9e02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_f58190da3b83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_eb4cf4276a78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2d3fc867e094
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_403bd5fd9da2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_cccea71a990c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_update", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_06d5dd32c616
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2db5a1a6632e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_dac834733228
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_references", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1130676fab8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_57c416f003f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_index", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_8e2a7addb10b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_f7143a202264
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4b475589425c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_fedeef5851e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_edaea8c4ebf7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4b0bd11e0e53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2d11b6b53030
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_6355d02d9053
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_alter", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_05d1085b6972
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4586d0088d10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2419fbaafc3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_dd33f6590483
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_f500e7293bf7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_44314e7aff3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON LARGE SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_817e5e4641ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_drop", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_25646720eac4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON TABLE grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1b584d275c4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON grant_schema.grant_table TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1d64106b5f50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_4fe94d07fb01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON ALL TABLES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_dc8f45bbaf18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SEQUENCE grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_6b4c8553a9f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_b851a8c0966c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_comment", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_1e463101fa8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON grant_schema.grant_seq TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_2e90961ea668
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_64e29c3e96c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_usage", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON ALL SEQUENCES IN SCHEMA grant_schema TO grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_positive_d34cf5001cc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_group_role", "object_privilege": "grant_priv_create", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT CREATE ON SCHEMA grant_schema TO GROUP grant_recipient;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE
