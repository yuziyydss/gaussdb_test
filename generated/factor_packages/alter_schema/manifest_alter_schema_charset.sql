-- generated_from: manifest_alter_schema_charset
-- static_only: true
-- case_count: 8

-- case_id: manifest_alter_schema_charset_20c3d315b229
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_0416b55a7951
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_short", "collation": "alter_schema_collation_default", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARSET = utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_3f8f1e5510fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_absent", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARACTER SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_4caffa289a3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_absent", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_8369909c3a7d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_set", "collation": "alter_schema_collation_default", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARACTER SET utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_8ff2dca6d1fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_short", "collation": "alter_schema_collation_plain", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARSET = utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_1cfd4584a0fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_short", "collation": "alter_schema_collation_absent", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one CHARSET = utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_schema_charset_40ba5328ce10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_schema_action_charset", "charset": "alter_schema_charset_absent", "collation": "alter_schema_collation_default", "new_name": "alter_schema_new_name_new", "new_owner": "alter_schema_new_owner_role", "schema_name": "alter_schema_schema_name_empty"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_schema_fact_compatibility"], "key": "compatibility_mode"}, {"allowed_values": ["UTF8"], "fact_refs": ["alter_schema_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP SCHEMA IF EXISTS fp_as_renamed;
CREATE SCHEMA fp_as_occupied;
CREATE TABLE fp_as_occupied.t (id INT);
-- test_sql:
ALTER SCHEMA fp_cs_one DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_as_renamed CASCADE;
DROP SCHEMA IF EXISTS fp_as_occupied CASCADE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
