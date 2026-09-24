-- generated_from: manifest_create_security_label_invalid_content
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_security_label_invalid_content_804db864e759
-- expected: error
-- expected_error_category: invalid_security_label_content
-- expected_sqlstates: -
-- expected_error_regex: in label text ".*", there at least have one level and one group
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"content": "create_security_label_content_empty_range"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_security_label_fact_privilege"], "key": "security_label_authorized"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SECURITY LABEL b9_sec_new 'L1:';
-- fixture_teardown:
ROLLBACK;
