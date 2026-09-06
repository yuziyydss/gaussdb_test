-- generated_from: manifest_reindex_online
-- static_only: true
-- case_count: 4

-- case_id: manifest_reindex_online_6221032ab6cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_yes", "force": "reindex_force_none", "target": "reindex_target_index"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["reindex_fact_concurrent"], "key": "transaction_context"}, {"allowed_values": ["single_maintenance_job"], "fact_refs": ["reindex_fact_deadlock"], "key": "object_maintenance_exclusivity"}]
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX INDEX CONCURRENTLY i_reindex_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_online_a718a4a1dde7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_yes", "force": "reindex_force_yes", "target": "reindex_target_table"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["reindex_fact_concurrent"], "key": "transaction_context"}, {"allowed_values": ["single_maintenance_job"], "fact_refs": ["reindex_fact_deadlock"], "key": "object_maintenance_exclusivity"}]
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX TABLE CONCURRENTLY t_reindex_source FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_online_65413b29ffc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_yes", "force": "reindex_force_yes", "target": "reindex_target_index"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["reindex_fact_concurrent"], "key": "transaction_context"}, {"allowed_values": ["single_maintenance_job"], "fact_refs": ["reindex_fact_deadlock"], "key": "object_maintenance_exclusivity"}]
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX INDEX CONCURRENTLY i_reindex_source FORCE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;

-- case_id: manifest_reindex_online_2f5c83136632
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"concurrently": "reindex_concurrently_yes", "force": "reindex_force_none", "target": "reindex_target_table"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["reindex_fact_concurrent"], "key": "transaction_context"}, {"allowed_values": ["single_maintenance_job"], "fact_refs": ["reindex_fact_deadlock"], "key": "object_maintenance_exclusivity"}]
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_source ON t_reindex_source USING btree (col_1);
-- test_sql:
REINDEX TABLE CONCURRENTLY t_reindex_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_reindex_source;
DROP TABLE IF EXISTS t_reindex_source CASCADE;
