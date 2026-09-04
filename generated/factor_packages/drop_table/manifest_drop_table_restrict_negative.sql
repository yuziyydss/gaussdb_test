-- generated_from: manifest_drop_table_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_table_restrict_negative_b520f9cd3f3e
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: cannot be dropped because other objects depend on it
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_default", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE t_dt_dep_base;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_restrict_negative_2b74d382fdcd
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: cannot be dropped because other objects depend on it
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_restrict", "if_exists": "dt_if_present", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE IF EXISTS t_dt_dep_base RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_restrict_negative_a67c9669845c
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: cannot be dropped because other objects depend on it
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_restrict", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE t_dt_dep_base RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_restrict_negative_d8ca8ed87c25
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: cannot be dropped because other objects depend on it
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_default", "if_exists": "dt_if_present", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE IF EXISTS t_dt_dep_base;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
