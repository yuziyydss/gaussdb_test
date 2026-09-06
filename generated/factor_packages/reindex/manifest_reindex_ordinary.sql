-- generated_from: manifest_reindex_ordinary
-- static_only: true
-- case_count: 6

-- case_id: manifest_reindex_ordinary_3abb6b0810cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_none", "target": "reindex_target_index"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX INDEX i_reindex_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_ordinary_7fae65d5ef54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_yes", "target": "reindex_target_table"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX TABLE t_reindex_source FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_ordinary_afb3971edeee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_none", "target": "reindex_target_in_tx"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_tx ON t_reindex_source USING btree (col_1);
BEGIN;
-- test_sql:
REINDEX INDEX i_reindex_tx;
-- fixture_teardown:
ROLLBACK;
DROP INDEX IF EXISTS i_reindex_tx;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_ordinary_e64259b3efc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_yes", "target": "reindex_target_index"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX INDEX i_reindex_source FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_ordinary_824a354bf898
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_none", "target": "reindex_target_table"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX TABLE t_reindex_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_ordinary_3e35f01ccec9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_none", "force": "reindex_force_yes", "target": "reindex_target_in_tx"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_tx ON t_reindex_source USING btree (col_1);
BEGIN;
-- test_sql:
REINDEX INDEX i_reindex_tx FORCE;
-- fixture_teardown:
ROLLBACK;
DROP INDEX IF EXISTS i_reindex_tx;
DROP TABLE IF EXISTS t_reindex_source CASCADE;
