-- generated_from: manifest_reindex_transaction_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_reindex_transaction_negative_503e3a5a04e4
-- expected: error
-- expected_error_category: reindex_concurrently_in_transaction
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"concurrently": "reindex_concurrently_yes", "force": "reindex_force_none", "target": "reindex_target_in_tx"}
-- fixture_setup:
CREATE TABLE t_reindex_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_reindex_source VALUES (1, 2), (3, 4);
CREATE INDEX i_reindex_tx ON t_reindex_source USING btree (col_1);
BEGIN;
-- test_sql:
REINDEX INDEX CONCURRENTLY i_reindex_tx;
-- fixture_teardown:
ROLLBACK;
DROP INDEX IF EXISTS i_reindex_tx;
DROP TABLE IF EXISTS t_reindex_source CASCADE;
