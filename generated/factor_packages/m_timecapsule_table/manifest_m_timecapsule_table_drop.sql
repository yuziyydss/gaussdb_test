-- generated_from: manifest_m_timecapsule_table_drop
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_timecapsule_table_drop_2afa12fa1fb9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "m_timecapsule_table_operation_drop", "rename": "m_timecapsule_table_rename_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_timecapsule_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_and_schema_creator_with_truncate"], "fact_refs": ["m_timecapsule_table_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["verified_ordinary_permanent_astore_or_ustore"], "fact_refs": ["m_timecapsule_table_fact_storage"], "key": "table_storage"}, {"allowed_values": ["on"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "enable_recyclebin"}, {"allowed_values": ["off"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "xc_maintenance_mode"}, {"allowed_values": ["new_case_namespace_retained_object_supported_baseline_no_intervening_ddl"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "recyclebin_state"}]
-- fixture_setup:
CREATE SCHEMA m_timecapsule_namespace;
CREATE TABLE m_timecapsule_namespace.source (id INTEGER, qty INTEGER);
INSERT INTO m_timecapsule_namespace.source VALUES (1,10),(2,20);
DROP TABLE m_timecapsule_namespace.source;
-- test_sql:
TIMECAPSULE TABLE m_timecapsule_namespace.source TO BEFORE DROP;
-- fixture_teardown:
DROP TABLE IF EXISTS m_timecapsule_namespace.source PURGE;
DROP TABLE IF EXISTS m_timecapsule_namespace.restored PURGE;
DROP SCHEMA m_timecapsule_namespace;

-- case_id: manifest_m_timecapsule_table_drop_0d343e5d3125
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "m_timecapsule_table_operation_drop", "rename": "m_timecapsule_table_rename_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_timecapsule_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_and_schema_creator_with_truncate"], "fact_refs": ["m_timecapsule_table_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["verified_ordinary_permanent_astore_or_ustore"], "fact_refs": ["m_timecapsule_table_fact_storage"], "key": "table_storage"}, {"allowed_values": ["on"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "enable_recyclebin"}, {"allowed_values": ["off"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "xc_maintenance_mode"}, {"allowed_values": ["new_case_namespace_retained_object_supported_baseline_no_intervening_ddl"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "recyclebin_state"}]
-- fixture_setup:
CREATE SCHEMA m_timecapsule_namespace;
CREATE TABLE m_timecapsule_namespace.source (id INTEGER, qty INTEGER);
INSERT INTO m_timecapsule_namespace.source VALUES (1,10),(2,20);
DROP TABLE m_timecapsule_namespace.source;
-- test_sql:
TIMECAPSULE TABLE m_timecapsule_namespace.source TO BEFORE DROP RENAME TO restored;
-- fixture_teardown:
DROP TABLE IF EXISTS m_timecapsule_namespace.source PURGE;
DROP TABLE IF EXISTS m_timecapsule_namespace.restored PURGE;
DROP SCHEMA m_timecapsule_namespace;
