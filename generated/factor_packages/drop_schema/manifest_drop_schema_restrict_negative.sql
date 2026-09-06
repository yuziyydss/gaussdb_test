-- generated_from: manifest_drop_schema_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_schema_restrict_negative_a525215da6a8
-- expected: error
-- expected_error_category: schema_contains_objects
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_schema_behavior_default", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_occupied"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_two;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_restrict_negative_77a61894639c
-- expected: error
-- expected_error_category: schema_contains_objects
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_schema_behavior_restrict", "if_exists": "drop_schema_if_exists_absent", "targets": "drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA fp_cs_one, fp_cs_two RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_restrict_negative_01309a3323d3
-- expected: error
-- expected_error_category: schema_contains_objects
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_schema_behavior_default", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_cs_one, fp_cs_two;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_schema_restrict_negative_b97fbe81a73c
-- expected: error
-- expected_error_category: schema_contains_objects
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_schema_behavior_restrict", "if_exists": "drop_schema_if_exists_present", "targets": "drop_schema_targets_occupied"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_schema_fact_current"], "key": "search_path_excludes_test_schemas"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_ds_missing;
CREATE TABLE fp_cs_two.ds_probe (id INT);
-- test_sql:
DROP SCHEMA IF EXISTS fp_cs_two RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_two.ds_probe;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
