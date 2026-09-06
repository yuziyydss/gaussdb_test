-- generated_from: manifest_comment_table_and_columns
-- static_only: true
-- case_count: 12

-- case_id: manifest_comment_table_and_columns_940aca7c4d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_table", "text": "comment_text_plain"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON TABLE t_comment_source IS 'factor note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_68443cbcba12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_table", "text": "comment_text_unicode"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON TABLE t_comment_source IS '测试注释';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_bc5328f9daa0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_table", "text": "comment_text_quote"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON TABLE t_comment_source IS 'owner''s note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_894923e6799a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_table", "text": "comment_text_null"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON TABLE t_comment_source IS NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_431646565d46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c1", "text": "comment_text_plain"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_1 IS 'factor note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_6f83a1a8623a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c1", "text": "comment_text_unicode"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_1 IS '测试注释';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_6bad935fc350
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c1", "text": "comment_text_quote"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_1 IS 'owner''s note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_bc1c1e73644a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c1", "text": "comment_text_null"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_1 IS NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_737628106160
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c2", "text": "comment_text_plain"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_2 IS 'factor note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_4c839d1a7afd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c2", "text": "comment_text_unicode"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_2 IS '测试注释';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_fca6761d928f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c2", "text": "comment_text_quote"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_2 IS 'owner''s note';
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;

-- case_id: manifest_comment_table_and_columns_addbb0b9fd68
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_c2", "text": "comment_text_null"}
-- fixture_setup:
CREATE TABLE t_comment_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_comment_source VALUES (1, 2), (3, 4);
-- test_sql:
COMMENT ON COLUMN t_comment_source.col_2 IS NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_comment_source CASCADE;
