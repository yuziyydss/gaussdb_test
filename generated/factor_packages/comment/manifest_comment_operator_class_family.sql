-- generated_from: manifest_comment_operator_class_family
-- static_only: true
-- case_count: 8

-- case_id: manifest_comment_operator_class_family_76b3bbb927a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_class_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass USING btree IS 'factor note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_f3b7ffb149f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_class_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass USING btree IS '测试注释';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_491cf83c2f60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_class_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass USING btree IS 'owner''s note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_da1191b8a9a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_class_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass USING btree IS NULL;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_fa5834264a25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_family_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR FAMILY g_comment_opclass_ns.g_comment_opclass USING btree IS 'factor note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_05b59586ac12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_family_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR FAMILY g_comment_opclass_ns.g_comment_opclass USING btree IS '测试注释';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_1dbc1481893e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_family_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR FAMILY g_comment_opclass_ns.g_comment_opclass USING btree IS 'owner''s note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_operator_class_family_913775661cc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_operator_family_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class::create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class::create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);
-- test_sql:
COMMENT ON OPERATOR FAMILY g_comment_opclass_ns.g_comment_opclass USING btree IS NULL;
-- fixture_teardown:
ROLLBACK;
