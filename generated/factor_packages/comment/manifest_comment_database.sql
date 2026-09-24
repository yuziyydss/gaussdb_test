-- generated_from: manifest_comment_database
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_database_c589e56c12fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_database_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["non_pdb"], "fact_refs": ["comment_fact_pdb"], "key": "database_scope"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_privilege"], "key": "database_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_no_transaction"], "key": "create_database_autocommit"}, {"allowed_values": ["true"], "fact_refs": ["drop_database::drop_database_fact_no_transaction"], "key": "drop_database_autocommit"}, {"allowed_values": ["false"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_database_owner"], "fact_refs": ["drop_database::drop_database_fact_privilege"], "key": "cleanup_database"}]
-- fixture_setup:
CREATE DATABASE g_comment_database;
-- test_sql:
COMMENT ON DATABASE g_comment_database IS 'factor note';
-- fixture_teardown:
DROP DATABASE g_comment_database;

-- case_id: manifest_comment_database_418b3c06ec12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_database_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["non_pdb"], "fact_refs": ["comment_fact_pdb"], "key": "database_scope"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_privilege"], "key": "database_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_no_transaction"], "key": "create_database_autocommit"}, {"allowed_values": ["true"], "fact_refs": ["drop_database::drop_database_fact_no_transaction"], "key": "drop_database_autocommit"}, {"allowed_values": ["false"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_database_owner"], "fact_refs": ["drop_database::drop_database_fact_privilege"], "key": "cleanup_database"}]
-- fixture_setup:
CREATE DATABASE g_comment_database;
-- test_sql:
COMMENT ON DATABASE g_comment_database IS '测试注释';
-- fixture_teardown:
DROP DATABASE g_comment_database;

-- case_id: manifest_comment_database_ecc178093cb4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_database_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["non_pdb"], "fact_refs": ["comment_fact_pdb"], "key": "database_scope"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_privilege"], "key": "database_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_no_transaction"], "key": "create_database_autocommit"}, {"allowed_values": ["true"], "fact_refs": ["drop_database::drop_database_fact_no_transaction"], "key": "drop_database_autocommit"}, {"allowed_values": ["false"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_database_owner"], "fact_refs": ["drop_database::drop_database_fact_privilege"], "key": "cleanup_database"}]
-- fixture_setup:
CREATE DATABASE g_comment_database;
-- test_sql:
COMMENT ON DATABASE g_comment_database IS 'owner''s note';
-- fixture_teardown:
DROP DATABASE g_comment_database;

-- case_id: manifest_comment_database_ee9c608c41cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_database_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["non_pdb"], "fact_refs": ["comment_fact_pdb"], "key": "database_scope"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_privilege"], "key": "database_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_database::create_database_fact_no_transaction"], "key": "create_database_autocommit"}, {"allowed_values": ["true"], "fact_refs": ["drop_database::drop_database_fact_no_transaction"], "key": "drop_database_autocommit"}, {"allowed_values": ["false"], "fact_refs": ["drop_database::drop_database_fact_no_connections"], "key": "database_has_connections"}, {"allowed_values": ["off"], "fact_refs": ["drop_database::drop_database_fact_recyclebin_environment"], "key": "enable_db_recyclebin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_database_owner"], "fact_refs": ["drop_database::drop_database_fact_privilege"], "key": "cleanup_database"}]
-- fixture_setup:
CREATE DATABASE g_comment_database;
-- test_sql:
COMMENT ON DATABASE g_comment_database IS NULL;
-- fixture_teardown:
DROP DATABASE g_comment_database;
