-- generated_from: manifest_drop_text_search_configuration_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_text_search_configuration_existing_d21e53b9c7b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_none", "if_exists": "drop_text_search_configuration_if_exists_none", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION fp_tsc_empty;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_existing_0609066d23a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_restrict", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_existing_41be1db1b946
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_cascade", "if_exists": "drop_text_search_configuration_if_exists_none", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION fp_tsc_empty CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_existing_7c5bbb1f5ba5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_restrict", "if_exists": "drop_text_search_configuration_if_exists_none", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION fp_tsc_empty RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_existing_328052be51e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_none", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_drop_text_search_configuration_existing_96b5ac274ebc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_configuration_behavior_cascade", "if_exists": "drop_text_search_configuration_if_exists_yes", "target": "drop_text_search_configuration_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;
