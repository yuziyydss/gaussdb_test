-- generated_from: manifest_alter_column_encryption_key_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_column_encryption_key_fresh_syntax_fff3aebeb556
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"key_name": "alter_column_encryption_key_key_name_fresh", "new_cmk_name": "alter_column_encryption_key_new_cmk_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}]
-- test_sql:
ALTER COLUMN ENCRYPTION KEY g_alter_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_new_client_master_key);
