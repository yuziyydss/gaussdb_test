-- generated_from: manifest_m_select_count_nullable
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_select_count_nullable_a52af904a693
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_id_plain", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(id) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;

-- case_id: manifest_m_select_count_nullable_4277309cbaaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_id_all", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(ALL id) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;

-- case_id: manifest_m_select_count_nullable_484e63b96a53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_id_distinct", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(DISTINCT id) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;

-- case_id: manifest_m_select_count_nullable_c5c256722985
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_qty_plain", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(qty) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;

-- case_id: manifest_m_select_count_nullable_4d0d24b934c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_qty_all", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(ALL qty) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;

-- case_id: manifest_m_select_count_nullable_4ac240ee75a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_count_nullable", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_count_qty_distinct", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["m_builtin_count"], "fact_refs": ["m_select_fact_count_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE SCHEMA m_select_count_ns;
CREATE TABLE m_select_count_ns.source_table (id INTEGER, qty INTEGER);
INSERT INTO m_select_count_ns.source_table (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);
-- test_sql:
SELECT COUNT(DISTINCT qty) AS result FROM m_select_count_ns.source_table;
-- fixture_teardown:
DROP TABLE m_select_count_ns.source_table RESTRICT;
DROP SCHEMA m_select_count_ns;
