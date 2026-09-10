-- generated_from: manifest_create_database_server_encoding_c
-- static_only: true
-- case_count: 37

-- case_id: manifest_create_database_server_encoding_c_c6e20c0b7b73
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_euc_cn_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'EUC_CN' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_cba8610516b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_euc_jp_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'EUC_JP' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_9e6c2ddc70e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_euc_jis_2004_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'EUC_JIS_2004' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_f389925281c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_euc_kr_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'EUC_KR' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_3efbb2ab7ea5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_euc_tw_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'EUC_TW' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_8ea64bacbd29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_gb18030_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'GB18030' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_af4f230aa6e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_gb18030_2022_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'GB18030_2022' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_a4f99f8a0cc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_gbk_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'GBK' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_814b40a6e765
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_iso_8859_5_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'ISO_8859_5' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_9f975a9d1b85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_iso_8859_6_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'ISO_8859_6' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_01bf878929d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_iso_8859_7_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'ISO_8859_7' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_c0bfe9c16d0d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_iso_8859_8_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'ISO_8859_8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_35b09845822c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_koi8r_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'KOI8R' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_048c8be76bfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_koi8u_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'KOI8U' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_bb1aae0fec2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin2_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN2' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_35ac4a306952
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin3_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN3' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_6fdd26660471
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin4_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN4' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_7ab06b2e42a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin5_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN5' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_544b4a170ca3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin6_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN6' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_ac0fbd78df8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin7_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN7' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_f4b8cddac4ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin8_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_bc45f0c0dd87
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin9_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN9' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_2ede1f48ffe8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_latin10_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'LATIN10' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_8da00fe33768
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_mule_internal_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'MULE_INTERNAL' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_1597cf0f0a72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_sql_ascii_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'SQL_ASCII' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_8311e27ae969
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win866_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN866' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_547ff2d6f8d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win874_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN874' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_354fde0508c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1250_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1250' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_1be7132feae7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1251_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1251' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_c5aaf1d227ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1252_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1252' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_8bca757caf40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1253_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1253' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_fb80ca14fa98
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1254_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1254' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_dd1fd52b1492
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1255_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1255' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_c1d1cb594219
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1256_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1256' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_312ea5665daa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1257_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1257' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_db6f47aed652
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_win1258_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'WIN1258' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;

-- case_id: manifest_create_database_server_encoding_c_f7fe9d00bffc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "create_database_connection_limit_nminus1", "encoding": "create_database_encoding_zhs16gbk_c_template0", "equals": "create_database_equals_equal", "with_keyword": "create_database_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_database_fact_privilege"], "key": "createdb_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["create_database_fact_template_upgrade"], "key": "template_upgrade_in_progress"}, {"allowed_values": ["b8_database"], "fact_refs": ["create_database_fact_privilege"], "key": "isolated_database_name_available"}, {"allowed_values": ["C"], "fact_refs": ["create_database_fact_c_posix"], "key": "locale_available"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "database_recyclebin"}, {"allowed_values": ["none"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "target_database_connections"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';
-- test_sql:
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'ZHS16GBK' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
-- fixture_teardown:
DROP DATABASE b8_database;
