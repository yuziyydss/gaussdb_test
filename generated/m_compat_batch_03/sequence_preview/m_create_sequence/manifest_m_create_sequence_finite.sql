-- generated_from: manifest_m_create_sequence_finite
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_sequence_finite_982849416af6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_default", "cycle": "m_create_sequence_cycle_default", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START WITH -1;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_697c6cb6fc76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_one", "cycle": "m_create_sequence_cycle_cycle", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_none", "start": "m_create_sequence_start_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START 1 CACHE 1 CYCLE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_3b269c136412
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_one", "cycle": "m_create_sequence_cycle_no", "increment": "m_create_sequence_increment_down", "owned": "m_create_sequence_owned_column", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT -1 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 1 NO CYCLE OWNED BY m_create_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_2ee9156bb85e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_four", "cycle": "m_create_sequence_cycle_compact", "increment": "m_create_sequence_increment_down", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT -1 MINVALUE -10 MAXVALUE 10 START 1 CACHE 4 NOCYCLE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_72ebd61cf923
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_default", "cycle": "m_create_sequence_cycle_compact", "increment": "m_create_sequence_increment_step", "owned": "m_create_sequence_owned_none", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 2 MINVALUE -10 MAXVALUE 10 START WITH -1 NOCYCLE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_0f921ea37f0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_four", "cycle": "m_create_sequence_cycle_default", "increment": "m_create_sequence_increment_step", "owned": "m_create_sequence_owned_column", "start": "m_create_sequence_start_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 2 MINVALUE -10 MAXVALUE 10 START 1 CACHE 4 OWNED BY m_create_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_d9143373eace
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_four", "cycle": "m_create_sequence_cycle_cycle", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_column", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 4 CYCLE OWNED BY m_create_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_897b66829306
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_default", "cycle": "m_create_sequence_cycle_no", "increment": "m_create_sequence_increment_down", "owned": "m_create_sequence_owned_none", "start": "m_create_sequence_start_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT -1 MINVALUE -10 MAXVALUE 10 START 1 NO CYCLE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_f0565182117a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_one", "cycle": "m_create_sequence_cycle_cycle", "increment": "m_create_sequence_increment_step", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 2 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 1 CYCLE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_1e48af7bb519
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_default", "cycle": "m_create_sequence_cycle_compact", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_column", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START WITH -1 NOCYCLE OWNED BY m_create_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_a13451e3b2db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_four", "cycle": "m_create_sequence_cycle_no", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 4 NO CYCLE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_56a465c61624
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_one", "cycle": "m_create_sequence_cycle_default", "increment": "m_create_sequence_increment_down", "owned": "m_create_sequence_owned_none", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT -1 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 1 OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_1d5775f5f358
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_default", "cycle": "m_create_sequence_cycle_cycle", "increment": "m_create_sequence_increment_down", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT -1 MINVALUE -10 MAXVALUE 10 START WITH -1 CYCLE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_2cd95df5bb11
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_four", "cycle": "m_create_sequence_cycle_no", "increment": "m_create_sequence_increment_step", "owned": "m_create_sequence_owned_none", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 2 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 4 NO CYCLE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;

-- case_id: manifest_m_create_sequence_finite_3bbb27fcb5a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_create_sequence_cache_one", "cycle": "m_create_sequence_cycle_compact", "increment": "m_create_sequence_increment_up", "owned": "m_create_sequence_owned_default", "start": "m_create_sequence_start_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_create_sequence_owner (id INT);
-- test_sql:
CREATE SEQUENCE m_create_sequence_new INCREMENT BY 1 MINVALUE -10 MAXVALUE 10 START WITH -1 CACHE 1 NOCYCLE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_create_sequence_new;
DROP TABLE m_create_sequence_owner;
