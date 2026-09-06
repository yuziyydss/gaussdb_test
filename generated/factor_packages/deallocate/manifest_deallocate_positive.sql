-- generated_from: manifest_deallocate_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_deallocate_positive_b9af3c8f6c60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_absent", "target": "deallocate_target_zero"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE p_ps_zero;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_deallocate_positive_309486404399
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_absent", "target": "deallocate_target_one"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE p_ps_one;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_deallocate_positive_ea81262a17e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_absent", "target": "deallocate_target_all"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE ALL;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_deallocate_positive_20669482f3ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_present", "target": "deallocate_target_zero"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE PREPARE p_ps_zero;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_deallocate_positive_4fe40315b27e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_present", "target": "deallocate_target_one"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE PREPARE p_ps_one;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_deallocate_positive_04bf651fa636
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"prepare_keyword": "deallocate_prepare_keyword_present", "target": "deallocate_target_all"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare::prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
DEALLOCATE PREPARE ALL;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
