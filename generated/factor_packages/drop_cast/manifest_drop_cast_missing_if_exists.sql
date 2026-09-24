-- generated_from: manifest_drop_cast_missing_if_exists
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_cast_missing_if_exists_b058ea218c52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_cast_behavior_none", "conversion": "drop_cast_conversion_missing", "if_exists": "drop_cast_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_cast_fact_permission"], "key": "cast_type_usage_authorized"}]
-- test_sql:
DROP CAST IF EXISTS (drop_cast_missing_source AS drop_cast_missing_target);
