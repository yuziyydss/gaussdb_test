-- generated_from: manifest_drop_column_encryption_key_fresh_syntax
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_385751046de6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v0", "if_exists": "drop_column_encryption_key_if_exists_none", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY g_drop_column_encryption_key;

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_be691e40c2ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v1", "if_exists": "drop_column_encryption_key_if_exists_yes", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY IF EXISTS g_drop_column_encryption_key CASCADE;

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_7e29cbd53ff9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v2", "if_exists": "drop_column_encryption_key_if_exists_none", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY g_drop_column_encryption_key RESTRICT;

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_04f0ea6bcd03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v1", "if_exists": "drop_column_encryption_key_if_exists_none", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY g_drop_column_encryption_key CASCADE;

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_e38c879d8665
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v0", "if_exists": "drop_column_encryption_key_if_exists_yes", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY IF EXISTS g_drop_column_encryption_key;

-- case_id: manifest_drop_column_encryption_key_fresh_syntax_5ad8c3d13885
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_column_encryption_key_behavior_v2", "if_exists": "drop_column_encryption_key_if_exists_yes", "key_names": "drop_column_encryption_key_key_names_fresh"}
-- environment_requirements: [{"allowed_values": ["cek_owner_or_drop_privilege"], "fact_refs": ["drop_column_encryption_key_fact_privilege"], "key": "cek_drop_privilege"}]
-- test_sql:
DROP COLUMN ENCRYPTION KEY IF EXISTS g_drop_column_encryption_key RESTRICT;
