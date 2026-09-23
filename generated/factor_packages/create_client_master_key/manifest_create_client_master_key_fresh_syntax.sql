-- generated_from: manifest_create_client_master_key_fresh_syntax
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_client_master_key_fresh_syntax_a1ff168502f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_client_master_key_algorithm_aes_256_cbc", "key_name": "create_client_master_key_key_name_fresh", "key_path": "create_client_master_key_key_path_none", "key_store": "create_client_master_key_key_store_user_token"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_client_master_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["user_token"], "fact_refs": ["create_client_master_key_fact_key_managers"], "key": "key_store_available"}]
-- test_sql:
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = AES_256_CBC);

-- case_id: manifest_create_client_master_key_fresh_syntax_d733883206bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_client_master_key_algorithm_aes_256_gcm", "key_name": "create_client_master_key_key_name_fresh", "key_path": "create_client_master_key_key_path_none", "key_store": "create_client_master_key_key_store_user_token"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_client_master_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["user_token"], "fact_refs": ["create_client_master_key_fact_key_managers"], "key": "key_store_available"}]
-- test_sql:
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = AES_256_GCM);

-- case_id: manifest_create_client_master_key_fresh_syntax_2f16b479e3b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_client_master_key_algorithm_sm4", "key_name": "create_client_master_key_key_name_fresh", "key_path": "create_client_master_key_key_path_none", "key_store": "create_client_master_key_key_store_user_token"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_client_master_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["user_token"], "fact_refs": ["create_client_master_key_fact_key_managers"], "key": "key_store_available"}]
-- test_sql:
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4);

-- case_id: manifest_create_client_master_key_fresh_syntax_1ef32c9ac94b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_client_master_key_algorithm_sm4_hmac_sm3", "key_name": "create_client_master_key_key_name_fresh", "key_path": "create_client_master_key_key_path_none", "key_store": "create_client_master_key_key_store_user_token"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_client_master_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["user_token"], "fact_refs": ["create_client_master_key_fact_key_managers"], "key": "key_store_available"}]
-- test_sql:
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4_HMAC_SM3);

-- case_id: manifest_create_client_master_key_fresh_syntax_62f32712adbb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"algorithm": "create_client_master_key_algorithm_sm4_ctr_hmac_sm3", "key_name": "create_client_master_key_key_name_fresh", "key_path": "create_client_master_key_key_path_none", "key_store": "create_client_master_key_key_store_user_token"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_client_master_key_fact_driver"], "key": "encrypted_query_driver"}, {"allowed_values": ["user_token"], "fact_refs": ["create_client_master_key_fact_key_managers"], "key": "key_store_available"}]
-- test_sql:
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4_CTR_HMAC_SM3);
