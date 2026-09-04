-- generated_from: manifest_drop_table_cascade_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_table_cascade_positive_fcafc63ff6ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE t_dt_dep_base CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_cascade_positive_cf729a9a76df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_present", "purge_clause": "dt_purge_present", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE PURGE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_cascade_positive_344e61dc7f61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_absent", "purge_clause": "dt_purge_present", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE t_dt_dep_base CASCADE PURGE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;

-- case_id: manifest_drop_table_cascade_positive_d3481d033a43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "dt_dependency_cascade", "if_exists": "dt_if_present", "purge_clause": "dt_purge_absent", "table_profile": "dt_table_dependent_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
CREATE TABLE t_dt_dep_base (id INTEGER NOT NULL);
DROP VIEW IF EXISTS v_dt_dep;
CREATE VIEW v_dt_dep AS SELECT id FROM t_dt_dep_base;
-- test_sql:
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dt_dep;
DROP TABLE IF EXISTS t_dt_dep_base CASCADE;
