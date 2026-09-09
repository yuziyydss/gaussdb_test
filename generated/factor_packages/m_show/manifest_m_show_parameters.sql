-- generated_from: manifest_m_show_parameters
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_show_parameters_7cd87c691435
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_parameters", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SET LOCAL TIME ZONE 'PRC';
-- test_sql:
SHOW TIME ZONE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_show_parameters_0b7ed5c5c784
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_parameters", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_isolation", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SET LOCAL TIME ZONE 'PRC';
-- test_sql:
SHOW TRANSACTION ISOLATION LEVEL;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_show_parameters_27c8e56c1410
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_parameters", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_identity", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SET LOCAL TIME ZONE 'PRC';
-- test_sql:
SHOW SESSION AUTHORIZATION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_show_parameters_c1f26f47f886
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_parameters", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_all", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SET LOCAL TIME ZONE 'PRC';
-- test_sql:
SHOW ALL;
-- fixture_teardown:
ROLLBACK;
