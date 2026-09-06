-- generated_from: manifest_alter_database_limit
-- static_only: true
-- case_count: 10

-- case_id: manifest_alter_database_limit_602c6b097588
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_nminus1", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database CONNECTION LIMIT -1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_03fa28bef158
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n0", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database WITH CONNECTION LIMIT 0;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_3a8c4366476a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n1", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database CONNECTION LIMIT 1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_af82edafa481
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n50", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database CONNECTION LIMIT 50;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_1ece7d86a8a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n2147483647", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database CONNECTION LIMIT 2147483647;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_a873e6f6c26c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n0", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database CONNECTION LIMIT 0;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_f600c07a50b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_nminus1", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database WITH CONNECTION LIMIT -1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_22e5ee9c3c4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n1", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database WITH CONNECTION LIMIT 1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_b6152aef5027
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n50", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database WITH CONNECTION LIMIT 50;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_alter_database_limit_9a71a0960390
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_database_assignment_to", "form": "alter_database_form_limit", "limit": "alter_database_limit_n2147483647", "reset_target": "alter_database_reset_target_one", "value": "alter_database_value_postgres", "with_keyword": "alter_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_fact_privilege"], "key": "database_alter_authorized"}, {"allowed_values": ["true"], "fact_refs": ["alter_database_fact_rename_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["postgres"], "fact_refs": ["alter_database_fact_not_current_database"], "key": "connected_database"}, {"allowed_values": ["b8_database"], "fact_refs": ["alter_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
ALTER DATABASE b8_database WITH CONNECTION LIMIT 2147483647;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;
