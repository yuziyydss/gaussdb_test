-- generated_from: manifest_m_create_view_basic
-- static_only: true
-- case_count: 14

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_view_basic_c141cb5e5228
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_none", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_none", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view AS SELECT id,qty FROM m_b01_view_source;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_54f5bb57e209
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_default", "force": "m_create_view_force_yes", "labels": "m_create_view_labels_two", "query": "m_create_view_query_filtered", "replace": "m_create_view_replace_none", "security": "m_create_view_security_on", "temporary": "m_create_view_temporary_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE TEMPORARY FORCE VIEW m_b01_created_view (c1,c2) WITH (security_barrier = true) AS SELECT id,qty FROM m_b01_view_source WHERE id > 0 WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_1aa68ac3c680
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_local", "force": "m_create_view_force_none", "labels": "m_create_view_labels_two", "query": "m_create_view_query_filtered", "replace": "m_create_view_replace_yes", "security": "m_create_view_security_off", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE OR REPLACE VIEW m_b01_created_view (c1,c2) WITH (security_barrier = false) AS SELECT id,qty FROM m_b01_view_source WHERE id > 0 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_6afefcea8c61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_cascaded", "force": "m_create_view_force_yes", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_yes", "security": "m_create_view_security_off", "temporary": "m_create_view_temporary_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE OR REPLACE TEMPORARY FORCE VIEW m_b01_created_view WITH (security_barrier = false) AS SELECT id,qty FROM m_b01_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_28c6479422ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_default", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_yes", "security": "m_create_view_security_on", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE OR REPLACE VIEW m_b01_created_view WITH (security_barrier = true) AS SELECT id,qty FROM m_b01_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_32e808d98060
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_none", "force": "m_create_view_force_yes", "labels": "m_create_view_labels_two", "query": "m_create_view_query_filtered", "replace": "m_create_view_replace_yes", "security": "m_create_view_security_none", "temporary": "m_create_view_temporary_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE OR REPLACE TEMPORARY FORCE VIEW m_b01_created_view (c1,c2) AS SELECT id,qty FROM m_b01_view_source WHERE id > 0;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_cb1891a488ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_cascaded", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_filtered", "replace": "m_create_view_replace_none", "security": "m_create_view_security_none", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view AS SELECT id,qty FROM m_b01_view_source WHERE id > 0 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_ffb4a5a2ec43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_local", "force": "m_create_view_force_yes", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_none", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE FORCE VIEW m_b01_created_view AS SELECT id,qty FROM m_b01_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_930a7af88e59
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_local", "force": "m_create_view_force_none", "labels": "m_create_view_labels_two", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_on", "temporary": "m_create_view_temporary_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE TEMPORARY VIEW m_b01_created_view (c1,c2) WITH (security_barrier = true) AS SELECT id,qty FROM m_b01_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_fd0be6bc5f70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_none", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_off", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view WITH (security_barrier = false) AS SELECT id,qty FROM m_b01_view_source;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_5c2cfda9a7dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_cascaded", "force": "m_create_view_force_none", "labels": "m_create_view_labels_two", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_on", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view (c1,c2) WITH (security_barrier = true) AS SELECT id,qty FROM m_b01_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_e96d180f3099
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_default", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_none", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view AS SELECT id,qty FROM m_b01_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_68f219c37b0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_none", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_on", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view WITH (security_barrier = true) AS SELECT id,qty FROM m_b01_view_source;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;

-- case_id: manifest_m_create_view_basic_4e94d1a5d450
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_create_view_check_default", "force": "m_create_view_force_none", "labels": "m_create_view_labels_none", "query": "m_create_view_query_direct", "replace": "m_create_view_replace_none", "security": "m_create_view_security_off", "temporary": "m_create_view_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_view_source (id INT, qty INT);
INSERT INTO m_b01_view_source VALUES (1,10),(2,20);
-- test_sql:
CREATE VIEW m_b01_created_view WITH (security_barrier = false) AS SELECT id,qty FROM m_b01_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_b01_created_view;
DROP TABLE m_b01_view_source;
