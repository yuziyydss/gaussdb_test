-- generated_from: manifest_m_alter_table_partition_maintenance
-- static_only: true
-- case_count: 18

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_partition_maintenance_2748032f6559
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_add", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source ADD PARTITION (PARTITION p_new VALUES LESS THAN (40));
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_5c4160513b8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_drop", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source DROP PARTITION p_low;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_195b21e04aeb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_truncate", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_9bc432002e08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_truncate_for", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source TRUNCATE PARTITION FOR (11);
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_06d893ec7d3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_analyze", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source ANALYZE PARTITION p_mid;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_89f1ee81704f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_rename", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source RENAME PARTITION p_mid TO p_renamed;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_8777d0374aee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_rename_for", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source RENAME PARTITION FOR (11) TO p_renamed;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_524c7915a72f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_split", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source SPLIT PARTITION p_mid AT (15) INTO (PARTITION p_mid_a, PARTITION p_mid_b);
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_ec4d049637e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_merge", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source MERGE PARTITIONS p_low, p_mid INTO PARTITION p_merged;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_fe49645c2c94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_add", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source ADD PARTITION (PARTITION p_new VALUES LESS THAN (40));
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_0943e87fbc4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_drop", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source DROP PARTITION p_low;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_d2d02bbe3ecd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_truncate", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_23d8f7461c05
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_truncate_for", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source TRUNCATE PARTITION FOR (11);
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_bf1868064b93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_analyze", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source ANALYZE PARTITION p_mid;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_cdfd026e6343
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_rename", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source RENAME PARTITION p_mid TO p_renamed;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_c905daf0b18e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_rename_for", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source RENAME PARTITION FOR (11) TO p_renamed;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_e0f0d8515351
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_split", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source SPLIT PARTITION p_mid AT (15) INTO (PARTITION p_mid_a, PARTITION p_mid_b);
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;

-- case_id: manifest_m_alter_table_partition_maintenance_2dcd3bd03309
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_table_partition_action_merge", "if_exists": "m_alter_table_partition_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE IF EXISTS m_b06_range_source MERGE PARTITIONS p_low, p_mid INTO PARTITION p_merged;
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;
