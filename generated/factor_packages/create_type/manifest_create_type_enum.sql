-- generated_from: manifest_create_type_enum
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_type_enum_b49270910c38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_enum", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_b4927091 AS ENUM ();
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_type_enum_d9e09250886e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_enum", "labels": "create_type_labels_one"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_d9e09250 AS ENUM ('open');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_type_enum_9787ce4914e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_enum", "labels": "create_type_labels_three"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_9787ce49 AS ENUM ('open', 'changed', 'closed');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_type_enum_032ccf1348a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_enum", "labels": "create_type_labels_max_ascii"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_032ccf13 AS ENUM ('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
-- fixture_teardown:
ROLLBACK;
