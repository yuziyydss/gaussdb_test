-- generated_from: manifest_m_load_data_conflict
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_load_data_conflict_06043215bf65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_b797e3a29695
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_one", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_conflict FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' IGNORE 1 LINES (id, qty) SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_02da0728a344
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_one", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' IGNORE 1 LINES SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_76359be64db2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_conflict LINES TERMINATED BY '
' (id, qty) SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_c77168df1279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_7f2003acd45a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_conflict COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' (id, qty);
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_8c1a5dcea1aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_explicit", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_one", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict LINES TERMINATED BY '
' IGNORE 1 LINES (id, qty);
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_8f9aa1f6d6e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_ignore", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' IGNORE INTO TABLE m_load_data_conflict LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_d4479f09df62
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_none", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict FIELDS TERMINATED BY '	' LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_a1689adb34f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_integer", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_fields", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' SET qty = 40;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;

-- case_id: manifest_m_load_data_conflict_ca1649c4fa68
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "m_load_data_assignment_default", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_replace", "fields": "m_load_data_fields_columns", "skip": "m_load_data_skip_none", "table": "m_load_data_table_conflict"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_conflict", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_conflict (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
INSERT INTO m_load_data_conflict VALUES (2,99);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' REPLACE INTO TABLE m_load_data_conflict COLUMNS TERMINATED BY '	' LINES TERMINATED BY '
' SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_load_data_conflict;
