-- generated_from: manifest_m_replace_query
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_replace_query_44c96941c31b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_query", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target (id,qty) SELECT id,qty FROM m_replace_source;
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_query_1b06ceb831e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_query", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target SELECT id,qty FROM m_replace_source;
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_query_0290b7359520
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_none", "source_profile": "m_replace_source_profile_query", "target_profile": "m_replace_target_profile_implicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE m_replace_target SELECT id,qty FROM m_replace_source;
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;

-- case_id: manifest_m_replace_query_5f98c61102dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_query", "target_profile": "m_replace_target_profile_explicit", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_target(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);
INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);
CREATE TABLE m_replace_source(id INT,qty INT);
INSERT INTO m_replace_source(id,qty) VALUES (1,99),(4,40);
-- test_sql:
REPLACE INTO m_replace_target (id,qty) SELECT id,qty FROM m_replace_source;
-- fixture_teardown:
DROP TABLE m_replace_source;
DROP TABLE m_replace_target;
