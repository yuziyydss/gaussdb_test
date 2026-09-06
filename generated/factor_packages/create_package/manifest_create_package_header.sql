-- generated_from: manifest_create_package_header
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_package_header_26f148e7711b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_as", "authid": "create_package_authid_none", "form": "create_package_form_header", "replace": "create_package_replace_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE PACKAGE fp_cs_one.b10_package_new AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_header_3351bcc9fbd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_is", "authid": "create_package_authid_invoker", "form": "create_package_form_header", "replace": "create_package_replace_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE OR REPLACE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER IS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_header_c4648fa529d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_is", "authid": "create_package_authid_definer", "form": "create_package_form_header", "replace": "create_package_replace_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID DEFINER IS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_header_c57ff11f333d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_as", "authid": "create_package_authid_definer", "form": "create_package_form_header", "replace": "create_package_replace_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE OR REPLACE PACKAGE fp_cs_one.b10_package_new AUTHID DEFINER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_header_635338ad3094
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_as", "authid": "create_package_authid_invoker", "form": "create_package_form_header", "replace": "create_package_replace_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_header_edf535bf1ca7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_is", "authid": "create_package_authid_none", "form": "create_package_form_header", "replace": "create_package_replace_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE OR REPLACE PACKAGE fp_cs_one.b10_package_new IS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
