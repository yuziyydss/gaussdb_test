-- generated_from: manifest_m_drop_index_on_table
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_index_on_table_6409e1674eb3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_default", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index ON m_b01_source;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_c18ef07582b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_cascade", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_algorithm", "targets": "m_drop_index_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index, m_b03_existing_index_two CASCADE ON m_b01_source ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_0bc73b1ecdb1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_restrict", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_lock", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index RESTRICT ON m_b01_source LOCK DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_37ef35012680
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_default", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_lock", "targets": "m_drop_index_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index, m_b03_existing_index_two ON m_b01_source LOCK DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_9ae3c7f5069b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_restrict", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index, m_b03_existing_index_two RESTRICT ON m_b01_source;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_37f968d3cb7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_default", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_algorithm", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index ON m_b01_source ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_a5124a82495a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_cascade", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_none", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index CASCADE ON m_b01_source;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_38be5088ebd2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_cascade", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_lock", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index CASCADE ON m_b01_source LOCK DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_index_on_table_3613463ebd02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_index_dependency_restrict", "form": "m_drop_index_form_on_table", "if_exists": "m_drop_index_if_exists_none", "online": "m_drop_index_online_off", "tail": "m_drop_index_tail_algorithm", "targets": "m_drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
DROP INDEX m_b03_existing_index RESTRICT ON m_b01_source ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;
