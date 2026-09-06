-- generated_from: manifest_alter_row_level_security_policy_rename
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_row_level_security_policy_rename_8cba5f5a14d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"long_form": "alter_row_level_security_policy_long_form_short", "operation": "alter_row_level_security_policy_operation_rename"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
ALTER POLICY b10_rls_existing ON b10_rls_source RENAME TO b10_rls_renamed;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_renamed ON b10_rls_source;
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_alter_row_level_security_policy_rename_57b5f746c0ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"long_form": "alter_row_level_security_policy_long_form_long", "operation": "alter_row_level_security_policy_operation_rename"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
ALTER ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source RENAME TO b10_rls_renamed;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_renamed ON b10_rls_source;
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;
