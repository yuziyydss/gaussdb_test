-- generated_from: manifest_drop_resource_label_existing
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_resource_label_existing_094406f0cbdc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_label_if_exists_none", "names": "drop_resource_label_names_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
-- test_sql:
DROP RESOURCE LABEL b9_rl_a;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_resource_label_existing_729388652871
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_label_if_exists_none", "names": "drop_resource_label_names_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
-- test_sql:
DROP RESOURCE LABEL b9_rl_a, b9_rl_b;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_resource_label_existing_399041171727
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_label_if_exists_yes", "names": "drop_resource_label_names_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
-- test_sql:
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_resource_label_existing_dc49c845aafb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_label_if_exists_yes", "names": "drop_resource_label_names_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
-- test_sql:
DROP RESOURCE LABEL IF EXISTS b9_rl_a, b9_rl_b;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
