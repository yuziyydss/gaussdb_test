-- generated_from: manifest_alter_database_link_using_timeout_syntax
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_database_link_using_timeout_syntax_bb757316e1d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"alter_clause": "alter_database_link_alter_clause_using_timeout", "link_name": "alter_database_link_link_name_fresh", "visibility": "alter_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_link_fact_oracle_options", "alter_database_link_fact_runtime_fixture"], "key": "oracle_backend"}, {"allowed_values": ["oracle_dblink_owned_by_noninitial_principal"], "fact_refs": ["alter_database_link_fact_runtime_fixture"], "key": "existing_dblink"}, {"allowed_values": ["acknowledged"], "fact_refs": ["alter_database_link_fact_external_guide"], "key": "external_guide_contract"}]
-- test_sql:
ALTER DATABASE LINK g_alter_dblink_static USING (time_out '0');

-- case_id: manifest_alter_database_link_using_timeout_syntax_8b2dd1b0b732
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"alter_clause": "alter_database_link_alter_clause_using_timeout", "link_name": "alter_database_link_link_name_fresh", "visibility": "alter_database_link_visibility_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_database_link_fact_oracle_options", "alter_database_link_fact_runtime_fixture"], "key": "oracle_backend"}, {"allowed_values": ["oracle_dblink_owned_by_noninitial_principal"], "fact_refs": ["alter_database_link_fact_runtime_fixture"], "key": "existing_dblink"}, {"allowed_values": ["acknowledged"], "fact_refs": ["alter_database_link_fact_external_guide"], "key": "external_guide_contract"}]
-- test_sql:
ALTER PUBLIC DATABASE LINK g_alter_dblink_static USING (time_out '0');
