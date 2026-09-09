-- generated_from: manifest_m_autohint_drop_existing_history
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_autohint_drop_existing_history_62484da49427
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"query": "m_autohint_drop_query_all"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_drop_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_drop_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_drop_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_drop_existing_history_bf5944092a2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"query": "m_autohint_drop_query_filtered"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_drop_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_drop_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_drop_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;
