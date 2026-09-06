-- generated_from: manifest_alter_type_attribute
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_type_attribute_a26da9ff9503
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_attribute", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 RENAME ATTRIBUTE col_1 TO col_1_new;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_attribute_61654e0019cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_cascade", "form": "alter_type_form_attribute", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 RENAME ATTRIBUTE col_1 TO col_1_new CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_attribute_5d20bb7f14ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_restrict", "form": "alter_type_form_attribute", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 RENAME ATTRIBUTE col_1 TO col_1_new RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
