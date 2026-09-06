-- generated_from: manifest_update_partition_payload_positive
-- static_only: true
-- case_count: 12

-- case_id: manifest_update_partition_payload_positive_48398f563285
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_literal", "single_target_profile": "update_target_payload_partition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION (p1) SET payload = 42;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_8e8373429b0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_partition", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_increment", "single_target_profile": "update_target_payload_partition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION FOR (1) SET payload = payload + 1 WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_65e343a0cc4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_tuple", "single_target_profile": "update_target_payload_subpartition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION (p1s1) SET (payload, col_1) = (42, col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_f7f96fb741b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_partition", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_literal", "single_target_profile": "update_target_payload_subpartition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION FOR (1,1) SET payload = 42 WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_fd84652c6aa7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_partition", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_tuple", "single_target_profile": "update_target_payload_partition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION (p1) SET (payload, col_1) = (42, col_1) WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_c658abf3773b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_increment", "single_target_profile": "update_target_payload_subpartition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION FOR (1,1) SET payload = payload + 1;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_e33b7c84e050
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_literal", "single_target_profile": "update_target_payload_partition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION FOR (1) SET payload = 42;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_a531adc79d46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_partition", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_literal", "single_target_profile": "update_target_payload_subpartition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION (p1s1) SET payload = 42 WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_9e27305f54af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_increment", "single_target_profile": "update_target_payload_partition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION (p1) SET payload = payload + 1;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_6d707e283fa4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_tuple", "single_target_profile": "update_target_payload_partition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
UPDATE fp_q2.q2_range_source PARTITION FOR (1) SET (payload, col_1) = (42, col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_3c09ebfc508c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_increment", "single_target_profile": "update_target_payload_subpartition_name", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION (p1s1) SET payload = payload + 1;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_update_partition_payload_positive_3b085e940a47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_payload_tuple", "single_target_profile": "update_target_payload_subpartition_value", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
UPDATE fp_q2.q2_sub_source SUBPARTITION FOR (1,1) SET (payload, col_1) = (42, col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;
