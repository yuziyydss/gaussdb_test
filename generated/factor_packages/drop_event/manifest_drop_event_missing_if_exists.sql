-- generated_from: manifest_drop_event_missing_if_exists
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_event_missing_if_exists_9116cbf91a30
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event_name": "drop_event_event_name_missing", "if_exists": "drop_event_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["drop_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event::create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- test_sql:
DROP EVENT IF EXISTS fp_cs_one.b10_event_missing;
