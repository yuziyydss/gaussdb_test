-- generated_from: manifest_create_security_label_invalid_content
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_security_label_invalid_content_804db864e759
-- expected: error
-- expected_error_category: invalid_security_label_content
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"content": "create_security_label_content_empty_range"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1:';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_invalid_content_eb358921788e
-- expected: error
-- expected_error_category: invalid_security_label_content
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"content": "create_security_label_content_reverse_range"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1:G5-G1';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_invalid_content_291b6011fd47
-- expected: error
-- expected_error_category: invalid_security_label_content
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"content": "create_security_label_content_zero_level"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L0:G1';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_security_label_invalid_content_44c6dd14d851
-- expected: error
-- expected_error_category: invalid_security_label_content
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"content": "create_security_label_content_lowercase"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'l1:G1';
-- fixture_teardown:
ROLLBACK;
