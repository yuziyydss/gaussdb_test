-- generated_from: manifest_drop_type_unreferenced
-- static_only: true
-- case_count: 9

-- case_id: manifest_drop_type_unreferenced_0eab971da67a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_default", "if_exists": "drop_type_if_exists_no", "targets": "drop_type_targets_composite"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE type_comp_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_4e4d743da582
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_restrict", "if_exists": "drop_type_if_exists_no", "targets": "drop_type_targets_enum"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE type_enum_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_26301ba168de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_cascade", "if_exists": "drop_type_if_exists_no", "targets": "drop_type_targets_both"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE type_comp_b7, type_enum_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_48af99e78164
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_default", "if_exists": "drop_type_if_exists_yes", "targets": "drop_type_targets_enum"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE IF EXISTS type_enum_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_38e9b95d32f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_restrict", "if_exists": "drop_type_if_exists_yes", "targets": "drop_type_targets_composite"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE IF EXISTS type_comp_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_862f00810f0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_default", "if_exists": "drop_type_if_exists_yes", "targets": "drop_type_targets_both"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE IF EXISTS type_comp_b7, type_enum_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_50bc4a877e7a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_cascade", "if_exists": "drop_type_if_exists_yes", "targets": "drop_type_targets_composite"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE IF EXISTS type_comp_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_878b1df1d8a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_restrict", "if_exists": "drop_type_if_exists_no", "targets": "drop_type_targets_both"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE type_comp_b7, type_enum_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_type_unreferenced_3eb21d3dbb1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_type_behavior_cascade", "if_exists": "drop_type_if_exists_no", "targets": "drop_type_targets_enum"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_type_fact_privilege"], "key": "type_drop_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TYPE type_comp_b7 AS (col_1 INTEGER, col_2 TEXT);
CREATE TYPE type_enum_b7 AS ENUM ('open', 'closed');
-- test_sql:
DROP TYPE type_enum_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;
