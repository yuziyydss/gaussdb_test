-- generated_from: manifest_create_column_encryption_key_fresh_syntax
-- static_only: true
-- case_count: 7

-- case_id: manifest_create_column_encryption_key_fresh_syntax_43ca7bd295ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_aead_aes_256_cbc_hmac_sha256", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = AEAD_AES_256_CBC_HMAC_SHA256 );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_6720930d8ed2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_aead_aes_128_cbc_hmac_sha256", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = AEAD_AES_128_CBC_HMAC_SHA256 );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_a266c4495b06
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_aead_aes_256_ctr_hmac_sha256", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = AEAD_AES_256_CTR_HMAC_SHA256 );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_38fa9054b9b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_aes_256_gcm", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = AES_256_GCM );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_19d361344c75
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_sm4_hmac_sm3", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = SM4_HMAC_SM3 );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_81c6a5547644
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_sm4_ctr_hmac_sm3", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = SM4_CTR_HMAC_SM3 );

-- case_id: manifest_create_column_encryption_key_fresh_syntax_947e6eb4ab90
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_column_encryption_key_algorithm_sm4_sm3", "cmk_name": "create_column_encryption_key_cmk_name_fresh", "encrypted_value_clause": "create_column_encryption_key_encrypted_value_none", "key_name": "create_column_encryption_key_key_name_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_column_encryption_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["encrypted_only"], "fact_refs": ["create_column_encryption_key_fact_encrypted_only"], "key": "database_mode"}]
-- test_sql:
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_create_client_master_key, ALGORITHM = SM4_SM3 );
