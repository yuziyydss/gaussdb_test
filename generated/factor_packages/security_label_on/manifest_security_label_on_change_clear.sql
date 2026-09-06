-- generated_from: manifest_security_label_on_change_clear
-- static_only: true
-- case_count: 4

-- case_id: manifest_security_label_on_change_clear_81d4c9651b8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_update", "target": "security_label_on_target_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_a';
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_a';
-- test_sql:
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_b';
-- fixture_teardown:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS NULL;
SECURITY LABEL ON TABLE b9_sec_table IS NULL;
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;

-- case_id: manifest_security_label_on_change_clear_25842db5db07
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_clear", "target": "security_label_on_target_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_a';
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_a';
-- test_sql:
SECURITY LABEL ON TABLE b9_sec_table IS NULL;
-- fixture_teardown:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS NULL;
SECURITY LABEL ON TABLE b9_sec_table IS NULL;
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;

-- case_id: manifest_security_label_on_change_clear_f6bafdc1443b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_update", "target": "security_label_on_target_column"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_a';
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_a';
-- test_sql:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_b';
-- fixture_teardown:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS NULL;
SECURITY LABEL ON TABLE b9_sec_table IS NULL;
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;

-- case_id: manifest_security_label_on_change_clear_8d0a50b58927
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "security_label_on_label_clear", "target": "security_label_on_target_column"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["security_label_on_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
CREATE TABLE b9_sec_table (col_1 INTEGER, col_2 INTEGER);
SECURITY LABEL ON TABLE b9_sec_table IS 'b9_sec_a';
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS 'b9_sec_a';
-- test_sql:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS NULL;
-- fixture_teardown:
SECURITY LABEL ON COLUMN b9_sec_table.col_1 IS NULL;
SECURITY LABEL ON TABLE b9_sec_table IS NULL;
DROP TABLE IF EXISTS b9_sec_table;
ROLLBACK;
