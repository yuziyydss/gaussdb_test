-- generated_from: manifest_drop_table_basic_positive
-- static_only: true
-- case_count: 9

-- case_id: manifest_drop_table_basic_positive_04264c9ad214
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_default", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_single"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_base CASCADE;
CREATE TABLE t_dt_base (id INTEGER NOT NULL);
INSERT INTO t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE t_dt_base;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_base CASCADE;

-- case_id: manifest_drop_table_basic_positive_8d9fd982eb35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_restrict", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_present", "table_profile": "dt_table_schema_qualified"}
-- fixture_setup:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;
CREATE SCHEMA dt_fixture_schema;
CREATE TABLE dt_fixture_schema.t_dt_base (id INTEGER NOT NULL);
INSERT INTO dt_fixture_schema.t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE dt_fixture_schema.t_dt_base RESTRICT PURGE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;

-- case_id: manifest_drop_table_basic_positive_ce016cc986a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_present", "purge_clause": "dt_purge_present", "table_profile": "dt_table_single"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_base CASCADE;
CREATE TABLE t_dt_base (id INTEGER NOT NULL);
INSERT INTO t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE IF EXISTS t_dt_base CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_base CASCADE;

-- case_id: manifest_drop_table_basic_positive_2d82b5266f2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_restrict", "if_exists": "dt_if_present", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_one CASCADE;
DROP TABLE IF EXISTS t_dt_two CASCADE;
CREATE TABLE t_dt_one (id INTEGER NOT NULL);
CREATE TABLE t_dt_two (id INTEGER NOT NULL);
-- test_sql:
DROP TABLE IF EXISTS t_dt_one, t_dt_two RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_two CASCADE;
DROP TABLE IF EXISTS t_dt_one CASCADE;

-- case_id: manifest_drop_table_basic_positive_af74f74c94be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_schema_qualified"}
-- fixture_setup:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;
CREATE SCHEMA dt_fixture_schema;
CREATE TABLE dt_fixture_schema.t_dt_base (id INTEGER NOT NULL);
INSERT INTO dt_fixture_schema.t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE dt_fixture_schema.t_dt_base CASCADE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;

-- case_id: manifest_drop_table_basic_positive_d261ff968d8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_default", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_present", "table_profile": "dt_table_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_one CASCADE;
DROP TABLE IF EXISTS t_dt_two CASCADE;
CREATE TABLE t_dt_one (id INTEGER NOT NULL);
CREATE TABLE t_dt_two (id INTEGER NOT NULL);
-- test_sql:
DROP TABLE t_dt_one, t_dt_two PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_two CASCADE;
DROP TABLE IF EXISTS t_dt_one CASCADE;

-- case_id: manifest_drop_table_basic_positive_82d2dfb53b58
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_default", "if_exists": "dt_if_present", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_schema_qualified"}
-- fixture_setup:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;
CREATE SCHEMA dt_fixture_schema;
CREATE TABLE dt_fixture_schema.t_dt_base (id INTEGER NOT NULL);
INSERT INTO dt_fixture_schema.t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE IF EXISTS dt_fixture_schema.t_dt_base;
-- fixture_teardown:
DROP SCHEMA IF EXISTS dt_fixture_schema CASCADE;

-- case_id: manifest_drop_table_basic_positive_97a8a0dbdf59
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_restrict", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_single"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_base CASCADE;
CREATE TABLE t_dt_base (id INTEGER NOT NULL);
INSERT INTO t_dt_base (id) VALUES (1);
-- test_sql:
DROP TABLE t_dt_base RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_base CASCADE;

-- case_id: manifest_drop_table_basic_positive_343ad4a6a261
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_one CASCADE;
DROP TABLE IF EXISTS t_dt_two CASCADE;
CREATE TABLE t_dt_one (id INTEGER NOT NULL);
CREATE TABLE t_dt_two (id INTEGER NOT NULL);
-- test_sql:
DROP TABLE t_dt_one, t_dt_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_dt_two CASCADE;
DROP TABLE IF EXISTS t_dt_one CASCADE;
