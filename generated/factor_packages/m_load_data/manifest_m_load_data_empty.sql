-- generated_from: manifest_m_load_data_empty
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_load_data_empty_005f904071c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_none", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' INTO TABLE m_load_data_empty LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_ed437c736456
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_one", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_empty FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' IGNORE 1 LINES (id, qty) SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_4c072ad01c1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_one", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_empty COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' IGNORE 1 LINES SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_874c5dda904a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_none", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' INTO TABLE m_load_data_empty FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' (id, qty) SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_42343bebd29f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_empty COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_dd791bb46617
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_one", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_empty LINES TERMINATED BY '
' IGNORE 1 LINES (id, qty);
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_36b6a109ebfd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_none", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_one", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' INTO TABLE m_load_data_empty COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' IGNORE 1 LINES (id, qty);
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_42e6eb93eb8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_empty FIELDS TERMINATED BY '	' LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_a7e3f88e6220
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_empty LINES TERMINATED BY '
' SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_2a6e51bf00ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_none", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' INTO TABLE m_load_data_empty LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_e1f8f5005720
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_empty LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE m_load_data_empty;

-- case_id: manifest_m_load_data_empty_9a05f64d8221
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_empty LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_empty;
