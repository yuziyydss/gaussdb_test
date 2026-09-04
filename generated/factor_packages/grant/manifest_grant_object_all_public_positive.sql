-- generated_from: manifest_grant_object_all_public_positive
-- static_only: true
-- case_count: 26

-- case_id: manifest_grant_object_all_public_positive_731ba2887721
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_dcd6e25f78e8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_9bcf99fec6d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_5bb8bbec9871
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES (col_1, col_2) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_f7f0d1c0e012
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_f557333ae3f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_4ccc91ae51d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_9706d4a718ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_7509ecf0dc7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_b53dd83523b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_fe536c915c74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_65fd9fd4d523
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_4da06883625e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL (col_1, col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_aa640a775c8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_b913b4fe7379
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_19bdece80a64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_c3b5ce58e2fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_8c96aba6cd95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_d2ca5c2c7da2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_96359d2e47be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_df157caba3fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_8e1f9f4fdb7a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_49f369885c6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_all_privileges", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_45a66653a1ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL (col_1, col_2) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_b01c3a4344c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES (col_1, col_2) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_all_public_positive_1a73cb2b7b0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_all_privileges", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALL PRIVILEGES (col_1, col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE
