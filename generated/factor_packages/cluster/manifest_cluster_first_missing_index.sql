-- generated_from: manifest_cluster_first_missing_index
-- static_only: true
-- case_count: 1

-- case_id: manifest_cluster_first_missing_index_80418bf0a878
-- expected: error
-- expected_error_category: cluster_missing_recorded_index
-- expected_sqlstates: -
-- expected_error_regex: there is no previously clustered index for table ".*"
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"index": "cluster_index_none", "target": "cluster_target_unset", "verbose": "cluster_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cluster_fact_no_transaction"], "key": "autocommit_no_transaction"}, {"allowed_values": ["true"], "fact_refs": ["cluster_fact_disk"], "key": "cluster_disk_capacity_ready"}]
-- fixture_setup:
CREATE TABLE t_cluster_unset (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_cluster_unset VALUES (1, 2), (3, 4);
CREATE INDEX ix_cluster_unset ON t_cluster_unset USING btree (col_1);
-- test_sql:
CLUSTER t_cluster_unset;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cluster_unset CASCADE;
