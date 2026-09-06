-- generated_from: manifest_prepare_families
-- static_only: true
-- case_count: 12

-- case_id: manifest_prepare_families_5fbc18d86b33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_select"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS SELECT CAST($1 AS INTEGER) AS a;
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_ce9dd9b86d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_insert"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS INSERT INTO t_prepare_source (id) VALUES (CAST($1 AS INTEGER) + 1);
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_1c326578568e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_update"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS UPDATE t_prepare_source SET note = 'updated' WHERE id = CAST($1 AS INTEGER) + 1;
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_d071911693e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_delete"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS DELETE FROM t_prepare_source WHERE id = CAST($1 AS INTEGER);
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_3985d4bab707
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_merge"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS MERGE INTO t_prepare_source t USING (SELECT CAST($1 AS INTEGER) AS id) s ON (t.id = s.id) WHEN MATCHED THEN UPDATE SET note = 'updated';
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_7cb7ffd13b1e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_values"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS VALUES (CAST($1 AS INTEGER));
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_3b9ed0c505d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_select"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS SELECT CAST($1 AS INTEGER) + 1 AS a;
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_bf13a8159e5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_insert"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS INSERT INTO t_prepare_source (id) VALUES (CAST($1 AS INTEGER));
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_4f2bb815d4db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_update"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS UPDATE t_prepare_source SET note = 'updated' WHERE id = CAST($1 AS INTEGER);
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_57caf4612acd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_delete"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new AS DELETE FROM t_prepare_source WHERE id = CAST($1 AS INTEGER) + 1;
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_fedf5505a883
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_merge"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS MERGE INTO t_prepare_source t USING (SELECT CAST($1 AS INTEGER) + 1 AS id) s ON (t.id = s.id) WHEN MATCHED THEN UPDATE SET note = 'updated';
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_prepare_families_891a9dcd22f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_values"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
-- test_sql:
PREPARE p_ps_new(INTEGER) AS VALUES (CAST($1 AS INTEGER) + 1);
-- fixture_teardown:
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
