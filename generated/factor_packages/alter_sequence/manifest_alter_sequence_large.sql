-- generated_from: manifest_alter_sequence_large
-- static_only: true
-- case_count: 29

-- case_id: manifest_alter_sequence_large_3814967b94ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_absent"}
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
ALTER LARGE SEQUENCE seq_as_large OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_dab502821254
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_next"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large MAXVALUE 102;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_9df7f6ec4d5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_regular"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 9223372036854775807 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_c480f276e81f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_large"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 170141183460469231731687303715884105727;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_30ae2d2a5428
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_no_max"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large NO MAXVALUE OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_8f22c2063f5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_nomax"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large NOMAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_6b572aa4690d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_one"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 1;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_cf89a803aa24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_two"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 2;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_259bc119df5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 9223372036854775807;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_d40e10c7000d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_large"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 170141183460469231731687303715884105727;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_df3db9874b77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_next"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 102 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_61fc4a752a33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_no_max"}
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
ALTER LARGE SEQUENCE seq_as_large NO MAXVALUE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_3b739dba766d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_nomax"}
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
ALTER LARGE SEQUENCE seq_as_large NOMAXVALUE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_66b8db235464
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_absent"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_426d7ca51ad5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_absent", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_regular"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large MAXVALUE 9223372036854775807;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_3a186d4a106a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_large"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large MAXVALUE 170141183460469231731687303715884105727 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_085155048403
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_one"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large CACHE 1 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_e83145161796
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_two"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large CACHE 2 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_7477e840b4c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large CACHE 9223372036854775807 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_c2c18575513c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_present", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_large"}
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
ALTER LARGE SEQUENCE IF EXISTS seq_as_large CACHE 170141183460469231731687303715884105727 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_b28733550c03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_next"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 102 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_f5fa1cb3c42a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_regular"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 9223372036854775807 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_f3ab6d7ad4bd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_max_large"}
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
ALTER LARGE SEQUENCE seq_as_large MAXVALUE 170141183460469231731687303715884105727 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_6755278d5854
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_no_max"}
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
ALTER LARGE SEQUENCE seq_as_large NO MAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_08d0c1f93dbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_column", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_nomax"}
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
ALTER LARGE SEQUENCE seq_as_large NOMAXVALUE OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_862a35116c9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_one"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 1 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_9ffc185a43d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_two"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 2 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_0bde43d4a310
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_regular"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 9223372036854775807 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_alter_sequence_large_618f7a756461
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_sequence_form_settings", "if_exists": "alter_sequence_if_exists_absent", "large_modifier": "alter_sequence_large_modifier_present", "new_owner": "alter_sequence_new_owner_role", "owned_by": "alter_sequence_owned_by_none", "sequence_name": "alter_sequence_sequence_name_large", "setting": "alter_sequence_setting_cache_large"}
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
ALTER LARGE SEQUENCE seq_as_large CACHE 170141183460469231731687303715884105727 OWNED BY NONE;
-- fixture_teardown:
DROP LARGE SEQUENCE IF EXISTS seq_as_large;
DROP SEQUENCE IF EXISTS seq_as_regular;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
