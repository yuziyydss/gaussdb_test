-- generated_from: manifest_alter_package_compile_syntax
-- static_only: true
-- case_count: 4

-- case_id: manifest_alter_package_compile_syntax_14a422b09a7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_package_operation_compile"}
-- environment_requirements: [{"allowed_values": ["syntax_only_no_behavior_claim"], "fact_refs": ["alter_package_fact_support_conflict"], "key": "package_compile_support_conflict"}]
-- test_sql:
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE;

-- case_id: manifest_alter_package_compile_syntax_030460fa8bd2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_package_operation_compile_package"}
-- environment_requirements: [{"allowed_values": ["syntax_only_no_behavior_claim"], "fact_refs": ["alter_package_fact_support_conflict"], "key": "package_compile_support_conflict"}]
-- test_sql:
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE PACKAGE;

-- case_id: manifest_alter_package_compile_syntax_839f8d7098d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_package_operation_compile_body"}
-- environment_requirements: [{"allowed_values": ["syntax_only_no_behavior_claim"], "fact_refs": ["alter_package_fact_support_conflict"], "key": "package_compile_support_conflict"}]
-- test_sql:
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE BODY;

-- case_id: manifest_alter_package_compile_syntax_259fff40118e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_package_operation_compile_spec"}
-- environment_requirements: [{"allowed_values": ["syntax_only_no_behavior_claim"], "fact_refs": ["alter_package_fact_support_conflict"], "key": "package_compile_support_conflict"}]
-- test_sql:
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE SPECIFICATION;
