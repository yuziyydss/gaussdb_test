-- generated_from: manifest_insert_common_type_a_integer
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_common_type_a_integer_7ce3bb8ef120
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_common_a_case_small_big", "target_profile": "insert_target_common_a_integer", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select::select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
CREATE TABLE a_common_target (result BIGINT);
-- test_sql:
INSERT INTO a_common_target (result) SELECT CASE WHEN TRUE THEN lo ELSE hi END AS result FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_target;
DROP TABLE a_common_source;

-- case_id: manifest_insert_common_type_a_integer_d73b514141a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_common_a_case_big_small", "target_profile": "insert_target_common_a_integer", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select::select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
CREATE TABLE a_common_target (result BIGINT);
-- test_sql:
INSERT INTO a_common_target (result) SELECT CASE WHEN TRUE THEN hi ELSE lo END AS result FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_target;
DROP TABLE a_common_source;
