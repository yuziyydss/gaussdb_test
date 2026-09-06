-- generated_from: manifest_create_text_search_dictionary_simple
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_text_search_dictionary_simple_00fef3dbc7a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"accept": "create_text_search_dictionary_accept_default", "template": "create_text_search_dictionary_template_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH DICTIONARY fp_tsd_new (TEMPLATE = simple );
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;

-- case_id: manifest_create_text_search_dictionary_simple_3b0196e19650
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"accept": "create_text_search_dictionary_accept_true", "template": "create_text_search_dictionary_template_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH DICTIONARY fp_tsd_new (TEMPLATE = simple , ACCEPT = true);
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;

-- case_id: manifest_create_text_search_dictionary_simple_7419d2c9cf64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"accept": "create_text_search_dictionary_accept_false", "template": "create_text_search_dictionary_template_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;
-- test_sql:
CREATE TEXT SEARCH DICTIONARY fp_tsd_new (TEMPLATE = simple , ACCEPT = false);
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_new CASCADE;
