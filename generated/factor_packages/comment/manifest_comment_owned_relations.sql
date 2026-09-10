-- generated_from: manifest_comment_owned_relations
-- static_only: true
-- case_count: 12

-- case_id: manifest_comment_owned_relations_da68b5dfda33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_index_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON INDEX g_comment_rel_idx IS 'factor note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_3b2423e80814
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_index_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON INDEX g_comment_rel_idx IS '测试注释';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_b35b86d666c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_index_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON INDEX g_comment_rel_idx IS 'owner''s note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_b353c9679493
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_index_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON INDEX g_comment_rel_idx IS NULL;
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_982ccc5b33e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON VIEW g_comment_rel_view IS 'factor note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_13cc0c373452
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON VIEW g_comment_rel_view IS '测试注释';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_1b5778c58a56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON VIEW g_comment_rel_view IS 'owner''s note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_767469a8bad3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON VIEW g_comment_rel_view IS NULL;
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_b8794845382f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_column_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON COLUMN g_comment_rel_view.col_1 IS 'factor note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_32ac4dde68bd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_column_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON COLUMN g_comment_rel_view.col_1 IS '测试注释';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_21c9ab001389
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_column_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON COLUMN g_comment_rel_view.col_1 IS 'owner''s note';
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;

-- case_id: manifest_comment_owned_relations_b405efcf5f79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_view_column_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["fixture_table_owner_with_create_index_authority"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "index_create_authority"}, {"allowed_values": ["create_any_table_in_owned_user_schema"], "fact_refs": ["create_view::cv_fact_create_any_table_permission"], "key": "view_create_authority"}]
-- fixture_setup:
CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);
CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);
CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;
-- test_sql:
COMMENT ON COLUMN g_comment_rel_view.col_1 IS NULL;
-- fixture_teardown:
DROP VIEW g_comment_rel_view;
DROP INDEX g_comment_rel_idx;
DROP TABLE g_comment_rel_base;
