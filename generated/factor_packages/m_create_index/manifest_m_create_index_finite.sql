-- generated_from: manifest_m_create_index_finite
-- static_only: true
-- case_count: 17

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_index_finite_52238e425bcc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_default", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id );
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_584cf1729f1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_qty", "method": "m_create_index_method_btree", "nulls": "m_create_index_nulls_first", "sort_order": "m_create_index_sort_order_asc", "storage": "m_create_index_storage_min", "tail": "m_create_index_tail_algorithm", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new USING BTREE ON m_b01_source (qty ASC NULLS FIRST) WITH (fillfactor=10) COMMENT 'm finite index' ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_cf32e8537d81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_two", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_last", "sort_order": "m_create_index_sort_order_desc", "storage": "m_create_index_storage_middle", "tail": "m_create_index_tail_lock", "unique_modifier": "m_create_index_unique_modifier_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE UNIQUE INDEX m_create_index_new ON m_b01_source (id, qty DESC NULLS LAST) WITH (fillfactor=70) COMMENT 'm finite index' LOCK DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_82dcddb16164
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_btree", "nulls": "m_create_index_nulls_first", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_max", "tail": "m_create_index_tail_lock", "unique_modifier": "m_create_index_unique_modifier_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE UNIQUE INDEX m_create_index_new USING BTREE ON m_b01_source (id NULLS FIRST) WITH (fillfactor=100) LOCK DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_d5bcf3b2007e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_qty", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_last", "sort_order": "m_create_index_sort_order_desc", "storage": "m_create_index_storage_max", "tail": "m_create_index_tail_algorithm", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (qty DESC NULLS LAST) WITH (fillfactor=100) ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_fe6c79f3e772
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_two", "method": "m_create_index_method_btree", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_asc", "storage": "m_create_index_storage_default", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE UNIQUE INDEX m_create_index_new USING BTREE ON m_b01_source (id, qty ASC ) COMMENT 'm finite index';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_3b4bf4d27b4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_last", "sort_order": "m_create_index_sort_order_asc", "storage": "m_create_index_storage_min", "tail": "m_create_index_tail_lock", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id ASC NULLS LAST) WITH (fillfactor=10) LOCK DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_2bfd45bab32e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_two", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_first", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_middle", "tail": "m_create_index_tail_algorithm", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id, qty NULLS FIRST) WITH (fillfactor=70) ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_23f3ce67b36d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_btree", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_desc", "storage": "m_create_index_storage_min", "tail": "m_create_index_tail_algorithm", "unique_modifier": "m_create_index_unique_modifier_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE UNIQUE INDEX m_create_index_new USING BTREE ON m_b01_source (id DESC ) WITH (fillfactor=10) COMMENT 'm finite index' ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_da411ac36630
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_qty", "method": "m_create_index_method_btree", "nulls": "m_create_index_nulls_last", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_middle", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE UNIQUE INDEX m_create_index_new USING BTREE ON m_b01_source (qty NULLS LAST) WITH (fillfactor=70) COMMENT 'm finite index';
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_b7f511ed4379
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_text", "key_profile": "m_create_index_key_profile_qty", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_asc", "storage": "m_create_index_storage_max", "tail": "m_create_index_tail_lock", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (qty ASC ) WITH (fillfactor=100) COMMENT 'm finite index' LOCK DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_482fadc881b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_qty", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_first", "sort_order": "m_create_index_sort_order_desc", "storage": "m_create_index_storage_default", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (qty DESC NULLS FIRST);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_a5c844eec032
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_asc", "storage": "m_create_index_storage_middle", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id ASC ) WITH (fillfactor=70);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_eda3d1af811c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_two", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_min", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id, qty ) WITH (fillfactor=10);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_e44b77fc5b35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_last", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_default", "tail": "m_create_index_tail_algorithm", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id NULLS LAST) ALGORITHM=DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_f9b214a389c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_two", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_max", "tail": "m_create_index_tail_none", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id, qty ) WITH (fillfactor=100);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_create_index_finite_3b9b6b980e50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "m_create_index_comment_none", "key_profile": "m_create_index_key_profile_id", "method": "m_create_index_method_default", "nulls": "m_create_index_nulls_default", "sort_order": "m_create_index_sort_order_default", "storage": "m_create_index_storage_default", "tail": "m_create_index_tail_lock", "unique_modifier": "m_create_index_unique_modifier_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
CREATE INDEX m_create_index_new ON m_b01_source (id ) LOCK DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;
