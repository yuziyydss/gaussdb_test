-- generated_from: manifest_alter_masking_policy_enable
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_masking_policy_enable_ac377e518fd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_masking_policy_operation_enable"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["alter_masking_policy_fact_switch"], "key": "enable_security_policy"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
CREATE MASKING POLICY b10_mask_existing maskall ON LABEL(b10_mask_a) DISABLE;
-- test_sql:
ALTER MASKING POLICY b10_mask_existing ENABLE;
-- fixture_teardown:
DROP MASKING POLICY IF EXISTS b10_mask_existing;
ROLLBACK;
