-- generated_from: manifest_comment_trigger
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_trigger_36b70ea1e453
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_trigger_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_trigger_owner"], "fact_refs": ["drop_trigger::drop_trigger_fact_permission"], "key": "cleanup_trigger"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_trigger_ns;
CREATE TABLE g_comment_trigger_ns.base_table (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
CREATE FUNCTION g_comment_trigger_ns.comment_trigger_fn() RETURNS TRIGGER LANGUAGE plpgsql AS 'BEGIN RETURN NEW; END;';
CREATE TRIGGER fp_comment_trigger BEFORE INSERT ON g_comment_trigger_ns.base_table FOR EACH ROW EXECUTE PROCEDURE g_comment_trigger_ns.comment_trigger_fn();
-- test_sql:
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table IS 'factor note';
-- fixture_teardown:
DROP TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table RESTRICT;
DROP FUNCTION g_comment_trigger_ns.comment_trigger_fn() RESTRICT;
DROP TABLE g_comment_trigger_ns.base_table RESTRICT;
DROP SCHEMA g_comment_trigger_ns RESTRICT;

-- case_id: manifest_comment_trigger_5d0c8cbe6b51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_trigger_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_trigger_owner"], "fact_refs": ["drop_trigger::drop_trigger_fact_permission"], "key": "cleanup_trigger"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_trigger_ns;
CREATE TABLE g_comment_trigger_ns.base_table (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
CREATE FUNCTION g_comment_trigger_ns.comment_trigger_fn() RETURNS TRIGGER LANGUAGE plpgsql AS 'BEGIN RETURN NEW; END;';
CREATE TRIGGER fp_comment_trigger BEFORE INSERT ON g_comment_trigger_ns.base_table FOR EACH ROW EXECUTE PROCEDURE g_comment_trigger_ns.comment_trigger_fn();
-- test_sql:
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table IS '测试注释';
-- fixture_teardown:
DROP TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table RESTRICT;
DROP FUNCTION g_comment_trigger_ns.comment_trigger_fn() RESTRICT;
DROP TABLE g_comment_trigger_ns.base_table RESTRICT;
DROP SCHEMA g_comment_trigger_ns RESTRICT;

-- case_id: manifest_comment_trigger_12717f4a1d81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_trigger_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_trigger_owner"], "fact_refs": ["drop_trigger::drop_trigger_fact_permission"], "key": "cleanup_trigger"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_trigger_ns;
CREATE TABLE g_comment_trigger_ns.base_table (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
CREATE FUNCTION g_comment_trigger_ns.comment_trigger_fn() RETURNS TRIGGER LANGUAGE plpgsql AS 'BEGIN RETURN NEW; END;';
CREATE TRIGGER fp_comment_trigger BEFORE INSERT ON g_comment_trigger_ns.base_table FOR EACH ROW EXECUTE PROCEDURE g_comment_trigger_ns.comment_trigger_fn();
-- test_sql:
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table IS 'owner''s note';
-- fixture_teardown:
DROP TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table RESTRICT;
DROP FUNCTION g_comment_trigger_ns.comment_trigger_fn() RESTRICT;
DROP TABLE g_comment_trigger_ns.base_table RESTRICT;
DROP SCHEMA g_comment_trigger_ns RESTRICT;

-- case_id: manifest_comment_trigger_6759a6feb55b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_trigger_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_trigger_owner"], "fact_refs": ["drop_trigger::drop_trigger_fact_permission"], "key": "cleanup_trigger"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_trigger_ns;
CREATE TABLE g_comment_trigger_ns.base_table (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);
CREATE FUNCTION g_comment_trigger_ns.comment_trigger_fn() RETURNS TRIGGER LANGUAGE plpgsql AS 'BEGIN RETURN NEW; END;';
CREATE TRIGGER fp_comment_trigger BEFORE INSERT ON g_comment_trigger_ns.base_table FOR EACH ROW EXECUTE PROCEDURE g_comment_trigger_ns.comment_trigger_fn();
-- test_sql:
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table IS NULL;
-- fixture_teardown:
DROP TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table RESTRICT;
DROP FUNCTION g_comment_trigger_ns.comment_trigger_fn() RESTRICT;
DROP TABLE g_comment_trigger_ns.base_table RESTRICT;
DROP SCHEMA g_comment_trigger_ns RESTRICT;
