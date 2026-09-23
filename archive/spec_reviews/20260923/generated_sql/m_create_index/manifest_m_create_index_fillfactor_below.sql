-- generated_from: manifest_m_create_index_fillfactor_below
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_index_fillfactor_below_647191bd47e0
-- expected: error
-- expected_error_category: fillfactor
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_below", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id ) WITH (fillfactor=9);
-- fixture_teardown:
DROP TABLE m_b01_source;
