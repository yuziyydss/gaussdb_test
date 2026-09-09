-- generated_from: manifest_m_comment_view
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_comment_view_270ab3f585b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_view", "text": "m_comment_text_basic"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
COMMENT ON VIEW m_b01_view IS 'm finite comment';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_view_f2b99f33f2b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_view", "text": "m_comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
COMMENT ON VIEW m_b01_view IS '测试注释';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_comment_view_296f68e14c94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_view", "text": "m_comment_text_clear"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
COMMENT ON VIEW m_b01_view IS NULL;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
