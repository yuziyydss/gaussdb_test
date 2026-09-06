-- generated_from: manifest_alter_package_owner
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_package_owner_70c485435f0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_package_operation_owner"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_package_fact_no_separation"], "key": "sysadmin"}, {"allowed_values": ["off"], "fact_refs": ["alter_package_fact_no_separation"], "key": "enable_separation_of_duty"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE PACKAGE fp_cs_one.b10_package_existing AUTHID CURRENT_USER AS g_counter INTEGER := 0; PROCEDURE p_inc; END b10_package_existing;
CREATE PACKAGE BODY fp_cs_one.b10_package_existing AS PROCEDURE p_inc AS BEGIN g_counter := g_counter + 1; END; END b10_package_existing;
GRANT CREATE ON SCHEMA fp_cs_one TO b9_role_b;
-- test_sql:
ALTER PACKAGE fp_cs_one.b10_package_existing OWNER TO b9_role_b;
-- fixture_teardown:
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
REVOKE CREATE ON SCHEMA fp_cs_one FROM b9_role_b;
DROP PACKAGE IF EXISTS fp_cs_one.b10_package_existing;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
