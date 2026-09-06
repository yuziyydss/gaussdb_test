-- generated_from: manifest_delete_partition_payload_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_delete_partition_payload_positive_823266d9cdaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_payload_partition_name", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
DELETE FROM fp_q2.q2_range_source PARTITION (p1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_6c887efcfae1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_partition", "single_target_profile": "delete_target_payload_partition_value", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
DELETE FROM fp_q2.q2_range_source PARTITION FOR (1) WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_1a1befc84cca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_payload_subpartition_name", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
DELETE FROM fp_q2.q2_sub_source SUBPARTITION (p1s1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_ee2ac9cb50b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_payload_subpartition_value", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
DELETE FROM fp_q2.q2_sub_source SUBPARTITION FOR (1,1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_726af98da1b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_partition", "single_target_profile": "delete_target_payload_partition_name", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
DELETE FROM fp_q2.q2_range_source PARTITION (p1) WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_eef1e3d16128
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_payload_partition_value", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_range_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_q2.q2_range_source VALUES (1,1,100),(11,1,200);
-- test_sql:
DELETE FROM fp_q2.q2_range_source PARTITION FOR (1);
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_range_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_ad375f3f7d2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_partition", "single_target_profile": "delete_target_payload_subpartition_name", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
DELETE FROM fp_q2.q2_sub_source SUBPARTITION (p1s1) WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;

-- case_id: manifest_delete_partition_payload_positive_5e4f4fb041c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_partition", "single_target_profile": "delete_target_payload_subpartition_value", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
BEGIN;
CREATE SCHEMA fp_q2;
CREATE TABLE fp_q2.q2_sub_source (col_1 INT, col_2 INT, payload INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_q2.q2_sub_source VALUES (1,1,100),(1,11,200),(11,1,300),(11,11,400);
-- test_sql:
DELETE FROM fp_q2.q2_sub_source SUBPARTITION FOR (1,1) WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_q2.q2_sub_source;
ROLLBACK;
