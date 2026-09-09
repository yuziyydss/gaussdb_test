-- generated_from: manifest_m_create_table_select_direct_columns
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_select_direct_columns_e1cb312da5fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_none", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_id", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new SELECT id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_6add93ffa7e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_as", "comment": "m_create_table_select_comment_text", "custom_columns": "m_create_table_select_custom_columns_extra", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_two", "storage": "m_create_table_select_storage_row"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new (extra INT DEFAULT 5) COMMENT='m finite copy' WITH (orientation=row) AS SELECT id, qty FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_798e76f25b4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_override", "if_not_exists": "m_create_table_select_if_not_exists_yes", "projection": "m_create_table_select_projection_reverse", "storage": "m_create_table_select_storage_row"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_ctas_new (qty INT) WITH (orientation=row) SELECT qty, id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_d57cea2018b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_as", "comment": "m_create_table_select_comment_text", "custom_columns": "m_create_table_select_custom_columns_none", "if_not_exists": "m_create_table_select_if_not_exists_yes", "projection": "m_create_table_select_projection_reverse", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_ctas_new COMMENT='m finite copy' AS SELECT qty, id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_530858936cc8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_extra", "if_not_exists": "m_create_table_select_if_not_exists_yes", "projection": "m_create_table_select_projection_two", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_ctas_new (extra INT DEFAULT 5) SELECT id, qty FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_ead0653d5b6c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_as", "comment": "m_create_table_select_comment_text", "custom_columns": "m_create_table_select_custom_columns_override", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_id", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new (qty INT) COMMENT='m finite copy' AS SELECT id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_0c122385ce5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_text", "custom_columns": "m_create_table_select_custom_columns_none", "if_not_exists": "m_create_table_select_if_not_exists_yes", "projection": "m_create_table_select_projection_id", "storage": "m_create_table_select_storage_row"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_ctas_new COMMENT='m finite copy' WITH (orientation=row) SELECT id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_367c71a03247
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_as", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_extra", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_reverse", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new (extra INT DEFAULT 5) AS SELECT qty, id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_fb1ef5dfb63c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_none", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_two", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new SELECT id, qty FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_5e69ae6cd84e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_extra", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_id", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new (extra INT DEFAULT 5) SELECT id FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;

-- case_id: manifest_m_create_table_select_direct_columns_7deadee3cc9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_override", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_two", "storage": "m_create_table_select_storage_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new (qty INT) SELECT id, qty FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;
