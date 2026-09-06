-- generated_from: manifest_alter_synonym_owner
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_synonym_owner_b51925a7c5ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "alter_synonym_name_local", "new_owner": "alter_synonym_new_owner_reserved"}
-- environment_requirements: [{"allowed_values": ["granted"], "fact_refs": ["alter_synonym_fact_admin"], "key": "synonym_owner_change_authority"}, {"allowed_values": ["granted"], "fact_refs": ["alter_synonym_fact_schema_create"], "key": "new_owner_fp_syn_owner_schema_create"}]
-- fixture_setup:
CREATE SYNONYM s_alter_syn FOR fp_syn_alter_missing;
-- test_sql:
ALTER SYNONYM s_alter_syn OWNER TO fp_syn_owner;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_alter_syn;
