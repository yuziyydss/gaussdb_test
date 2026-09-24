-- generated_from: manifest_drop_cast_owned_conversion
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_cast_owned_conversion_ae9dfd08b6a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_none", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST (double precision AS timestamp with time zone);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_cast_owned_conversion_f7b3f1c80079
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_cascade", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST IF EXISTS (double precision AS timestamp with time zone) CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_cast_owned_conversion_e2c94cad3a16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_restrict", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_cast_owned_conversion_1b3425035164
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_cascade", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST (double precision AS timestamp with time zone) CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_cast_owned_conversion_abb8f727a68b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_none", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST IF EXISTS (double precision AS timestamp with time zone);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_cast_owned_conversion_695a6b7dc67f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_restrict", "conversion": "drop_cast_conversion_existing", "if_exists": "drop_cast_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_drop_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_drop_convert(double precision);
-- test_sql:
DROP CAST IF EXISTS (double precision AS timestamp with time zone) RESTRICT;
-- fixture_teardown:
ROLLBACK;
