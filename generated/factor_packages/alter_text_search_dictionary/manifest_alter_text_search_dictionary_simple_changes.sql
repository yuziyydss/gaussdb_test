-- generated_from: manifest_alter_text_search_dictionary_simple_changes
-- static_only: true
-- case_count: 5

-- case_id: manifest_alter_text_search_dictionary_simple_changes_7be100d267fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_dictionary_action_true", "name": "alter_text_search_dictionary_name_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["alter_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
ALTER TEXT SEARCH DICTIONARY fp_tsd_simple (ACCEPT = true);
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_alter_text_search_dictionary_simple_changes_eee9fcb30a27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_dictionary_action_false", "name": "alter_text_search_dictionary_name_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["alter_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
ALTER TEXT SEARCH DICTIONARY fp_tsd_simple (ACCEPT = false);
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_alter_text_search_dictionary_simple_changes_90b5702408d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_dictionary_action_reset", "name": "alter_text_search_dictionary_name_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["alter_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
-- test_sql:
ALTER TEXT SEARCH DICTIONARY fp_tsd_simple (ACCEPT);
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_alter_text_search_dictionary_simple_changes_2138918d84cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_dictionary_action_rename", "name": "alter_text_search_dictionary_name_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["alter_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
SELECT 1;
-- test_sql:
ALTER TEXT SEARCH DICTIONARY fp_tsd_simple RENAME TO fp_atd_renamed;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_atd_renamed CASCADE;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;

-- case_id: manifest_alter_text_search_dictionary_simple_changes_c4d458d8da91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_dictionary_action_schema", "name": "alter_text_search_dictionary_name_simple"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["alter_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
CREATE SCHEMA fp_atd_schema;
-- test_sql:
ALTER TEXT SEARCH DICTIONARY fp_tsd_simple SET SCHEMA fp_atd_schema;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_atd_schema CASCADE;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
