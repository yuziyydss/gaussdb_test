-- generated_from: manifest_alter_text_search_configuration_mapping
-- static_only: true
-- case_count: 10

-- case_id: manifest_alter_text_search_configuration_mapping_110d33833fbf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_add", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_7bdcbd5bede8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_add_multiple", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word, email WITH simple, english_stem;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_0f294793fbfc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_alter", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ALTER MAPPING FOR word WITH fp_tsd_simple, simple;
-- fixture_teardown:
SELECT 1;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_d4e3c3bdd961
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_replace_for", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ALTER MAPPING FOR word REPLACE simple WITH fp_tsd_simple;
-- fixture_teardown:
SELECT 1;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_01526cc08673
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_replace_all", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ALTER MAPPING REPLACE simple WITH fp_tsd_simple;
-- fixture_teardown:
SELECT 1;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_53092fd0326f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_drop", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty DROP MAPPING FOR word;
-- fixture_teardown:
SELECT 1;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_d51410220247
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_drop_if", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE TEXT SEARCH DICTIONARY fp_tsd_simple (TEMPLATE=simple, ACCEPT=true);
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty ADD MAPPING FOR word WITH simple;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty DROP MAPPING IF EXISTS FOR word;
-- fixture_teardown:
SELECT 1;
DROP TEXT SEARCH DICTIONARY IF EXISTS fp_tsd_simple CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_ee72349132f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_drop_missing", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty DROP MAPPING IF EXISTS FOR email;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_1ac35466b8f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_rename", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
SELECT 1;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty RENAME TO fp_atc_renamed;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_atc_renamed CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;

-- case_id: manifest_alter_text_search_configuration_mapping_86c45d462297
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_text_search_configuration_action_schema", "form": "alter_text_search_configuration_form_default"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}]
-- fixture_setup:
CREATE TEXT SEARCH CONFIGURATION fp_tsc_empty (PARSER=default);
CREATE SCHEMA fp_atc_schema;
-- test_sql:
ALTER TEXT SEARCH CONFIGURATION fp_tsc_empty SET SCHEMA fp_atc_schema;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_atc_schema CASCADE;
DROP TEXT SEARCH CONFIGURATION IF EXISTS fp_tsc_empty CASCADE;
