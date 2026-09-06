-- generated_from: manifest_create_masking_policy_functions
-- static_only: true
-- case_count: 21

-- case_id: manifest_create_masking_policy_functions_a680d1907300
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_maskall", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new maskall ON LABEL (b10_mask_a);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_06c9df4d4a60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_maskall", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new maskall ON LABEL (b10_mask_a, b10_mask_b) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_ab93034699f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_randommasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new randommasking ON LABEL (b10_mask_a) FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_893c21d27534
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_randommasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new randommasking ON LABEL (b10_mask_a, b10_mask_b) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_9dc704bc3615
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_creditcardmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new creditcardmasking ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_31f73845c3df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_creditcardmasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new creditcardmasking ON LABEL (b10_mask_a, b10_mask_b) DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_490840504803
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_basicemailmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new basicemailmasking ON LABEL (b10_mask_a) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_ee9ba5162587
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_basicemailmasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new basicemailmasking ON LABEL (b10_mask_a, b10_mask_b) FILTER ON APP(gsql);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_95572a497979
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_fullemailmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new fullemailmasking ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_1d1e36089ad9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_fullemailmasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new fullemailmasking ON LABEL (b10_mask_a, b10_mask_b);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_47efbfdcae1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_shufflemasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new shufflemasking ON LABEL (b10_mask_a);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_9c4a5ce687f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_shufflemasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new shufflemasking ON LABEL (b10_mask_a, b10_mask_b) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_850913df9f9e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_alldigitsmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new alldigitsmasking ON LABEL (b10_mask_a);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_34d85eed0c45
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_alldigitsmasking", "labels": "create_masking_policy_labels_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new alldigitsmasking ON LABEL (b10_mask_a, b10_mask_b) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_1ac65c138778
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_maskall", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new maskall ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_bd8eacda5357
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_none", "function": "create_masking_policy_function_randommasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new randommasking ON LABEL (b10_mask_a) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_4fa585f36968
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_none", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_creditcardmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new creditcardmasking ON LABEL (b10_mask_a) FILTER ON APP(gsql);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_0dbfa7803a8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_basicemailmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new basicemailmasking ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_e0a17e786653
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_enable", "filter": "create_masking_policy_filter_app", "function": "create_masking_policy_function_fullemailmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new fullemailmasking ON LABEL (b10_mask_a) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_ada4ccf99bf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_shufflemasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new shufflemasking ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_masking_policy_functions_8be4da8b3521
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "create_masking_policy_enabled_disable", "filter": "create_masking_policy_filter_ip", "function": "create_masking_policy_function_alldigitsmasking", "labels": "create_masking_policy_labels_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_masking_policy_fact_privilege"], "key": "security_policy_admin"}, {"allowed_values": ["on"], "fact_refs": ["create_masking_policy_fact_switch"], "key": "enable_security_policy"}, {"allowed_values": ["true"], "fact_refs": ["create_resource_label::create_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
BEGIN;
CREATE TABLE b10_mask_source (col_1 TEXT, col_2 TEXT);
INSERT INTO b10_mask_source VALUES ('1234-5678-9012-3456', 'a@example.test');
CREATE RESOURCE LABEL b10_mask_a ADD COLUMN(b10_mask_source.col_1);
CREATE RESOURCE LABEL b10_mask_b ADD COLUMN(b10_mask_source.col_2);
-- test_sql:
CREATE MASKING POLICY b10_mask_new alldigitsmasking ON LABEL (b10_mask_a) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
ROLLBACK;
