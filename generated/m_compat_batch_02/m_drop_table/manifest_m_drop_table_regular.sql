-- generated_from: manifest_m_drop_table_regular
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_table_regular_d60a6ed86e57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_none", "if_exists": "m_drop_table_if_exists_none", "purge": "m_drop_table_purge_none", "targets": "m_drop_table_targets_one", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE m_drop_table_a;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_c6ff2fdafd46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_cascade", "if_exists": "m_drop_table_if_exists_yes", "purge": "m_drop_table_purge_yes", "targets": "m_drop_table_targets_two", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE IF EXISTS m_drop_table_a, m_drop_table_b CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_4b0943da4fa5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_restrict", "if_exists": "m_drop_table_if_exists_none", "purge": "m_drop_table_purge_yes", "targets": "m_drop_table_targets_one", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE m_drop_table_a RESTRICT PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_38b8f579b8f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_restrict", "if_exists": "m_drop_table_if_exists_yes", "purge": "m_drop_table_purge_none", "targets": "m_drop_table_targets_two", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE IF EXISTS m_drop_table_a, m_drop_table_b RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_b24653f9610e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_cascade", "if_exists": "m_drop_table_if_exists_none", "purge": "m_drop_table_purge_none", "targets": "m_drop_table_targets_one", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE m_drop_table_a CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_f328f936df68
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_none", "if_exists": "m_drop_table_if_exists_none", "purge": "m_drop_table_purge_yes", "targets": "m_drop_table_targets_two", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE m_drop_table_a, m_drop_table_b PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;

-- case_id: manifest_m_drop_table_regular_5473ebe9be7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_table_dependency_none", "if_exists": "m_drop_table_if_exists_yes", "purge": "m_drop_table_purge_none", "targets": "m_drop_table_targets_one", "temporary": "m_drop_table_temporary_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_drop_table_a (id INT);
CREATE TABLE m_drop_table_b (id INT);
-- test_sql:
DROP TABLE IF EXISTS m_drop_table_a;
-- fixture_teardown:
DROP TABLE IF EXISTS m_drop_table_a;
DROP TABLE IF EXISTS m_drop_table_b;
