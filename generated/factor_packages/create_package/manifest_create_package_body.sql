-- generated_from: manifest_create_package_body
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_package_body_a9f000dd56ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_as", "authid": "create_package_authid_none", "form": "create_package_form_body", "replace": "create_package_replace_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- test_sql:
CREATE PACKAGE BODY fp_cs_one.b10_package_new AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_new;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_new;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_body_e36846bd24c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_is", "authid": "create_package_authid_none", "form": "create_package_form_body", "replace": "create_package_replace_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- test_sql:
CREATE OR REPLACE PACKAGE BODY fp_cs_one.b10_package_new IS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_new;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_new;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_body_06ee28adcd88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_is", "authid": "create_package_authid_none", "form": "create_package_form_body", "replace": "create_package_replace_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- test_sql:
CREATE PACKAGE BODY fp_cs_one.b10_package_new IS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_new;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_new;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_package_body_ab81dc36c0ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_is": "create_package_as_is_as", "authid": "create_package_authid_none", "form": "create_package_form_body", "replace": "create_package_replace_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_package_fact_create_any"], "key": "package_create_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_new AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_new;
-- test_sql:
CREATE OR REPLACE PACKAGE BODY fp_cs_one.b10_package_new AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_new;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_new;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
