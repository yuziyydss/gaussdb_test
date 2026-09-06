-- generated_from: manifest_drop_text_search_dictionary_missing
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_text_search_dictionary_missing_90f3e1028d6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_none", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_dtd_missing;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_missing_b658d4cd4d5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_restrict", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_dtd_missing RESTRICT;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_drop_text_search_dictionary_missing_1e00bb7b26a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_text_search_dictionary_behavior_cascade", "if_exists": "drop_text_search_dictionary_if_exists_yes", "target": "drop_text_search_dictionary_target_missing"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["drop_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_dtd_missing CASCADE;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
