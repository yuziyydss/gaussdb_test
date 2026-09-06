-- generated_from: manifest_alter_type_enum_rename
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_type_enum_rename_8d6f5f607505
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_rename", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 RENAME VALUE 'closed' TO 'complete';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;
