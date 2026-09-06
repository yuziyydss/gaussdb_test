-- generated_from: manifest_drop_security_label_existing
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_security_label_existing_ebb4e098fd91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "drop_security_label_target_exists"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE SECURITY LABEL b9_sec_a 'L1:G1';
CREATE SECURITY LABEL b9_sec_b 'L2:G2';
-- test_sql:
DROP SECURITY LABEL b9_sec_a;
-- fixture_teardown:
ROLLBACK;
