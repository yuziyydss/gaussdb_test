-- generated_from: manifest_m_autohint_purge_dedicated_history
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_autohint_purge_dedicated_history_5d66655b8149
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_purge_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_purge_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["dedicated_disposable_instance_no_foreign_hint_models"], "fact_refs": ["m_autohint_purge_fact_authority"], "key": "instance_effect_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT PURGE;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;
