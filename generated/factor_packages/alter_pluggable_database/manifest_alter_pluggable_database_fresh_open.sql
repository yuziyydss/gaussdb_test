-- generated_from: manifest_alter_pluggable_database_fresh_open
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_pluggable_database_fresh_open_a0b624074878
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_pluggable_database_action_a0", "pdb_name": "alter_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb_non_m"], "fact_refs": ["alter_pluggable_database_fact_non_pdb_not_m"], "key": "database_scope"}, {"allowed_values": ["pdb_owner_or_sysadmin"], "fact_refs": ["alter_pluggable_database_fact_privilege"], "key": "alter_pdb_privilege"}, {"allowed_values": ["present"], "fact_refs": ["alter_pluggable_database_fact_resource_plan"], "key": "resource_plan_directive"}]
-- test_sql:
ALTER PLUGGABLE DATABASE g_alter_pluggable_database OPEN;

-- case_id: manifest_alter_pluggable_database_fresh_open_1ff4c12d31e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_pluggable_database_action_a1", "pdb_name": "alter_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb_non_m"], "fact_refs": ["alter_pluggable_database_fact_non_pdb_not_m"], "key": "database_scope"}, {"allowed_values": ["pdb_owner_or_sysadmin"], "fact_refs": ["alter_pluggable_database_fact_privilege"], "key": "alter_pdb_privilege"}, {"allowed_values": ["present"], "fact_refs": ["alter_pluggable_database_fact_resource_plan"], "key": "resource_plan_directive"}]
-- test_sql:
ALTER PLUGGABLE DATABASE g_alter_pluggable_database CLOSE;

-- case_id: manifest_alter_pluggable_database_fresh_open_88ee5ab1e068
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_pluggable_database_action_a2", "pdb_name": "alter_pluggable_database_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["alter_pluggable_database_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb_non_m"], "fact_refs": ["alter_pluggable_database_fact_non_pdb_not_m"], "key": "database_scope"}, {"allowed_values": ["pdb_owner_or_sysadmin"], "fact_refs": ["alter_pluggable_database_fact_privilege"], "key": "alter_pdb_privilege"}, {"allowed_values": ["present"], "fact_refs": ["alter_pluggable_database_fact_resource_plan"], "key": "resource_plan_directive"}]
-- test_sql:
ALTER PLUGGABLE DATABASE g_alter_pluggable_database CLOSE IMMEDIATE;
