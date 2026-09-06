-- generated_from: manifest_drop_database_existing
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_database_existing_42a34ddeecea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_if_exists_none", "purge": "drop_database_purge_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_database_fact_privilege"], "key": "drop_database_authorized"}, {"allowed_values": ["true"], "fact_refs": ["drop_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["drop_database_fact_no_connections"], "key": "test_database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["b8_database"], "fact_refs": ["drop_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
DROP DATABASE b8_database;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_drop_database_existing_15fbcd177c25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_if_exists_none", "purge": "drop_database_purge_purge"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_database_fact_privilege"], "key": "drop_database_authorized"}, {"allowed_values": ["true"], "fact_refs": ["drop_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["drop_database_fact_no_connections"], "key": "test_database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["b8_database"], "fact_refs": ["drop_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
DROP DATABASE b8_database PURGE;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_drop_database_existing_4e2a231de30f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_if_exists_yes", "purge": "drop_database_purge_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_database_fact_privilege"], "key": "drop_database_authorized"}, {"allowed_values": ["true"], "fact_refs": ["drop_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["drop_database_fact_no_connections"], "key": "test_database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["b8_database"], "fact_refs": ["drop_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
DROP DATABASE IF EXISTS b8_database;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;

-- case_id: manifest_drop_database_existing_2c09acef7d3d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_if_exists_yes", "purge": "drop_database_purge_purge"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_database_fact_privilege"], "key": "drop_database_authorized"}, {"allowed_values": ["true"], "fact_refs": ["drop_database_fact_no_transaction"], "key": "autocommit_no_transaction_block"}, {"allowed_values": ["false"], "fact_refs": ["drop_database_fact_no_connections"], "key": "test_database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["b8_database"], "fact_refs": ["drop_database_fact_privilege"], "key": "exclusive_test_database"}]
-- fixture_setup:
CREATE DATABASE b8_database TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG';
-- test_sql:
DROP DATABASE IF EXISTS b8_database PURGE;
-- fixture_teardown:
DROP DATABASE IF EXISTS b8_database PURGE;
