-- generated_from: manifest_alter_type_actions
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_type_actions_2d0606fbfdb8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 ADD ATTRIBUTE col_3 INTEGER;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_actions_f56eb1589cee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_two", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 ADD ATTRIBUTE col_3 INTEGER, ADD ATTRIBUTE col_4 TEXT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_actions_c956e77512eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_drop", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 DROP ATTRIBUTE col_2;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_actions_3ab12bc33856
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_drop_exists", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 DROP ATTRIBUTE IF EXISTS col_2;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_actions_bd67cde16073
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_type", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 ALTER ATTRIBUTE col_1 TYPE BIGINT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_actions_283faeadaab9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_set_type", "behavior": "alter_type_behavior_default", "form": "alter_type_form_actions", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 ALTER ATTRIBUTE col_1 SET DATA TYPE BIGINT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
