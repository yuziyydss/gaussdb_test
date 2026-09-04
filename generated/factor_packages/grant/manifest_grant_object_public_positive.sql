-- generated_from: manifest_grant_object_public_positive
-- static_only: true
-- case_count: 101

-- case_id: manifest_grant_object_public_positive_3cc3d6f355e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_1f75667e807d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_26d4e15f4b1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_dbd3d4dcc97a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_delete", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_a3b93929862d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9f8159372a33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e7d403c34a5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e2ae0b0d395a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_131adec3dd32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_create", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT CREATE ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_c55f3a9aed17
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_dc957404281b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_35b4c0dfdbdf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2e9618577700
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f4565e7aa589
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_979b351395ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_references", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f0b8779069ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9e0630e21d2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_index", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e03d7f8fca84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e65034eb8200
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f1f16c02297f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_53fa299fc5b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_be1de90aa1e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_38dbc91838a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_bffbd9e2ebe9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_576a2010c709
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_7edefaf560a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9c96acd80f9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_6858fc0a1975
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_68dd9c26470e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9350a87746a3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_insert", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2f74d689d76b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_insert", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_638d1d615d0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2b2910d81e02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_eea1cd706b85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_20fadf596010
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_1564d6057f8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_15471c1b625a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f47234856c58
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_bf699a15b310
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_update", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2f2af012f0ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_d5e5bd72c1f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_c8781392004e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_delete", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DELETE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_4448d32fa997
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_99d4d18eb9fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_4efff3560e67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_truncate", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRUNCATE ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_36141152757a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_references", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5087efd002de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_references", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_b4f3065aec65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_references", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_b6c22d525710
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_a6ea50747295
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_ff7afaa708db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_trigger", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT TRIGGER ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_b9082dc1f1cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_index", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9d02e9dc7a0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_index", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5c9d0363abf6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_index", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INDEX ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_57538c870e01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5fba6f3f246b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5d4c1f371046
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_vacuum", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT VACUUM ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_9fa025a9248f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_0bbe4fdf30b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f449029594a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_4927a3a59dad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5c94a0a4a82e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_fc57beafdcd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_4d0833437507
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_0520d8ea121f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_4c76bcef067b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_alter", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT ALTER ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_8fb9a2a36438
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_50fa85e9d886
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_3b09c78025fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_f0dddd296c99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e44ffd9ce72b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_24c9f6d253e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_42f84da49f01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2b00b1a83488
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_e1795f536136
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_drop", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT DROP ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_309bba3207b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_970cf235850c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_aa18baf1f08e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_d899e6762920
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_all_tables_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON ALL TABLES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_bfd1d0fc50d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_b6435eed3c43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_6e1b3d6db0a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_large_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON LARGE SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_52d3c2e48631
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_6d50bbc4f277
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_comment", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_eaea2e5cc68c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SEQUENCE grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_78662f8ca53c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON grant_schema.grant_seq TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_34c00b2001eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_sequence_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SEQUENCE grant_schema.grant_seq, grant_schema.grant_seq_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_6be6e75d5ed2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_all_sequences_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON ALL SEQUENCES IN SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_a886a176c96c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_usage", "object_target": "grant_target_schema", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT USAGE ON SCHEMA grant_schema TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_55aa3ac95e26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_390f53a8097c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_d469d12abc3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_ddda4bcc3d6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_insert", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT INSERT (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_8bacfd225fd9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON TABLE grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_5dea1d8e3f6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_update", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT UPDATE (col_2) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_82a50cdebe21
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_3e8145e53f37
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_references", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT REFERENCES (col_1) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_2278c39eb5eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_a04620f97d3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_comment", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT COMMENT (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_b676708c04ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table_bare", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON grant_schema.grant_table TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE

-- case_id: manifest_grant_object_public_positive_c9e757271aaf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_column_select_update", "object_target": "grant_target_column_table_pair", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
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
GRANT SELECT (col_1, col_2), UPDATE (col_2) ON TABLE grant_schema.grant_table, grant_schema.grant_table_two TO PUBLIC;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE
