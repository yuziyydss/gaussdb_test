-- generated_from: manifest_create_database_client_encoding_negative
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_database_client_encoding_negative_8f5372a3745b
-- expected: error
-- expected_error_category: database_encoding_not_server_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_big5", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'BIG5' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';

-- case_id: manifest_create_database_client_encoding_negative_d4235cb27c43
-- expected: error
-- expected_error_category: database_encoding_not_server_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_johab", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'JOHAB' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';

-- case_id: manifest_create_database_client_encoding_negative_d97316667492
-- expected: error
-- expected_error_category: database_encoding_not_server_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_sjis", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'SJIS' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';

-- case_id: manifest_create_database_client_encoding_negative_f8841252ca59
-- expected: error
-- expected_error_category: database_encoding_not_server_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_shift_jis_2004", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'SHIFT_JIS_2004' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';

-- case_id: manifest_create_database_client_encoding_negative_aac30560e915
-- expected: error
-- expected_error_category: database_encoding_not_server_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_uhc", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'UHC' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';
