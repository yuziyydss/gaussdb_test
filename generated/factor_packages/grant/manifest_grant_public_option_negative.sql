-- generated_from: manifest_grant_public_option_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_grant_public_option_negative_6ef53ee2664d
-- expected: error
-- expected_error_category: grant_option_not_allowed_for_public
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_with_grant", "object_grantee": "grant_grantee_public", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_object", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- fixture_setup:
DROP SCHEMA IF EXISTS grant_schema CASCADE
CREATE SCHEMA grant_schema
CREATE TABLE grant_schema.grant_table (col_1 INTEGER NOT NULL, col_2 INTEGER)
CREATE TABLE grant_schema.grant_table_two (col_1 INTEGER NOT NULL, col_2 INTEGER)
INSERT INTO grant_schema.grant_table VALUES (1, 10), (2, 20)
INSERT INTO grant_schema.grant_table_two VALUES (1, 100), (2, 200)
CREATE SEQUENCE grant_schema.grant_seq
CREATE SEQUENCE grant_schema.grant_seq_two
-- test_sql:
GRANT SELECT ON TABLE grant_schema.grant_table TO PUBLIC WITH GRANT OPTION;
-- fixture_teardown:
DROP SCHEMA IF EXISTS grant_schema CASCADE
