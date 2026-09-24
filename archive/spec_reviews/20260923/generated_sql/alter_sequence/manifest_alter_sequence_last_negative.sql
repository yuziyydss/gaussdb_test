-- generated_from: manifest_alter_sequence_last_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_sequence_last_negative_2ad7cbf0ba08
-- expected: error
-- expected_error_category: maximum_not_above_last_value
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_equal"}
-- environment_requirements: [{"allowed_values": ["top_level_autocommit"], "fact_refs": ["alter_sequence_fact_max_context"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER SEQUENCE seq_as_regular MAXVALUE 101;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_last_negative_5fb424400429
-- expected: error
-- expected_error_category: maximum_not_above_last_value
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_below"}
-- environment_requirements: [{"allowed_values": ["top_level_autocommit"], "fact_refs": ["alter_sequence_fact_max_context"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER SEQUENCE seq_as_regular MAXVALUE 100;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
