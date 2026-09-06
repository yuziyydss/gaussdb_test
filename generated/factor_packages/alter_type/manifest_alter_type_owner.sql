-- generated_from: manifest_alter_type_owner
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_type_owner_2e4d5f1e85c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_owner", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 OWNER TO CURRENT_USER;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_type_owner_d2b991ce3efb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_owner", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_session", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
CREATE SCHEMA type_b7_target;
-- test_sql:
ALTER TYPE type_comp_b7 OWNER TO SESSION_USER;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
