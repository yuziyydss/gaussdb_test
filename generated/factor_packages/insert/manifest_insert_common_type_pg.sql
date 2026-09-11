-- generated_from: manifest_insert_common_type_pg
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_common_type_pg_eef67fc6bcdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_common_case_integer", "target_profile": "insert_target_common_type", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
CREATE TABLE g_common_target (result INTEGER);
-- test_sql:
INSERT INTO g_common_target (result) SELECT CASE WHEN flag THEN id ELSE qty END AS result FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_target;
DROP TABLE g_common_source;

-- case_id: manifest_insert_common_type_pg_32a1d51b5924
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_common_union_integer", "target_profile": "insert_target_common_type", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
CREATE TABLE g_common_target (result INTEGER);
-- test_sql:
INSERT INTO g_common_target (result) SELECT id FROM g_common_source UNION SELECT qty FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_target;
DROP TABLE g_common_source;
