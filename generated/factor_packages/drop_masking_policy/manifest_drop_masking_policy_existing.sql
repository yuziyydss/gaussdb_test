-- generated_from: manifest_drop_masking_policy_existing
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_masking_policy_existing_8792b0581b63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_masking_policy_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_masking_policy_fact_privilege"], "key": "security_policy_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
CREATE MASKING POLICY b10_mask_existing maskall ON LABEL(b10_mask_a) DISABLE;
-- test_sql:
DROP MASKING POLICY b10_mask_existing;
-- fixture_teardown:
DROP MASKING POLICY IF EXISTS b10_mask_existing;
ROLLBACK;

-- case_id: manifest_drop_masking_policy_existing_856a2bffc454
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_masking_policy_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_masking_policy_fact_privilege"], "key": "security_policy_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
CREATE MASKING POLICY b10_mask_existing maskall ON LABEL(b10_mask_a) DISABLE;
-- test_sql:
DROP MASKING POLICY IF EXISTS b10_mask_existing;
-- fixture_teardown:
DROP MASKING POLICY IF EXISTS b10_mask_existing;
ROLLBACK;
