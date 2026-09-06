-- generated_from: manifest_reset_targets
-- static_only: true
-- case_count: 6

-- case_id: manifest_reset_targets_7d2ba370f8e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_parameter"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET timezone;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_reset_targets_a2510cfd2644
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_schema"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET CURRENT_SCHEMA;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_reset_targets_8834dac05352
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_timezone"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET TIME ZONE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_reset_targets_a129ec73bbf2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_isolation"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET TRANSACTION ISOLATION LEVEL;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_reset_targets_7e4892e6700c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_authorization"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET SESSION AUTHORIZATION;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_reset_targets_7e81246da11e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "reset_target_all"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set::set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
SET timezone TO 'Europe/Rome';
-- test_sql:
RESET ALL;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
