-- generated_from: manifest_drop_text_search_dictionary_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_text_search_dictionary_existing_f5719c41723c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_none", "if_exists": "drop_text_search_dictionary_if_exists_none", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY fp_tsd_simple;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_existing_3a2ba1e54cb5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_restrict", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_existing_c24803efc63e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_cascade", "if_exists": "drop_text_search_dictionary_if_exists_none", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY fp_tsd_simple CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_existing_1fe311a8cf22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_restrict", "if_exists": "drop_text_search_dictionary_if_exists_none", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY fp_tsd_simple RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_existing_e34a816f3e25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_none", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_existing_109aa7f2db82
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_cascade", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_existing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
