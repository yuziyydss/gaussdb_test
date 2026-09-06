-- generated_from: manifest_security_label_on_apply
-- static_only: true
-- case_count: 2

-- case_id: manifest_security_label_on_apply_28e68c8acb02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_apply", "target": "security_label_on_target_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
-- test_sql:
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_a';
-- fixture_teardown:
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;

-- case_id: manifest_security_label_on_apply_9abe95bb79e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_apply", "target": "security_label_on_target_column"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
-- test_sql:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_a';
-- fixture_teardown:
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;
