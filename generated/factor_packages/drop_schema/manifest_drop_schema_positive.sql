-- generated_from: manifest_drop_schema_positive
-- static_only: true
-- case_count: 11

-- case_id: manifest_drop_schema_positive_bf656452622e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_default", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_empty"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_one;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_6afb45d01ab5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_occupied"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_93f319940ca2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_default", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_missing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_ds_missing;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_c88300544207
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_restrict", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_empty"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_cs_one RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_c7f71283fe66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_cs_one, fp_cs_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_bbfc3683b883
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_restrict", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_empty"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_one RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_183c523e57c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_empty"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_one CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_fe23b419d31c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_one, fp_cs_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_7554ef1d2193
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_restrict", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_missing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_ds_missing RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_9b684f79f010
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_occupied"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_positive_aed83e136fc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_schema_behavior_cascade", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_missing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_ds_missing CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
