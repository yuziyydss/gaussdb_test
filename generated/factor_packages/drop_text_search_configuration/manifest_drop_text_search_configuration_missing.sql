-- generated_from: manifest_drop_text_search_configuration_missing
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_text_search_configuration_missing_c7488b640ee7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_none", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_dtc_missing;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_missing_9d9ac57769c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_restrict", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_dtc_missing RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_missing_fb0722e90d1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_cascade", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_dtc_missing CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;
