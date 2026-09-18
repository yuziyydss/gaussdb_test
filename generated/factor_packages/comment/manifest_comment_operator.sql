-- generated_from: manifest_comment_operator
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_operator_f2b4a03a1c9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_operator_ns;
CREATE FUNCTION g_comment_operator_ns.plus_one(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1 + 1;';
CREATE OPERATOR @#@ (PROCEDURE = g_comment_operator_ns.plus_one, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- test_sql:
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS 'factor note';
-- fixture_teardown:
DROP OPERATOR @#@ (INTEGER, INTEGER) RESTRICT;
DROP FUNCTION g_comment_operator_ns.plus_one(INTEGER);
DROP SCHEMA g_comment_operator_ns RESTRICT;

-- case_id: manifest_comment_operator_0572e2eea26d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_operator_ns;
CREATE FUNCTION g_comment_operator_ns.plus_one(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1 + 1;';
CREATE OPERATOR @#@ (PROCEDURE = g_comment_operator_ns.plus_one, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- test_sql:
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS '测试注释';
-- fixture_teardown:
DROP OPERATOR @#@ (INTEGER, INTEGER) RESTRICT;
DROP FUNCTION g_comment_operator_ns.plus_one(INTEGER);
DROP SCHEMA g_comment_operator_ns RESTRICT;

-- case_id: manifest_comment_operator_f4b5f0476e95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_operator_ns;
CREATE FUNCTION g_comment_operator_ns.plus_one(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1 + 1;';
CREATE OPERATOR @#@ (PROCEDURE = g_comment_operator_ns.plus_one, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- test_sql:
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS 'owner''s note';
-- fixture_teardown:
DROP OPERATOR @#@ (INTEGER, INTEGER) RESTRICT;
DROP FUNCTION g_comment_operator_ns.plus_one(INTEGER);
DROP SCHEMA g_comment_operator_ns RESTRICT;

-- case_id: manifest_comment_operator_4f2cae49f705
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_operator_ns;
CREATE FUNCTION g_comment_operator_ns.plus_one(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1 + 1;';
CREATE OPERATOR @#@ (PROCEDURE = g_comment_operator_ns.plus_one, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- test_sql:
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS NULL;
-- fixture_teardown:
DROP OPERATOR @#@ (INTEGER, INTEGER) RESTRICT;
DROP FUNCTION g_comment_operator_ns.plus_one(INTEGER);
DROP SCHEMA g_comment_operator_ns RESTRICT;
