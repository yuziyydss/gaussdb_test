-- generated_from: manifest_create_security_label_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_security_label_positive_bf648dbed248
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"content": "create_security_label_content_minimum"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1:G1';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_positive_a3ae0376ff1c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"content": "create_security_label_content_maximum"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1024:G1024';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_positive_6b04e3769e5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"content": "create_security_label_content_set"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1:G2,G4';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_positive_44b2f8bef70b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"content": "create_security_label_content_range"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L3:G1-G5';
-- fixture_teardown:
ROLLBACK;
