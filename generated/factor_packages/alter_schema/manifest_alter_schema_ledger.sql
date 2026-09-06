-- generated_from: manifest_alter_schema_ledger
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_schema_ledger_e943eb7f9f9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_with", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_schema_fact_ledger_gate"], "key": "enable_ledger"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one WITH BLOCKCHAIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_ledger_d69f60b13e29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_without", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_schema_fact_ledger_gate"], "key": "enable_ledger"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one WITHOUT BLOCKCHAIN;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
