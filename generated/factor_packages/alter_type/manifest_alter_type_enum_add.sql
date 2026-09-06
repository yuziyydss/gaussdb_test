-- generated_from: manifest_alter_type_enum_add
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_type_enum_add_b300facdf1e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE 'changed';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;

-- case_id: manifest_alter_type_enum_add_fd50aa1f1b14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_yes", "owner": "alter_type_owner_current", "position": "alter_type_position_before"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE IF NOT EXISTS 'changed' BEFORE 'closed';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;

-- case_id: manifest_alter_type_enum_add_d379d8cd1034
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_after"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE 'changed' AFTER 'open';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;

-- case_id: manifest_alter_type_enum_add_a1d32e16b5f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_no", "owner": "alter_type_owner_current", "position": "alter_type_position_before"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE 'changed' BEFORE 'closed';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;

-- case_id: manifest_alter_type_enum_add_1eed01785c70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_yes", "owner": "alter_type_owner_current", "position": "alter_type_position_append"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE IF NOT EXISTS 'changed';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;

-- case_id: manifest_alter_type_enum_add_d70213af9cfa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"actions": "alter_type_actions_add", "behavior": "alter_type_behavior_default", "form": "alter_type_form_enum_add", "if_not_exists": "alter_type_if_not_exists_yes", "owner": "alter_type_owner_current", "position": "alter_type_position_after"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_type_fact_privilege"], "key": "type_alter_authorized"}]
-- fixture_setup:
CREATE TYPE type_enum_alter_b7 AS ENUM ('open', 'closed');
-- test_sql:
ALTER TYPE type_enum_alter_b7 ADD VALUE IF NOT EXISTS 'changed' AFTER 'open';
-- fixture_teardown:
DROP TYPE IF EXISTS type_enum_alter_b7;
