-- generated_from: manifest_create_pluggable_database_fresh_syntax
-- static_only: true
-- case_count: 9

-- case_id: manifest_create_pluggable_database_fresh_syntax_497b337e6545
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_none", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database;

-- case_id: manifest_create_pluggable_database_fresh_syntax_1d50094b9653
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_utf8", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database ENCODING = 'UTF8';

-- case_id: manifest_create_pluggable_database_fresh_syntax_a45619ca8604
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_compat_A", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database DBCOMPATIBILITY = 'A';

-- case_id: manifest_create_pluggable_database_fresh_syntax_f9af3a87ee6c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_compat_C", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database DBCOMPATIBILITY = 'C';

-- case_id: manifest_create_pluggable_database_fresh_syntax_50974711455e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_compat_PG", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database DBCOMPATIBILITY = 'PG';

-- case_id: manifest_create_pluggable_database_fresh_syntax_6a1b71e51d19
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_compat_M", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database DBCOMPATIBILITY = 'M';

-- case_id: manifest_create_pluggable_database_fresh_syntax_2babb233f8a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_collate", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database LC_COLLATE = 'C';

-- case_id: manifest_create_pluggable_database_fresh_syntax_f97fee4dc3b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_ctype", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database LC_CTYPE = 'C';

-- case_id: manifest_create_pluggable_database_fresh_syntax_77d348475eb1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"option": "create_pluggable_database_option_timezone", "pdb_name": "create_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["create_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_pluggable_database_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["outside_transaction"], "fact_refs": ["create_pluggable_database_fact_no_transaction"], "key": "transaction_scope"}, {"allowed_values": ["gs_role_create_pdb_or_sysadmin"], "fact_refs": ["create_pluggable_database_fact_privilege"], "key": "create_pdb_privilege"}]
-- test_sql:
CREATE PLUGGABLE DATABASE g_create_pluggable_database DBTIMEZONE = 'PRC';
