-- generated_from: manifest_alter_sequence_owner
-- static_only: true
-- case_count: 5

-- case_id: manifest_alter_sequence_owner_a27bb11acad9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_owner", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_absent"}
-- environment_requirements: [{"allowed_values": ["fp_as_owner"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "prepared_owner_role"}, {"allowed_values": ["true"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "owner_membership_and_schema_create"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER SEQUENCE seq_as_regular OWNER TO fp_as_owner;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_owner_6d8572eae659
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_owner", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_absent"}
-- environment_requirements: [{"allowed_values": ["fp_as_owner"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "prepared_owner_role"}, {"allowed_values": ["true"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "owner_membership_and_schema_create"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER LARGE SEQUENCE IF EXISTS seq_as_large OWNER TO fp_as_owner;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_owner_ded2aa0c83d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_owner", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_absent"}
-- environment_requirements: [{"allowed_values": ["fp_as_owner"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "prepared_owner_role"}, {"allowed_values": ["true"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "owner_membership_and_schema_create"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER SEQUENCE seq_as_large OWNER TO fp_as_owner;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_owner_6e3f0bdd0f7e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_owner", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_absent"}
-- environment_requirements: [{"allowed_values": ["fp_as_owner"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "prepared_owner_role"}, {"allowed_values": ["true"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "owner_membership_and_schema_create"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER SEQUENCE IF EXISTS seq_as_regular OWNER TO fp_as_owner;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_owner_9a6ea6a24e70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_owner", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_absent"}
-- environment_requirements: [{"allowed_values": ["fp_as_owner"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "prepared_owner_role"}, {"allowed_values": ["true"], "fact_refs": ["alter_sequence_fact_new_owner"], "key": "owner_membership_and_schema_create"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_as_regular START 101 CACHE 1;
CREATE LARGE SEQUENCE seq_as_large START 101 CACHE 1;
SELECT nextval('seq_as_regular');
SELECT nextval('seq_as_large');
DROP SEQUENCE IF EXISTS seq_as_missing;
-- test_sql:
ALTER LARGE SEQUENCE seq_as_large OWNER TO fp_as_owner;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
