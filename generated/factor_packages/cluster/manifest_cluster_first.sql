-- generated_from: manifest_cluster_first
-- static_only: true
-- case_count: 2

-- case_id: manifest_cluster_first_4347cd1fd6a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"index": "cluster_index_using", "target": "cluster_target_first", "verbose": "cluster_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cluster_fact_no_transaction"], "key": "autocommit_no_transaction"}, {"allowed_values": ["true"], "fact_refs": ["cluster_fact_disk"], "key": "cluster_disk_capacity_ready"}]
-- fixture_setup:
CREATE TABLE t_cluster_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_cluster_source VALUES (1, 2), (3, 4);
CREATE INDEX ix_cluster_source ON t_cluster_source USING btree (col_1);
-- test_sql:
CLUSTER t_cluster_source USING ix_cluster_source;
-- fixture_teardown:
DROP INDEX IF EXISTS ix_cluster_source;
DROP TABLE IF EXISTS t_cluster_source CASCADE;

-- case_id: manifest_cluster_first_c670070d8b41
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"index": "cluster_index_using", "target": "cluster_target_first", "verbose": "cluster_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cluster_fact_no_transaction"], "key": "autocommit_no_transaction"}, {"allowed_values": ["true"], "fact_refs": ["cluster_fact_disk"], "key": "cluster_disk_capacity_ready"}]
-- fixture_setup:
CREATE TABLE t_cluster_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_cluster_source VALUES (1, 2), (3, 4);
CREATE INDEX ix_cluster_source ON t_cluster_source USING btree (col_1);
-- test_sql:
CLUSTER VERBOSE t_cluster_source USING ix_cluster_source;
-- fixture_teardown:
DROP INDEX IF EXISTS ix_cluster_source;
DROP TABLE IF EXISTS t_cluster_source CASCADE;
