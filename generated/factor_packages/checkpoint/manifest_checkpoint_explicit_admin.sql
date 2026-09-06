-- generated_from: manifest_checkpoint_explicit_admin
-- static_only: true
-- case_count: 1

-- case_id: manifest_checkpoint_explicit_admin_6b0f3792628c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["checkpoint_fact_permission"], "key": "checkpoint_admin_authorized"}, {"allowed_values": ["non_pdb"], "fact_refs": ["checkpoint_fact_no_pdb"], "key": "container_kind"}]
-- test_sql:
CHECKPOINT;
