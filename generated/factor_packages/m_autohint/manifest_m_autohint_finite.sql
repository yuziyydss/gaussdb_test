-- generated_from: manifest_m_autohint_finite
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_autohint_finite_bb09c06a7a44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_explore", "debug": "m_autohint_debug_off", "query": "m_autohint_query_all", "verbose": "m_autohint_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE TRUE, VERBOSE FALSE, SQLPATCH FALSE, TEST FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_finite_cefc282a39f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_history", "debug": "m_autohint_debug_on", "query": "m_autohint_query_all", "verbose": "m_autohint_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE FALSE, VERBOSE TRUE, SQLPATCH FALSE, TEST FALSE, DEBUG TRUE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_finite_b9ed18a22229
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_explore", "debug": "m_autohint_debug_on", "query": "m_autohint_query_filtered", "verbose": "m_autohint_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE TRUE, VERBOSE FALSE, SQLPATCH FALSE, TEST FALSE, DEBUG TRUE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_finite_dacb065715c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_history", "debug": "m_autohint_debug_off", "query": "m_autohint_query_filtered", "verbose": "m_autohint_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE FALSE, VERBOSE TRUE, SQLPATCH FALSE, TEST FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_finite_b59232d60bc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_explore", "debug": "m_autohint_debug_off", "query": "m_autohint_query_all", "verbose": "m_autohint_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE TRUE, VERBOSE TRUE, SQLPATCH FALSE, TEST FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;

-- case_id: manifest_m_autohint_finite_fe2b205ff341
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_autohint_analyze_history", "debug": "m_autohint_debug_off", "query": "m_autohint_query_all", "verbose": "m_autohint_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_autohint_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_autohint_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["exclusive_disposable_database_and_query_signatures"], "fact_refs": ["m_autohint_fact_authority"], "key": "hint_history_scope"}]
-- fixture_setup:
CREATE TABLE m_autohint_left (id INTEGER, qty INTEGER);
CREATE TABLE m_autohint_right (id INTEGER, qty INTEGER);
INSERT INTO m_autohint_left VALUES (1,10),(2,20),(3,30);
INSERT INTO m_autohint_right VALUES (1,10),(2,20),(3,30);
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
-- test_sql:
AUTOHINT (ANALYZE FALSE, VERBOSE FALSE, SQLPATCH FALSE, TEST FALSE, DEBUG FALSE) SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
-- fixture_teardown:
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id;
AUTOHINT DROP SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10;
DROP TABLE m_autohint_right;
DROP TABLE m_autohint_left;
