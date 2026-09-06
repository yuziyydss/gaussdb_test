-- generated_from: manifest_create_type_collection
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_type_collection_5ace26cbb64a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_collection", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_5ace26cb AS TABLE OF INTEGER;
-- fixture_teardown:
ROLLBACK;
