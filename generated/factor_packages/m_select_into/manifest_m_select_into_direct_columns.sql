-- generated_from: manifest_m_select_into_direct_columns
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_select_into_direct_columns_f98aad98517a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_none", "projection": "m_select_into_projection_id", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT id INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_d007afda304e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_off", "modifier": "m_select_into_modifier_none", "projection": "m_select_into_projection_two", "table_keyword": "m_select_into_table_keyword_yes", "where": "m_select_into_where_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT SQL_NO_CACHE id, qty INTO TABLE m_select_into_new FROM m_select_into_source WHERE id > 1;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_c54f6253ae43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_all", "projection": "m_select_into_projection_reverse", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL qty, id INTO m_select_into_new FROM m_select_into_source WHERE id > 1;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_2339ec2057bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_off", "modifier": "m_select_into_modifier_distinct", "projection": "m_select_into_projection_reverse", "table_keyword": "m_select_into_table_keyword_yes", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT SQL_NO_CACHE qty, id INTO TABLE m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_b2d46e95d7e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_distinctrow", "projection": "m_select_into_projection_two", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW id, qty INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_4da09dbf532f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_off", "modifier": "m_select_into_modifier_distinctrow", "projection": "m_select_into_projection_id", "table_keyword": "m_select_into_table_keyword_yes", "where": "m_select_into_where_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW SQL_NO_CACHE id INTO TABLE m_select_into_new FROM m_select_into_source WHERE id > 1;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_32b0f9c88ae5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_all", "projection": "m_select_into_projection_id", "table_keyword": "m_select_into_table_keyword_yes", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL id INTO TABLE m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_03ff0edbf84f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_distinct", "projection": "m_select_into_projection_id", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT id INTO m_select_into_new FROM m_select_into_source WHERE id > 1;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_f0b7ef3caf7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_off", "modifier": "m_select_into_modifier_all", "projection": "m_select_into_projection_two", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT ALL SQL_NO_CACHE id, qty INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_b15bb2398d86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_none", "projection": "m_select_into_projection_reverse", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT qty, id INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_3a108dc81e9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_distinct", "projection": "m_select_into_projection_two", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCT id, qty INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;

-- case_id: manifest_m_select_into_direct_columns_bab85ea76b7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_into_cache_none", "modifier": "m_select_into_modifier_distinctrow", "projection": "m_select_into_projection_reverse", "table_keyword": "m_select_into_table_keyword_none", "where": "m_select_into_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_into_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_select_into_source (id INTEGER, qty INTEGER);
INSERT INTO m_select_into_source VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT DISTINCTROW qty, id INTO m_select_into_new FROM m_select_into_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_select_into_new;
DROP TABLE m_select_into_source;
