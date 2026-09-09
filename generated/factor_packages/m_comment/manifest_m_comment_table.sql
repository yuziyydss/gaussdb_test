-- generated_from: manifest_m_comment_table
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_comment_table_b4e773c86282
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_table", "text": "m_comment_text_basic"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON TABLE m_b01_source IS 'm finite comment';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_table_065037ea4ef0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_table", "text": "m_comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON TABLE m_b01_source IS '测试注释';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_table_3386551bf0ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_table", "text": "m_comment_text_clear"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON TABLE m_b01_source IS NULL;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_table_2f230b3802e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_column", "text": "m_comment_text_basic"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON COLUMN m_b01_source.id IS 'm finite comment';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_table_20b02dd51fb4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_column", "text": "m_comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON COLUMN m_b01_source.id IS '测试注释';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_table_2347c8bf87fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_column", "text": "m_comment_text_clear"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
COMMENT ON COLUMN m_b01_source.id IS NULL;
-- fixture_teardown:
DROP TABLE m_b01_source;
