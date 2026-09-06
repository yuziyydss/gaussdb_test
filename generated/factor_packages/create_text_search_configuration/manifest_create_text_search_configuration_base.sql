-- generated_from: manifest_create_text_search_configuration_base
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_text_search_configuration_base_3e56752ce07a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g1", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_none", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = default);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_base_80e8cf230455
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g1", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_none", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = ngram);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_base_e1b3f09c73e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g1", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_none", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
