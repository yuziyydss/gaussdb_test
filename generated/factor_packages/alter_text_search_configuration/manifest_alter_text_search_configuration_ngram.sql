-- generated_from: manifest_alter_text_search_configuration_ngram
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_text_search_configuration_ngram_6ce636021847
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_set", "form": "alter_text_search_configuration_form_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_ngram (PARSER=ngram);
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_ngram SET (gram_size = 1, punctuation_ignore = false);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_ngram CASCADE;

-- case_id: manifest_alter_text_search_configuration_ngram_944268982903
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_reset", "form": "alter_text_search_configuration_form_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_ngram (PARSER=ngram);
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_ngram RESET (gram_size, punctuation_ignore);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_ngram CASCADE;
