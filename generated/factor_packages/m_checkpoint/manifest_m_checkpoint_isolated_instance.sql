-- generated_from: manifest_m_checkpoint_isolated_instance
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_checkpoint_isolated_instance_83d2dda3e21c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "m_checkpoint_command_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_checkpoint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin_or_operations_admin"], "fact_refs": ["m_checkpoint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["disposable_instance_checkpoint_explicitly_reviewed"], "fact_refs": ["m_checkpoint_fact_scope"], "key": "instance_effect_scope"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CHECKPOINT;
-- fixture_teardown:
DROP TABLE m_b01_source;
