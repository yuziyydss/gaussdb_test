-- generated_from: manifest_create_audit_policy_privileges
-- static_only: true
-- case_count: 30

-- case_id: manifest_create_audit_policy_privileges_257bc06a20f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ALTER;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_8a561208e324
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_analyze"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES ANALYZE ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_f867b8e4787b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_comment"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES COMMENT ON LABEL (b9_rl_b) FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_9d6875f8bd0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_create"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES CREATE DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_60aa058384e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_drop"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES DROP FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_28dc0bb961bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_grant"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES GRANT FILTER ON APP(gsql);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_2f6cd5af6493
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_revoke"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES REVOKE ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_0d8b94dcc09b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_set"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES SET ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_68e1b8f50050
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_show"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES SHOW FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_f6688d282ce4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_all"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ALL FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_300e12839742
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_create"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES CREATE ON LABEL (b9_rl_b) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_cacf68757d4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_analyze"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ANALYZE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_200ecc1fa591
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_grant"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES GRANT ON LABEL (b9_rl_b) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_c268b5a9b5d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES ALTER ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_89d87bb6ae0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_comment"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES COMMENT;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_da0b71d6b2d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_drop"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES DROP ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_d873bc3187b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_revoke"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES REVOKE FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_f471ae8cbf6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_set"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES SET ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_0f9deb4fed77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_show"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES SHOW ON LABEL (b9_rl_b) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_2b27de55eaaf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_all"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new PRIVILEGES ALL ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_effb18c9dc83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ALTER FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_315e1ba429d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_analyze"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ANALYZE FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_61f9fbb99fd4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_comment"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES COMMENT FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_483d7e064703
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_create"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES CREATE FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_579edce06f53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_drop"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES DROP FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_f694ac5bb644
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_grant"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES GRANT FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_0c226d790e4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_revoke"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES REVOKE FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_6bf305667251
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_set"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES SET FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_9b8a4087f225
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_show"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES SHOW FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_privileges_bf7bc87ff82d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_privileges", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_all"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_audit_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_audit_policy_fact_switch"], "key": "enable_security_policy"}]
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
-- test_sql:
CREATE AUDIT POLICY b10_audit_new PRIVILEGES ALL FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
