-- generated_from: manifest_insert_declared_default_positive
-- static_only: true
-- case_count: 9

-- case_id: manifest_insert_declared_default_positive_da5961aa2785
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_default_values", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults DEFAULT VALUES;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_d907b2b896e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUES (DEFAULT, 'uses default') RETURNING *;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_0af00d959f06
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_value_many", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUE (104, 'delta'), (105, DEFAULT) RETURNING id, note AS inserted_note;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_21e5539cd4de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_default_values", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults DEFAULT VALUES RETURNING *;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_ad196d02c965
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_default_values", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults DEFAULT VALUES RETURNING id, note AS inserted_note;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_7c3b646fbdbd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUES (DEFAULT, 'uses default');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_f6e750fb62fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUES (DEFAULT, 'uses default') RETURNING id, note AS inserted_note;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_6e913530ecbf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_insert_declared_default_positive_30559b2556a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_value_many", "target_profile": "insert_target_declared_defaults", "with_clause": "insert_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_insert_declared_defaults (id INTEGER DEFAULT 701, note VARCHAR(64) DEFAULT 'declared');
-- test_sql:
INSERT INTO t_insert_declared_defaults VALUE (104, 'delta'), (105, DEFAULT) RETURNING *;
-- fixture_teardown:
ROLLBACK;
