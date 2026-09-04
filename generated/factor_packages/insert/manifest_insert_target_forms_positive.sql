-- generated_from: manifest_insert_target_forms_positive
-- static_only: true
-- case_count: 40

-- case_id: manifest_insert_target_forms_positive_9cb9e571dc87
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_default_values", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_d6e24ff06488
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_as_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst VALUES (101, 'alpha') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_034b3645e42b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_many", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) VALUES (102, 'beta'), (103, 'gamma') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_6a8d41da618b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_alias_bare_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_d1dec73b96aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO v_insert_target (id, note) SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_2f6d368ecb53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_default_values", "target_profile": "insert_target_view_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target AS vdst (vdst.id, vdst.note) DEFAULT VALUES RETURNING *;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_ba71c423af85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_default_values", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) DEFAULT VALUES RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_28d6d839e49e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_subquery_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (sq.id, sq.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_aac58b2a3b0d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) VALUES (101, 'alpha') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_9560b98dee25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_many", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) VALUES (102, 'beta'), (103, 'gamma') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_5da5465a46bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_alias_as_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_ad36d5fb5b3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_value_many", "target_profile": "insert_target_alias_as_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst VALUE (104, 'delta'), (105, DEFAULT) RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_10972c4dd7de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_value_many", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) VALUE (104, 'delta'), (105, DEFAULT) RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_b13f71704e64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_query", "target_profile": "insert_target_alias_bare_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target dst SELECT col_1, name FROM t_insert_source RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_97c22129e799
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_query", "target_profile": "insert_target_view_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO v_insert_target AS vdst (vdst.id, vdst.note) SELECT col_1, name FROM t_insert_source RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_4796729b7226
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_default_values", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_e46c95be5a4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_default_values", "target_profile": "insert_target_alias_bare_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst DEFAULT VALUES RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_c512c9ae3b45
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_default_values", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) DEFAULT VALUES RETURNING *;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_6bc34fff9178
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_one", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUES (101, 'alpha') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_87d1a20a614f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_view_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target AS vdst (vdst.id, vdst.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_819f662a451e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_d2c1e56cd71b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_many", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) VALUES (102, 'beta'), (103, 'gamma') RETURNING *;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_627cc38e1ded
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_default_values", "target_profile": "insert_target_subquery_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (sq.id, sq.note) DEFAULT VALUES RETURNING *;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_171938391064
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_many", "target_profile": "insert_target_subquery_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (sq.id, sq.note) VALUES (102, 'beta'), (103, 'gamma') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_3d718b759323
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_197cc717eccb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_9ce47a28ed55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_default_values", "target_profile": "insert_target_alias_as_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_a98c9a58dc95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_alias_as_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target AS dst SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_7a3fcb7d7915
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_4d2fb00846bd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_7c90af7b7887
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_bare_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_2ca0b69bce9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_alias_bare_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_9479a5625e74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_9bd1b605845e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_981981c51b81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_view_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target AS vdst (vdst.id, vdst.note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_4fdb69161199
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_view_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target AS vdst (vdst.id, vdst.note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_93942a96482f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_6c98e38d4852
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_587a29b59be7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_subquery_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (sq.id, sq.note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_66261d4c81fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_subquery_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (sq.id, sq.note) SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
