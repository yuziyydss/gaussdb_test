-- generated_from: manifest_m_select_core
-- static_only: true
-- case_count: 17

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_select_core_ea1a58955962
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT id FROM m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_bc00d377995c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_count", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_asc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_all", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_nested", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_two", "where_clause": "m_select_where_clause_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL SQL_CACHE id, qty FROM (SELECT id,qty FROM m_b01_source) AS m_nested WHERE id > 1 ORDER BY id ASC LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_7765e3c32223
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_no_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_comma", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_desc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinct", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT SQL_NO_CACHE id FROM m_b01_source WHERE id > 1 ORDER BY id DESC LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_17de21d00baf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_offset", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_desc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinctrow", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_nested", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_two", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW id, qty FROM (SELECT id,qty FROM m_b01_source) AS m_nested ORDER BY id DESC LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_e1f9d6fc76a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_no_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_comma", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_nested", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_two", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT SQL_NO_CACHE id, qty FROM (SELECT id,qty FROM m_b01_source) AS m_nested LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_cfbcc1bd7bd4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_offset", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_asc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_all", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL SQL_CACHE id FROM m_b01_source ORDER BY id ASC LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_6bb070cfb506
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_asc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinct", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_nested", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_two", "where_clause": "m_select_where_clause_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT id, qty FROM (SELECT id,qty FROM m_b01_source) AS m_nested WHERE id > 1 ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_c1404de4dc05
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_count", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinctrow", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW SQL_CACHE id FROM m_b01_source WHERE id > 1 LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_a1eed815f6ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_count", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_desc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_nested", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT SQL_CACHE id FROM (SELECT id,qty FROM m_b01_source) AS m_nested ORDER BY id DESC LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_70552892bf01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_no_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_offset", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_asc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_two", "where_clause": "m_select_where_clause_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT SQL_NO_CACHE id, qty FROM m_b01_source WHERE id > 1 ORDER BY id ASC LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_d05c2305faf1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_no_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_desc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_all", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL SQL_NO_CACHE id FROM m_b01_source ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_6041f0c72281
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_offset", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinct", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT SQL_CACHE id FROM m_b01_source LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_7ce494ca39f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_comma", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_all", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL id FROM m_b01_source LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_737c3300fca4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_comma", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_asc", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinctrow", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW SQL_CACHE id FROM m_b01_source ORDER BY id ASC LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_02b4fff84fb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_count", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinct", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT id FROM m_b01_source LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_8ee55bad7c0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinctrow", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW SQL_CACHE id FROM m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_core_31ef98a97039
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_no_cache", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_count", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_distinctrow", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW SQL_NO_CACHE id FROM m_b01_source LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;
