-- generated_from: manifest_m_purge_owned_table
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_purge_owned_table_076a784c0dc0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_purge_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_and_schema_creator"], "fact_refs": ["m_purge_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_purge_fact_recyclebin"], "key": "enable_recyclebin"}, {"allowed_values": ["new_case_namespace_no_name_collision_retention_not_expired"], "fact_refs": ["m_purge_fact_recyclebin"], "key": "recyclebin_state"}]
-- fixture_setup:
CREATE SCHEMA m_purge_namespace;
CREATE TABLE m_purge_namespace.source (id INTEGER, qty INTEGER);
INSERT INTO m_purge_namespace.source VALUES (1,10),(2,20);
DROP TABLE m_purge_namespace.source;
-- test_sql:
PURGE TABLE m_purge_namespace.source;
-- fixture_teardown:
DROP SCHEMA m_purge_namespace;
