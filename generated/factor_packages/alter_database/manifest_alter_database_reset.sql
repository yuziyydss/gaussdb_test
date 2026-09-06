-- generated_from: manifest_alter_database_reset
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_database_reset_c2b4adb098b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_reset", "limit": "alter_database_limit_nminus1", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database RESET DATESTYLE;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_reset_84635bdaeb7e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_reset", "limit": "alter_database_limit_nminus1", "reset_target": "alter_database_reset_target_all", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database RESET ALL;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;
