-- generated_from: manifest_create_row_level_security_policy_finite
-- static_only: true
-- case_count: 20

-- case_id: manifest_create_row_level_security_policy_finite_4cc82a4240e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_none", "expression": "create_row_level_security_policy_expression_true", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source USING (true);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_bc3146d5899c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_all", "expression": "create_row_level_security_policy_expression_false", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_permissive", "roles": "create_row_level_security_policy_roles_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS PERMISSIVE FOR ALL TO PUBLIC USING (false);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_b6cc728dd38c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_select", "expression": "create_row_level_security_policy_expression_null", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_restrictive", "roles": "create_row_level_security_policy_roles_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS RESTRICTIVE FOR SELECT TO CURRENT_USER USING (NULL::boolean);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_e2d093bf8e72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_all", "expression": "create_row_level_security_policy_expression_positive", "long_form": "create_row_level_security_policy_long_form_long", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE ROW LEVEL SECURITY POLICY b10_rls_new ON b10_rls_source FOR ALL TO CURRENT_USER USING (col_1 > 0);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_4acd0a6e7cea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_none", "expression": "create_row_level_security_policy_expression_null", "long_form": "create_row_level_security_policy_long_form_long", "mode": "create_row_level_security_policy_mode_permissive", "roles": "create_row_level_security_policy_roles_session"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE ROW LEVEL SECURITY POLICY b10_rls_new ON b10_rls_source AS PERMISSIVE TO SESSION_USER USING (NULL::boolean);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_0769802ebe67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_update", "expression": "create_row_level_security_policy_expression_false", "long_form": "create_row_level_security_policy_long_form_long", "mode": "create_row_level_security_policy_mode_restrictive", "roles": "create_row_level_security_policy_roles_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE ROW LEVEL SECURITY POLICY b10_rls_new ON b10_rls_source AS RESTRICTIVE FOR UPDATE USING (false);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_04fe1e199045
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_delete", "expression": "create_row_level_security_policy_expression_positive", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_restrictive", "roles": "create_row_level_security_policy_roles_session"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS RESTRICTIVE FOR DELETE TO SESSION_USER USING (col_1 > 0);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_69bb01c4381d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_select", "expression": "create_row_level_security_policy_expression_true", "long_form": "create_row_level_security_policy_long_form_long", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE ROW LEVEL SECURITY POLICY b10_rls_new ON b10_rls_source FOR SELECT TO PUBLIC USING (true);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_9cdf58ea44c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_update", "expression": "create_row_level_security_policy_expression_true", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_permissive", "roles": "create_row_level_security_policy_roles_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS PERMISSIVE FOR UPDATE TO CURRENT_USER USING (true);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_61d3c090f503
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_select", "expression": "create_row_level_security_policy_expression_positive", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_permissive", "roles": "create_row_level_security_policy_roles_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS PERMISSIVE FOR SELECT USING (col_1 > 0);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_27159dece01c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_delete", "expression": "create_row_level_security_policy_expression_null", "long_form": "create_row_level_security_policy_long_form_long", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE ROW LEVEL SECURITY POLICY b10_rls_new ON b10_rls_source FOR DELETE USING (NULL::boolean);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_4ebeec171692
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_select", "expression": "create_row_level_security_policy_expression_false", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_session"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source FOR SELECT TO SESSION_USER USING (false);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_099dc2e14dd2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_none", "expression": "create_row_level_security_policy_expression_positive", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_restrictive", "roles": "create_row_level_security_policy_roles_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS RESTRICTIVE TO PUBLIC USING (col_1 > 0);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_aba932ca4e78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_all", "expression": "create_row_level_security_policy_expression_true", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_restrictive", "roles": "create_row_level_security_policy_roles_session"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS RESTRICTIVE FOR ALL TO SESSION_USER USING (true);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_4a0c2c783817
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_update", "expression": "create_row_level_security_policy_expression_null", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source FOR UPDATE TO PUBLIC USING (NULL::boolean);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_60f2d12e590f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_delete", "expression": "create_row_level_security_policy_expression_false", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_permissive", "roles": "create_row_level_security_policy_roles_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source AS PERMISSIVE FOR DELETE TO CURRENT_USER USING (false);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_440d56507494
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_none", "expression": "create_row_level_security_policy_expression_false", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source TO CURRENT_USER USING (false);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_175d322733da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_all", "expression": "create_row_level_security_policy_expression_null", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source FOR ALL USING (NULL::boolean);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_de0dedf99b01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_update", "expression": "create_row_level_security_policy_expression_positive", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_session"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source FOR UPDATE TO SESSION_USER USING (col_1 > 0);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_row_level_security_policy_finite_2135d9e58b6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "create_row_level_security_policy_command_delete", "expression": "create_row_level_security_policy_expression_true", "long_form": "create_row_level_security_policy_long_form_short", "mode": "create_row_level_security_policy_mode_none", "roles": "create_row_level_security_policy_roles_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
-- test_sql:
CREATE POLICY b10_rls_new ON b10_rls_source FOR DELETE TO PUBLIC USING (true);
-- fixture_teardown:
ROLLBACK;
