-- generated_from: manifest_m_replace_values
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_replace_values_a2c7e058a140
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_new", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target (id,qty) VALUES (4,40);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_02accd9488d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_conflict", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target VALUE (1,99);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_6bd9d32a13a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_default", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target (id,qty) VALUE (1,DEFAULT);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_cd250382c5de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_many", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target VALUES (1,99), (4,40);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_ff733bc16b69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_many", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target (id,qty) VALUE (1,99), (4,40);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_878ebbadf3ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_default", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target VALUES (1,DEFAULT);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_d6650faa7844
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_conflict", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target (id,qty) VALUES (1,99);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_values_1eb63893c7dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_new", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target VALUE (4,40);
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;
