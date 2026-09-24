-- generated_from: manifest_drop_row_level_security_policy_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_row_level_security_policy_existing_861d81d43188
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_none", "if_exists": "drop_row_level_security_policy_if_exists_none", "long_form": "drop_row_level_security_policy_long_form_short", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP POLICY b10_rls_existing ON b10_rls_source;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_drop_row_level_security_policy_existing_5f4f89a769b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_restrict", "if_exists": "drop_row_level_security_policy_if_exists_yes", "long_form": "drop_row_level_security_policy_long_form_long", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source RESTRICT;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_drop_row_level_security_policy_existing_01053ff3323d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_cascade", "if_exists": "drop_row_level_security_policy_if_exists_yes", "long_form": "drop_row_level_security_policy_long_form_short", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP POLICY IF EXISTS b10_rls_existing ON b10_rls_source CASCADE;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_drop_row_level_security_policy_existing_4407646521a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_cascade", "if_exists": "drop_row_level_security_policy_if_exists_none", "long_form": "drop_row_level_security_policy_long_form_long", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source CASCADE;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_drop_row_level_security_policy_existing_69ec67deb5be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_restrict", "if_exists": "drop_row_level_security_policy_if_exists_none", "long_form": "drop_row_level_security_policy_long_form_short", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP POLICY b10_rls_existing ON b10_rls_source RESTRICT;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;

-- case_id: manifest_drop_row_level_security_policy_existing_778bcd538c84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_row_level_security_policy_behavior_none", "if_exists": "drop_row_level_security_policy_if_exists_yes", "long_form": "drop_row_level_security_policy_long_form_long", "policy_name": "drop_row_level_security_policy_policy_name_existing"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_row_level_security_policy_fact_privilege"], "key": "table_owner_or_admin"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_rls_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO b10_rls_source VALUES (1,2),(0,3),(NULL,4);
ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;
CREATE ROW LEVEL SECURITY POLICY b10_rls_existing ON b10_rls_source USING (col_1 > 0);
-- test_sql:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
-- fixture_teardown:
DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;
ROLLBACK;
