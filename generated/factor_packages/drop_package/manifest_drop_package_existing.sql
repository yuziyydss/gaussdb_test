-- generated_from: manifest_drop_package_existing
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_package_existing_8efe40409597
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "drop_package_body_package", "if_exists": "drop_package_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_package_fact_initial_owner"], "key": "package_drop_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_existing AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_existing;
CREATE PACKAGE BODY fp_cs_one.b10_package_existing AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_existing;
-- test_sql:
DROP PACKAGE fp_cs_one.b10_package_existing;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_package_existing_ef3159324457
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "drop_package_body_package", "if_exists": "drop_package_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_package_fact_initial_owner"], "key": "package_drop_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_existing AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_existing;
CREATE PACKAGE BODY fp_cs_one.b10_package_existing AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_existing;
-- test_sql:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_package_existing_21a6dafca74a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "drop_package_body_body", "if_exists": "drop_package_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_package_fact_initial_owner"], "key": "package_drop_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_existing AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_existing;
CREATE PACKAGE BODY fp_cs_one.b10_package_existing AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_existing;
-- test_sql:
DROP PACKAGE BODY fp_cs_one.b10_package_existing;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_package_existing_ae9ebcaff019
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "drop_package_body_body", "if_exists": "drop_package_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_package_fact_initial_owner"], "key": "package_drop_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_existing AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_existing;
CREATE PACKAGE BODY fp_cs_one.b10_package_existing AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_existing;
-- test_sql:
DROP PACKAGE BODY IF EXISTS fp_cs_one.b10_package_existing;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
