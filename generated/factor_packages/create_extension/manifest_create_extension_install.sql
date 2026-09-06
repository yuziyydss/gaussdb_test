-- generated_from: manifest_create_extension_install
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_extension_install_a032577e5338
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_no", "version": "create_extension_version_default", "with_keyword": "create_extension_with_keyword_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_extension_install_386a0a060153
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_no", "version": "create_extension_version_string", "with_keyword": "create_extension_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION ext_b7 WITH SCHEMA ext_b7_schema VERSION '1.0';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_extension_install_c5782a3023cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_yes", "version": "create_extension_version_string", "with_keyword": "create_extension_with_keyword_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION IF NOT EXISTS ext_b7 SCHEMA ext_b7_schema VERSION '1.0';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_extension_install_86c9222db5cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_yes", "version": "create_extension_version_default", "with_keyword": "create_extension_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION IF NOT EXISTS ext_b7 WITH SCHEMA ext_b7_schema;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_extension_install_a9c159e88682
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_no", "version": "create_extension_version_identifier", "with_keyword": "create_extension_with_keyword_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema VERSION b7_version;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_extension_install_d632ff7c4b75
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_extension_if_not_exists_yes", "version": "create_extension_version_identifier", "with_keyword": "create_extension_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
-- test_sql:
CREATE EXTENSION IF NOT EXISTS ext_b7 WITH SCHEMA ext_b7_schema VERSION b7_version;
-- fixture_teardown:
ROLLBACK;
