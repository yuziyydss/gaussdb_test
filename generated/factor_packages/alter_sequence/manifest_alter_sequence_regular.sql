-- generated_from: manifest_alter_sequence_regular
-- static_only: true
-- case_count: 23

-- case_id: manifest_alter_sequence_regular_556808aeaa3d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_absent"}
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
ALTER SEQUENCE seq_as_regular OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_a2a9e081de1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_next"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular MAXVALUE 102;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_ae80f785b617
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_regular"}
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
ALTER SEQUENCE seq_as_regular MAXVALUE 9223372036854775807 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_c36a3f5c8f74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_no_max"}
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
ALTER SEQUENCE seq_as_regular NO MAXVALUE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_fd414c72df56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_nomax"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular NOMAXVALUE OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_191e938f9a1e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_one"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular CACHE 1 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_91b770923c97
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_two"}
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
ALTER SEQUENCE seq_as_regular CACHE 2;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_b740ee387c40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER SEQUENCE seq_as_regular CACHE 9223372036854775807;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_0a98e75af8ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_next"}
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
ALTER SEQUENCE seq_as_regular MAXVALUE 102 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_86b57365fe5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_nomax"}
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
ALTER SEQUENCE seq_as_regular NOMAXVALUE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_dd08e07f3d23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_one"}
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
ALTER SEQUENCE seq_as_regular CACHE 1;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_ceb71765decf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_absent"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_bb2c8993accb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_regular"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular MAXVALUE 9223372036854775807;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_3f478d9c0698
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_no_max"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular NO MAXVALUE OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_bb73717a493a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_two"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular CACHE 2 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_e3cc4cf89342
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER SEQUENCE IF EXISTS seq_as_regular CACHE 9223372036854775807 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_aa65c9a91f0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_next"}
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
ALTER SEQUENCE seq_as_regular MAXVALUE 102 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_cdb49220cf7d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_max_regular"}
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
ALTER SEQUENCE seq_as_regular MAXVALUE 9223372036854775807 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_b8a7b56af1a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_no_max"}
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
ALTER SEQUENCE seq_as_regular NO MAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_18442aefb2d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_nomax"}
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
ALTER SEQUENCE seq_as_regular NOMAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_f0376b63fd22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_one"}
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
ALTER SEQUENCE seq_as_regular CACHE 1 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_dd42491129c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_two"}
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
ALTER SEQUENCE seq_as_regular CACHE 2 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_regular_106a04ae012d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_absent", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_regular", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER SEQUENCE seq_as_regular CACHE 9223372036854775807 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
