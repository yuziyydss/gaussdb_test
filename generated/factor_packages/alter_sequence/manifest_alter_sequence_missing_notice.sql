-- generated_from: manifest_alter_sequence_missing_notice
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_sequence_missing_notice_50fc60f9c60e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_missing", "setting": "alter_sequence_setting_max_next"}
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
ALTER SEQUENCE IF EXISTS seq_as_missing MAXVALUE 102;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
