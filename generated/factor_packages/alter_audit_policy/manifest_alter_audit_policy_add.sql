-- generated_from: manifest_alter_audit_policy_add
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_audit_policy_add_c957d9338fdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "alter_audit_policy_if_exists_none", "operation": "alter_audit_policy_operation_add"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["alter_audit_policy_fact_switch"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
CREATE AUDIT POLICY b10_audit_existing PRIVILEGES CREATE DISABLE;
-- test_sql:
ALTER AUDIT POLICY b10_audit_existing ADD PRIVILEGES (DROP);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS b10_audit_existing;
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_audit_policy_add_8803cb59f968
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "alter_audit_policy_if_exists_yes", "operation": "alter_audit_policy_operation_add"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["alter_audit_policy_fact_switch"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_a ADD COLUMN(b9_rl_source.col_1);
CREATE RESOURCE LABEL b9_rl_b ADD TABLE(b9_rl_source_two);
CREATE AUDIT POLICY b10_audit_existing PRIVILEGES CREATE DISABLE;
-- test_sql:
ALTER AUDIT POLICY IF EXISTS b10_audit_existing ADD PRIVILEGES (DROP);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS b10_audit_existing;
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
