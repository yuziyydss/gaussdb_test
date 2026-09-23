-- generated_from: manifest_m_load_data_column_expr_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_load_data_column_expr_negative_3ddc65a51b98
-- expected: error
-- expected_error_category: no_column_expr
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"assignment": "m_load_data_assignment_column", "column_list": "m_load_data_column_list_default", "conflict_mode": "m_load_data_conflict_mode_none", "fields": "m_load_data_fields_default", "skip": "m_load_data_skip_none", "table": "m_load_data_table_empty"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_load_data_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_load_data_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_load_data_fact_authority"], "key": "enable_copy_server_files"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["m_load_data_fact_path", "m_load_data_fact_server"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["m_load_data_fact_server", "m_load_data_fact_tab", "m_load_data_fact_line"], "fixture_id": "fixture_m_load_data_empty", "format": "integer_tsv", "id": "two_int", "repository_source_path": "specs/utility/m_load_data/fixtures/assets/two_int.tsv", "row_count": 3, "sha256": "5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01", "source_path": "assets/two_int.tsv", "target_path": "/tmp/m_factor_assets/load_data/two_int.tsv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);
-- test_sql:
LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' INTO TABLE m_load_data_empty LINES TERMINATED BY '
' SET qty = id;
-- fixture_teardown:
DROP TABLE m_load_data_empty;
