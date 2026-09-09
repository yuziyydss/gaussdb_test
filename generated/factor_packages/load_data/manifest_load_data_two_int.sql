-- generated_from: manifest_load_data_two_int
-- static_only: true
-- case_count: 2

-- case_id: manifest_load_data_two_int_6e71ac1ecb46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_list": "load_data_columns_omitted"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["load_data_fact_body_8"], "key": "compatibility_mode"}, {"allowed_values": ["5.7"], "fact_refs": ["load_data_fact_body_10"], "key": "b_format_version"}, {"allowed_values": ["s2"], "fact_refs": ["load_data_fact_body_10"], "key": "b_format_dev_version"}, {"allowed_values": ["fixture_table_creator_with_insert_delete"], "fact_refs": ["load_data_fact_body_13"], "key": "table_authority"}, {"allowed_values": ["sysadmin"], "fact_refs": ["copy::copy_fact_body_10"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["copy::copy_fact_body_10"], "key": "enable_copy_server_files"}, {"allowed_values": ["non_pdb"], "fact_refs": ["copy::copy_fact_body_16_3"], "key": "database_scope"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["load_data_fact_body_12", "copy::copy_fact_body_16"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["load_data_fact_body_57", "copy::copy_fact_body_16"], "fixture_id": "fixture_load_data_two_int", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/factor_assets/general/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE g_load_data_two_int (id INTEGER,qty INTEGER);
-- test_sql:
LOAD DATA INFILE '/tmp/factor_assets/general/load_data/two_int.tsv' INTO TABLE g_load_data_two_int FIELDS TERMINATED BY '	' LINES TERMINATED BY '
';
-- fixture_teardown:
DROP TABLE g_load_data_two_int;

-- case_id: manifest_load_data_two_int_b00f553e860e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_list": "load_data_columns_explicit"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["load_data_fact_body_8"], "key": "compatibility_mode"}, {"allowed_values": ["5.7"], "fact_refs": ["load_data_fact_body_10"], "key": "b_format_version"}, {"allowed_values": ["s2"], "fact_refs": ["load_data_fact_body_10"], "key": "b_format_dev_version"}, {"allowed_values": ["fixture_table_creator_with_insert_delete"], "fact_refs": ["load_data_fact_body_13"], "key": "table_authority"}, {"allowed_values": ["sysadmin"], "fact_refs": ["copy::copy_fact_body_10"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["copy::copy_fact_body_10"], "key": "enable_copy_server_files"}, {"allowed_values": ["non_pdb"], "fact_refs": ["copy::copy_fact_body_16_3"], "key": "database_scope"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["load_data_fact_body_12", "copy::copy_fact_body_16"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["load_data_fact_body_57", "copy::copy_fact_body_16"], "fixture_id": "fixture_load_data_two_int", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/factor_assets/general/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE g_load_data_two_int (id INTEGER,qty INTEGER);
-- test_sql:
LOAD DATA INFILE '/tmp/factor_assets/general/load_data/two_int.tsv' INTO TABLE g_load_data_two_int FIELDS TERMINATED BY '	' LINES TERMINATED BY '
' (id,qty);
-- fixture_teardown:
DROP TABLE g_load_data_two_int;
