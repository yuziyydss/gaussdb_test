-- generated_from: manifest_create_resource_label_resources
-- static_only: true
-- case_count: 16

-- case_id: manifest_create_resource_label_resources_447b2d1d258f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD TABLE (b9_rl_source);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_ca444ed8b7d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_two_tables"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD TABLE (b9_rl_source, b9_rl_source_two);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_92fcbbe8cfea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_column"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD COLUMN (b9_rl_source.col_1);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_737251342070
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_two_columns"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD COLUMN (b9_rl_source.col_1, b9_rl_source.col_2);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_04121ee20d48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_schema"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD SCHEMA (fp_cs_one);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_6b44146d1d2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_view"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD VIEW (b9_rl_view);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_96b34137f061
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_function"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD FUNCTION (b9_rl_fn);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_a197b17443bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_none", "items": "create_resource_label_items_mixed"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL b9_rl_new ADD TABLE (b9_rl_source), COLUMN (b9_rl_source_two.col_1);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_5b3f8e2967fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD TABLE (b9_rl_source);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_72a9d4221f5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_two_tables"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD TABLE (b9_rl_source, b9_rl_source_two);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_6734a029a532
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_column"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD COLUMN (b9_rl_source.col_1);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_4ae65b60b50b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_two_columns"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD COLUMN (b9_rl_source.col_1, b9_rl_source.col_2);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_b8dcf5349f1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_schema"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD SCHEMA (fp_cs_one);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_5727a81d450f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_view"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD VIEW (b9_rl_view);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_57c51100f50f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_function"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD FUNCTION (b9_rl_fn);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_resource_label_resources_5ca2bfe7b296
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_resource_label_if_not_exists_yes", "items": "create_resource_label_items_mixed"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS b9_rl_new ADD TABLE (b9_rl_source), COLUMN (b9_rl_source_two.col_1);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
