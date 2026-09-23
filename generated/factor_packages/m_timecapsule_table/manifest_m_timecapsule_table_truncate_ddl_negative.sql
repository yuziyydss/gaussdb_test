-- generated_from: manifest_m_timecapsule_table_truncate_ddl_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_timecapsule_table_truncate_ddl_negative_4495244f47ce
-- expected: error
-- expected_error_category: intervening_ddl_modified_table
-- expected_sqlstates: -
-- expected_error_regex: The table definition of .* has been modified
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"intervening_ddl": "m_timecapsule_table_intervening_ddl_alter", "operation": "m_timecapsule_table_operation_truncate", "rename": "m_timecapsule_table_rename_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_timecapsule_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_and_schema_creator_with_truncate"], "fact_refs": ["m_timecapsule_table_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["verified_ordinary_permanent_astore_or_ustore"], "fact_refs": ["m_timecapsule_table_fact_storage"], "key": "table_storage"}, {"allowed_values": ["on"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "enable_recyclebin"}, {"allowed_values": ["off"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "xc_maintenance_mode"}, {"allowed_values": ["retained_object_with_intervening_ddl"], "fact_refs": ["m_timecapsule_table_fact_switches"], "key": "recyclebin_state"}]
-- fixture_setup:
CREATE SCHEMA m_timecapsule_namespace;
CREATE TABLE m_timecapsule_namespace.source (id INTEGER, qty INTEGER);
INSERT INTO m_timecapsule_namespace.source VALUES (1,10),(2,20);
TRUNCATE TABLE m_timecapsule_namespace.source;
ALTER TABLE m_timecapsule_namespace.source ADD COLUMN ddl_marker INTEGER;
-- test_sql:
TIMECAPSULE TABLE m_timecapsule_namespace.source TO BEFORE TRUNCATE;
-- fixture_teardown:
DROP TABLE IF EXISTS m_timecapsule_namespace.source PURGE;
DROP TABLE IF EXISTS m_timecapsule_namespace.restored PURGE;
DROP SCHEMA m_timecapsule_namespace;
