-- generated_from: manifest_show_events_empty_schema
-- static_only: true
-- case_count: 9

-- case_id: manifest_show_events_empty_schema_d132f9275408
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_none", "scope": "show_events_scope_current"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_e46b02b80b02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_like", "scope": "show_events_scope_current"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS LIKE 'b10_event_%';
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_bf48a990200d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_where", "scope": "show_events_scope_current"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS WHERE true;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_4a310d8711ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_none", "scope": "show_events_scope_from"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS FROM fp_cs_one;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_f10f0c7cd81e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_like", "scope": "show_events_scope_from"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS FROM fp_cs_one LIKE 'b10_event_%';
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_38ca6328992b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_where", "scope": "show_events_scope_from"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS FROM fp_cs_one WHERE true;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_0acbfed50a48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_none", "scope": "show_events_scope_in"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS IN fp_cs_one;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_da134d51c5d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_like", "scope": "show_events_scope_in"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS IN fp_cs_one LIKE 'b10_event_%';
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_show_events_empty_schema_da02847a3042
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"filter": "show_events_filter_where", "scope": "show_events_scope_in"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["show_events_fact_compat_b"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
SHOW EVENTS IN fp_cs_one WHERE true;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
