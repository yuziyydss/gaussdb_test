-- generated_from: manifest_create_type_composite
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_type_composite_8c4eed7ce8b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_composite", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_8c4eed7c AS ();
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_type_composite_1fa7a6c2dbc1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_one", "form": "create_type_form_composite", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_1fa7a6c2 AS (col_1 INTEGER);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_type_composite_794d92008bdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_two", "form": "create_type_form_composite", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_794d9200 AS (col_1 INTEGER, col_2 TEXT);
-- fixture_teardown:
ROLLBACK;
