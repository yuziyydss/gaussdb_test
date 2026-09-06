-- generated_from: manifest_create_audit_policy_access
-- static_only: true
-- case_count: 33

-- case_id: manifest_create_audit_policy_access_2f45430a19eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS COPY;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_c3b05d05a872
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_deallocate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS DEALLOCATE ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_7619840215a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_delete", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS DELETE ON LABEL (b9_rl_b) FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_422b1082978a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_execute", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS EXECUTE DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_c9c06f54779d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_reindex", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS REINDEX FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_6fd011bf3f1e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_insert", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS INSERT FILTER ON APP(gsql);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_7791386d7726
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_prepare", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS PREPARE ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_a6ef3ce4e608
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_select", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS SELECT ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_8b73172dd387
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_truncate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS TRUNCATE FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_255f515f2fe3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_update", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS UPDATE FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_bbb34071b2ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_all", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS ALL FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_77d90d5de072
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_deallocate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS DEALLOCATE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_385beee2b9d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_execute", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS EXECUTE ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_0bf983c8d102
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_insert", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS INSERT ON LABEL (b9_rl_b) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_65fa8ec9398c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS COPY ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_13b2edd5d535
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_delete", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS DELETE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_13cfe940e623
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_reindex", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS REINDEX ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_7a23ded6d7a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_prepare", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS PREPARE FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_840d545c7096
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_select", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS SELECT ON LABEL (b9_rl_b) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_7a21e83600b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_truncate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS TRUNCATE ON LABEL (b9_rl_b) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_f8c7e2b969e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_update", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS UPDATE ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_ec92e99ff8ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_all", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_none", "filter_clause": "create_audit_policy_filter_clause_none", "if_not_exists": "create_audit_policy_if_not_exists_yes", "label_clause": "create_audit_policy_label_clause_one", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY IF NOT EXISTS b10_audit_new ACCESS ALL ON LABEL (b9_rl_b);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_80cde07476ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_copy", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS COPY FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_e161126760bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_deallocate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS DEALLOCATE FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_2b86da6ffb96
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_delete", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS DELETE FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_fedfebca029e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_execute", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS EXECUTE FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_755179f0dde9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_reindex", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS REINDEX FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_b4c320bfd54f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_insert", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS INSERT FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_06905a2f97ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_prepare", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS PREPARE FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_75aa4184c279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_select", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS SELECT FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_3bc6bff07da9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_truncate", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS TRUNCATE FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_446fda30f2d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_update", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_enable", "filter_clause": "create_audit_policy_filter_clause_app", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS UPDATE FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_audit_policy_access_9c5649556b9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "create_audit_policy_access_all", "audit_kind": "create_audit_policy_audit_kind_access", "enabled": "create_audit_policy_enabled_disable", "filter_clause": "create_audit_policy_filter_clause_ip", "if_not_exists": "create_audit_policy_if_not_exists_none", "label_clause": "create_audit_policy_label_clause_none", "privilege": "create_audit_policy_privilege_alter"}
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
CREATE AUDIT POLICY b10_audit_new ACCESS ALL FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_b;
DROP RESOURCE LABEL IF EXISTS b9_rl_a;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
