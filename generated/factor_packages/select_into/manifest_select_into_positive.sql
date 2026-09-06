-- generated_from: manifest_select_into_positive
-- static_only: true
-- case_count: 26

-- case_id: manifest_select_into_positive_7fa98dd149ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_none", "modifier": "select_into_modifier_ordinary", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO t_into_candidate FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_287c514234e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_one", "modifier": "select_into_modifier_unlogged", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 AS a, col_2 AS b INTO UNLOGGED TABLE t_into_candidate FROM t_ctas_source WHERE col_1 > 1 ORDER BY 1 ASC LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_33cc3b705b7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp0", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1 + 1 AS shifted, col_2 AS kept INTO TEMP t_into_candidate FROM t_ctas_source WHERE col_1 > 1 ORDER BY 1 DESC NULLS LAST LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_19e27472dde2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp1", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1 AS a, col_2 AS b INTO TEMPORARY TABLE t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_dbd87294d020
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp2", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1 + 1 AS shifted, col_2 AS kept INTO LOCAL TEMP TABLE t_into_candidate FROM t_ctas_source ORDER BY 1 ASC;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_00c67e7edd94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp3", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1, col_2 INTO LOCAL TEMPORARY t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_411cdbdf8fba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp4", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO GLOBAL TEMP t_into_candidate FROM t_ctas_source WHERE col_1 > 1 ORDER BY 1 ASC LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_bfa34ea20435
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp5", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 AS a, col_2 AS b INTO GLOBAL TEMPORARY t_into_candidate FROM t_ctas_source WHERE col_1 > 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_365531af38ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_none", "modifier": "select_into_modifier_unlogged", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1, col_2 INTO UNLOGGED TABLE t_into_candidate FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_eb278f725655
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp5", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1 + 1 AS shifted, col_2 AS kept INTO GLOBAL TEMPORARY TABLE t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_59d28cfacb04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_ordinary", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 + 1 AS shifted, col_2 AS kept INTO TABLE t_into_candidate FROM t_ctas_source WHERE col_1 > 1 ORDER BY 1 ASC LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_af650d2adc4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp4", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1 AS a, col_2 AS b INTO GLOBAL TEMP TABLE t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_5da69244790c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp1", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 + 1 AS shifted, col_2 AS kept INTO TEMPORARY t_into_candidate FROM t_ctas_source WHERE col_1 > 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_3fc4f6a17596
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp0", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO TEMP TABLE t_into_candidate FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_9bdf9e18a65a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp2", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO LOCAL TEMP t_into_candidate FROM t_ctas_source WHERE col_1 > 1 ORDER BY 1 DESC NULLS LAST LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_11317a1f90c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp3", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_yes", "where": "select_into_where_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1 AS a, col_2 AS b INTO LOCAL TEMPORARY TABLE t_into_candidate FROM t_ctas_source WHERE col_1 > 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_83380eec143b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_one", "modifier": "select_into_modifier_ordinary", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1 AS a, col_2 AS b INTO t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_515181912d90
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_unlogged", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1 + 1 AS shifted, col_2 AS kept INTO UNLOGGED t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_2bf1de489dfc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp0", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 AS a, col_2 AS b INTO TEMP t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_8df7b0a61a9e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp1", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1, col_2 INTO TEMPORARY t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_1b461a2b32fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp3", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1 + 1 AS shifted, col_2 AS kept INTO LOCAL TEMPORARY t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_767f6ed7ab50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_distinct", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp5", "name": "select_into_name_candidate", "order": "select_into_order_desc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT DISTINCT col_1, col_2 INTO GLOBAL TEMPORARY t_into_candidate FROM t_ctas_source ORDER BY 1 DESC NULLS LAST LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_4c1c5cab2802
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp2", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_aliases", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 AS a, col_2 AS b INTO LOCAL TEMP t_into_candidate FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_f76e4e94672e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_all", "limit": "select_into_limit_none", "modifier": "select_into_modifier_temp4", "name": "select_into_name_candidate", "order": "select_into_order_none", "projection": "select_into_projection_arithmetic", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT ALL col_1 + 1 AS shifted, col_2 AS kept INTO GLOBAL TEMP t_into_candidate FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_9a1f0eccd2fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_offset", "modifier": "select_into_modifier_temp2", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO LOCAL TEMP t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1 OFFSET 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_select_into_positive_14d44e5e3c8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"distinct": "select_into_distinct_default", "limit": "select_into_limit_one", "modifier": "select_into_modifier_temp4", "name": "select_into_name_candidate", "order": "select_into_order_asc", "projection": "select_into_projection_names", "table_keyword": "select_into_table_keyword_none", "where": "select_into_where_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
SELECT col_1, col_2 INTO GLOBAL TEMP t_into_candidate FROM t_ctas_source ORDER BY 1 ASC LIMIT 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_into_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;
