-- generated_from: manifest_m_do_restricted_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_do_restricted_finite_57ef4e462a71
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "m_do_operation_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_do_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_do_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_do_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["plpgsql_available_and_authorized"], "fact_refs": ["m_do_fact_language"], "key": "procedural_language"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DO 'BEGIN UPDATE m_b01_source SET qty = qty + 1 WHERE id = 1; END;';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_do_restricted_finite_ca8ed20bfa7a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "m_do_operation_insert"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_do_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_do_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_do_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["plpgsql_available_and_authorized"], "fact_refs": ["m_do_fact_language"], "key": "procedural_language"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DO 'BEGIN INSERT INTO m_b01_source (id, qty) VALUES (4, 40); END;';
-- fixture_teardown:
DROP TABLE m_b01_source;
