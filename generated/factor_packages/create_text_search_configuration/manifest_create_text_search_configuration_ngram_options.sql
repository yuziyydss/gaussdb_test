-- generated_from: manifest_create_text_search_configuration_ngram_options
-- static_only: true
-- case_count: 9

-- case_id: manifest_create_text_search_configuration_ngram_options_ec2d7cbfcc85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g1", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = ngram) WITH (gram_size = 1, punctuation_ignore = true, grapsymbol_ignore = true);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_1b51259fdaf3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g2", "graphics": "create_text_search_configuration_graphics_false", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_false", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy) WITH (gram_size = 2, punctuation_ignore = false, grapsymbol_ignore = false);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_73a7ac119014
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g3", "graphics": "create_text_search_configuration_graphics_false", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = ngram) WITH (gram_size = 3, punctuation_ignore = true, grapsymbol_ignore = false);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_971805ea678e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g4", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_false", "source": "create_text_search_configuration_source_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = ngram) WITH (gram_size = 4, punctuation_ignore = false, grapsymbol_ignore = true);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_a2eb687ab209
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g2", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy) WITH (gram_size = 2, punctuation_ignore = true, grapsymbol_ignore = true);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_590ee44bca5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g1", "graphics": "create_text_search_configuration_graphics_false", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_false", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy) WITH (gram_size = 1, punctuation_ignore = false, grapsymbol_ignore = false);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_f46b45de5f5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g3", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_false", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy) WITH (gram_size = 3, punctuation_ignore = false, grapsymbol_ignore = true);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_2e13e68828a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g4", "graphics": "create_text_search_configuration_graphics_false", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_copy"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
CREATE TEXT SEARCH CONFIGURATION fp_tsc_copy (PARSER=ngram) WITH (gram_size=2);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_copy ADD MAPPING FOR multisymbol WITH simple;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (COPY = fp_tsc_copy) WITH (gram_size = 4, punctuation_ignore = true, grapsymbol_ignore = false);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_copy CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;

-- case_id: manifest_create_text_search_configuration_ngram_options_a8c44be7059a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"gram_size": "create_text_search_configuration_gram_size_g2", "graphics": "create_text_search_configuration_graphics_true", "options": "create_text_search_configuration_options_ngram", "punctuation": "create_text_search_configuration_punctuation_true", "source": "create_text_search_configuration_source_ngram"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}]
-- fixture_setup:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_new (PARSER = ngram) WITH (gram_size = 2, punctuation_ignore = true, grapsymbol_ignore = true);
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_new CASCADE;
