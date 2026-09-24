-- generated_from: manifest_alter_schema_nonempty_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_schema_nonempty_negative_340d981b77bd
-- expected: error
-- expected_error_category: schema_contains_tables
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action": "alter_schema_action_with", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_occupied"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_schema_fact_ledger_gate"], "key": "enable_ledger"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_as_occupied WITH BLOCKCHAIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_nonempty_negative_89b212b57970
-- expected: error
-- expected_error_category: schema_contains_tables
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action": "alter_schema_action_without", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_occupied"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_schema_fact_ledger_gate"], "key": "enable_ledger"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_as_occupied WITHOUT BLOCKCHAIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
