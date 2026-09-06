-- generated_from: manifest_create_database_encoding_limit
-- static_only: true
-- case_count: 8

-- case_id: manifest_create_database_encoding_limit_5e39d6da0f84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_utf8", "equals": "create_database_equals_none", "with_keyword": "create_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT -1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_827e3c0d6b81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n0", "encoding": "create_database_encoding_latin1", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'LATIN1' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = 0;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_637951847581
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n1", "encoding": "create_database_encoding_latin1", "equals": "create_database_equals_none", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING 'LATIN1' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT 1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_0273e44d8e66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n2147483647", "encoding": "create_database_encoding_utf8", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = 2147483647;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_aaa3df80be10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n2147483647", "encoding": "create_database_encoding_latin1", "equals": "create_database_equals_none", "with_keyword": "create_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING 'LATIN1' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT 2147483647;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_84c2ac41fbbb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n1", "encoding": "create_database_encoding_utf8", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = 1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_f585be0a2e34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_n0", "encoding": "create_database_encoding_utf8", "equals": "create_database_equals_none", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT 0;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_create_database_encoding_limit_75d6e703a1fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin1", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN1' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;
