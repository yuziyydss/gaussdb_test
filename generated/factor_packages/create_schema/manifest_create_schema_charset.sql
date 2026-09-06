-- generated_from: manifest_create_schema_charset
-- static_only: true
-- case_count: 24

-- case_id: manifest_create_schema_charset_f60f1cff8a0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_plain", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_1aea3ad404a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_set", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARACTER SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_cbe6b9349868
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_default", "collation": "create_schema_collation_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT CHARACTER SET utf8mb4 COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_fc180273d8d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_short", "collation": "create_schema_collation_default", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET utf8mb4 DEFAULT COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_2952c4d0724b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_equals", "collation": "create_schema_collation_default_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET = utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_e3a221297baa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_55625e8932be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_default", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_2c084bc439e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_default_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_3f76822c5308
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_set", "collation": "create_schema_collation_plain", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_671e66b390ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_set", "collation": "create_schema_collation_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARACTER SET utf8mb4 COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_90aae0be33c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_set", "collation": "create_schema_collation_default", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_8a36762610b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_set", "collation": "create_schema_collation_default_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARACTER SET utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_095adc00a460
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_default", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT CHARACTER SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_99d7fe46b1d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_default", "collation": "create_schema_collation_plain", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_f67d443667ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_default", "collation": "create_schema_collation_default", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_7dfd94c78c13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_default", "collation": "create_schema_collation_default_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_99dca5f6f369
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_short", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_678741a9c9c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_short", "collation": "create_schema_collation_plain", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_fe15662228f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_short", "collation": "create_schema_collation_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET utf8mb4 COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_a9cd6bdeb88b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_short", "collation": "create_schema_collation_default_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_5e1cb089819d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_equals", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET = utf8mb4;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_ad282f49bb4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_equals", "collation": "create_schema_collation_plain", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET = utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_d321a464f757
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_equals", "collation": "create_schema_collation_equals", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET = utf8mb4 COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_charset_3cf820985e4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_equals", "collation": "create_schema_collation_default", "elements": "create_schema_elements_absent", "form": "create_schema_form_charset", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["UTF8"], "fact_refs": ["create_schema_fact_encoding_match"], "key": "server_encoding"}, {"allowed_values": ["B"], "fact_refs": ["create_schema_fact_compatibility"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CHARSET = utf8mb4 DEFAULT COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;
