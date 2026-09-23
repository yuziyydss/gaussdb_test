-- generated_from: manifest_insert_generated_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_generated_negative_f4c6cc76c822
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_finite_generated_literal", "target_profile": "insert_target_finite_generated_values", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_referenced_select"], "fact_refs": ["insert_fact_permissions"], "key": "insert_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
-- test_sql:
INSERT INTO g_generated_dst VALUES (2, 9, 99);
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;

-- case_id: manifest_insert_generated_negative_28c819c43250
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_finite_generated_null", "target_profile": "insert_target_finite_generated_values", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_referenced_select"], "fact_refs": ["insert_fact_permissions"], "key": "insert_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
-- test_sql:
INSERT INTO g_generated_dst VALUES (2, 9, NULL);
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;
