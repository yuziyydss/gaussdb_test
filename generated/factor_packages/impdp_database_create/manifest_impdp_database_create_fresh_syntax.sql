-- generated_from: manifest_impdp_database_create_fresh_syntax
-- static_only: true
-- case_count: 4

-- case_id: manifest_impdp_database_create_fresh_syntax_10f76004459a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"db_name": "impdp_database_create_db_name_keep", "directory": "impdp_database_create_directory_path", "local": "impdp_database_create_local_new_cluster", "owner": "impdp_database_create_owner_dedicated"}
-- test_sql:
IMPDP DATABASE CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;

-- case_id: manifest_impdp_database_create_fresh_syntax_345b5a979cb3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"db_name": "impdp_database_create_db_name_rename", "directory": "impdp_database_create_directory_path", "local": "impdp_database_create_local_same_cluster", "owner": "impdp_database_create_owner_dedicated"}
-- test_sql:
IMPDP DATABASE b8_import_db CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;

-- case_id: manifest_impdp_database_create_fresh_syntax_d9512e42346c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"db_name": "impdp_database_create_db_name_keep", "directory": "impdp_database_create_directory_path", "local": "impdp_database_create_local_same_cluster", "owner": "impdp_database_create_owner_dedicated"}
-- test_sql:
IMPDP DATABASE CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;

-- case_id: manifest_impdp_database_create_fresh_syntax_d2d25a342be7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"db_name": "impdp_database_create_db_name_rename", "directory": "impdp_database_create_directory_path", "local": "impdp_database_create_local_new_cluster", "owner": "impdp_database_create_owner_dedicated"}
-- test_sql:
IMPDP DATABASE b8_import_db CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;
