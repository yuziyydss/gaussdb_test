# Core Expression Oracle Review Sheet

本文由 `core_expression_oracle_review_sheet_v1` 生成，只用于人工确认 oracle 草案。

- Source draft SHA-256: `bcb30ee35760d3ed29ddce7af9fbc32f84074b974c0d32706ab52c781a172cb1`
- Review steps: 94
- Capability groups: 14
- Exact value claims: 0

## 公共检查

- 实际执行是否成功且无非预期错误？
- 结果行与字段是否已完整捕获？
- SQLSTATE 是否已记录？
- 结果语义是否与引用 facts 一致？
- 是否存在兼容模式、编码或版本限制？

## 聚集函数 (`aggregate_domain`)

Steps: 8; Review status: **pending_review**

### `oracle_core_expr_candidate_sum_avg_count`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 63
- Candidate: `core_expr_candidate_sum_avg_count`
- Fact refs: `funcop_aggregate_basic_functions`, `funcop_aggregate_count_xml`
- SQL:

```sql
SELECT count(*), count(x), sum(x), avg(x) FROM (VALUES (1),(2),(NULL)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_min_max`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 64
- Candidate: `core_expr_candidate_min_max`
- Fact refs: `funcop_aggregate_basic_functions`
- SQL:

```sql
SELECT min(x),max(x) FROM (VALUES (1),(2)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_string_aggregation`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 65
- Candidate: `core_expr_candidate_string_aggregation`
- Fact refs: `funcop_aggregate_array_string`
- SQL:

```sql
SELECT string_agg(x,',' ORDER BY x) FROM (VALUES ('b'),('a')) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_agg`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 66
- Candidate: `core_expr_candidate_array_agg`
- Fact refs: `funcop_aggregate_array_string`
- SQL:

```sql
SELECT array_agg(x ORDER BY x) FROM (VALUES (2),(1)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_statistical_aggregates`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 67
- Candidate: `core_expr_candidate_statistical_aggregates`
- Fact refs: `funcop_aggregate_statistical_functions`
- SQL:

```sql
SELECT stddev_pop(x), stddev_samp(x), var_pop(x), var_samp(x) FROM (VALUES (1),(2),(3)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_percentile_mode`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 68
- Candidate: `core_expr_candidate_percentile_mode`
- Fact refs: `funcop_aggregate_statistical_functions`
- SQL:

```sql
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY x), mode() WITHIN GROUP (ORDER BY x) FROM (VALUES (1),(1),(2)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bit_bool_aggregates`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 69
- Candidate: `core_expr_candidate_bit_bool_aggregates`
- Fact refs: `funcop_aggregate_bit_bool_functions`
- SQL:

```sql
SELECT bit_and(x), bit_or(x), bool_and(x>0), bool_or(x>0) FROM (VALUES (1),(2)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_checksum_aggregate`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 70
- Candidate: `core_expr_candidate_checksum_aggregate`
- Fact refs: `funcop_aggregate_checksum_warning`
- SQL:

```sql
SELECT checksum(x) FROM (VALUES (1),(2)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 数组 (`array_domain`)

Steps: 9; Review status: **pending_review**

### `oracle_core_expr_candidate_array_constructor`

- Batch / Plan order: `batch_03_structured_types` / 49
- Candidate: `core_expr_candidate_array_constructor`
- Fact refs: `core_type_array_constructor`, `core_expr_array_constructor_type_resolution`
- SQL:

```sql
SELECT ARRAY[1,2,3], ARRAY[1,1.2];
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_empty_array_type`

- Batch / Plan order: `batch_03_structured_types` / 50
- Candidate: `core_expr_candidate_empty_array_type`
- Fact refs: `core_type_empty_array_requires_type`
- SQL:

```sql
SELECT ARRAY[]::int[];
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_from_subquery`

- Batch / Plan order: `batch_03_structured_types` / 51
- Candidate: `core_expr_candidate_array_from_subquery`
- Fact refs: `core_type_array_from_subquery`
- SQL:

```sql
SELECT ARRAY(SELECT x FROM (VALUES (1),(2)) v(x));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_set_functions`

- Batch / Plan order: `batch_03_structured_types` / 52
- Candidate: `core_expr_candidate_array_set_functions`
- Fact refs: `funcop_array_set_functions`
- SQL:

```sql
SELECT array_append(ARRAY[1,2],3), array_cat(ARRAY[1],ARRAY[2]), array_union_distinct(ARRAY[1,1,2],ARRAY[2,3]);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_intersect_except`

- Batch / Plan order: `batch_03_structured_types` / 53
- Candidate: `core_expr_candidate_array_intersect_except`
- Fact refs: `funcop_array_set_functions`
- SQL:

```sql
SELECT array_intersect(ARRAY[1,2,3],ARRAY[2,3,4]), array_except(ARRAY[1,2,3],ARRAY[2,3,4]);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_metadata`

- Batch / Plan order: `batch_03_structured_types` / 54
- Candidate: `core_expr_candidate_array_metadata`
- Fact refs: `funcop_array_metadata_functions`
- SQL:

```sql
SELECT array_ndims(ARRAY[[1,2]]), array_length(ARRAY[[1,2]],1), cardinality(ARRAY[1,2]);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_positions_sort`

- Batch / Plan order: `batch_03_structured_types` / 55
- Candidate: `core_expr_candidate_array_positions_sort`
- Fact refs: `funcop_array_metadata_functions`, `funcop_array_sort_string`
- SQL:

```sql
SELECT array_positions(ARRAY[1,2,1],1), array_sort(ARRAY[3,1,2]);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_to_string_unnest`

- Batch / Plan order: `batch_03_structured_types` / 56
- Candidate: `core_expr_candidate_array_to_string_unnest`
- Fact refs: `funcop_array_sort_string`, `funcop_string_to_array_unnest`
- SQL:

```sql
SELECT array_to_string(ARRAY[1,NULL,3],',','-'), string_to_array('a,b,c',',');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_definition_boundary`

- Batch / Plan order: `batch_03_structured_types` / 88
- Candidate: `core_expr_candidate_array_definition_boundary`
- Fact refs: `core_type_array_definition`
- SQL:

```sql
SELECT ARRAY[1,2], ARRAY[[1,2]], ARRAY(VALUES (1));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 布尔与位串 (`boolean_and_bit`)

Steps: 5; Review status: **pending_review**

### `oracle_core_expr_candidate_boolean_value_domain`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 4
- Candidate: `core_expr_candidate_boolean_value_domain`
- Fact refs: `core_type_boolean_values`
- SQL:

```sql
SELECT TRUE, FALSE, NULL::boolean, TRUE::text;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bit_operators`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 5
- Candidate: `core_expr_candidate_bit_operators`
- Fact refs: `core_type_bit_string`, `core_type_bit_cast_truncation`, `funcop_bit_operators`
- SQL:

```sql
SELECT B'10001' & B'01101', B'10001' | B'01101', B'10001' # B'01101', ~B'10001', B'10001' << 2, B'10001' >> 2;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bit_integer_cast`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 6
- Candidate: `core_expr_candidate_bit_integer_cast`
- Fact refs: `funcop_bit_integer_cast`
- SQL:

```sql
SELECT 44::bit(10), 44::bit(3), (-44)::bit(12), '1110'::bit(4)::integer;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bit_functions`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 7
- Candidate: `core_expr_candidate_bit_functions`
- Fact refs: `funcop_bit_string_functions`, `funcop_binary_functions`
- SQL:

```sql
SELECT bit_length(B'10001'), length(B'10001'), octet_length('abc'::bytea), get_bit('abc'::bytea, 0), set_bit('abc'::bytea, 0, 1);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bit_concat_boundary`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 91
- Candidate: `core_expr_candidate_bit_concat_boundary`
- Fact refs: `funcop_bit_concat_limit`
- SQL:

```sql
SELECT B'1'||B'0'||B'1'||B'0', B'1'||B'0'||B'1'||B'0'||B'1';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 条件表达式 (`conditional_domain`)

Steps: 3; Review status: **pending_review**

### `oracle_core_expr_candidate_coalesce`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 79
- Candidate: `core_expr_candidate_coalesce`
- Fact refs: `funcop_coalesce`
- SQL:

```sql
SELECT coalesce(NULL,1), coalesce(NULL,NULL,'x');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_nullif`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 80
- Candidate: `core_expr_candidate_nullif`
- Fact refs: `funcop_nullif`
- SQL:

```sql
SELECT nullif(1,1), nullif(1,2);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_greatest_least`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 81
- Candidate: `core_expr_candidate_greatest_least`
- Fact refs: `funcop_greatest_least`
- SQL:

```sql
SELECT greatest(1,2,3), least(1,2,3);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 日期时间函数 (`datetime_functions`)

Steps: 4; Review status: **pending_review**

### `oracle_core_expr_candidate_age`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 23
- Candidate: `core_expr_candidate_age`
- Fact refs: `funcop_datetime_current_functions`
- SQL:

```sql
SELECT age(TIMESTAMP '2026-09-28 00:00:00', TIMESTAMP '2020-01-01 00:00:00');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_oracle_date_functions`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 24
- Candidate: `core_expr_candidate_oracle_date_functions`
- Fact refs: `funcop_oracle_date_functions`
- SQL:

```sql
SELECT add_months(DATE '2026-09-28',1), months_between(DATE '2026-09-28', DATE '2026-01-01'), next_day(DATE '2026-09-28','MON');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_interval_literal`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 25
- Candidate: `core_expr_candidate_interval_literal`
- Fact refs: `core_type_interval_fields`
- SQL:

```sql
SELECT INTERVAL '1 day', INTERVAL '02:03:04', INTERVAL '1-2';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_justify_interval`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 26
- Candidate: `core_expr_candidate_justify_interval`
- Fact refs: `funcop_datetime_extraction_functions`
- SQL:

```sql
SELECT justify_interval(INTERVAL '1 day 25 hours');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 表达式语义与类型推导 (`expression_semantics`)

Steps: 6; Review status: **pending_review**

### `oracle_core_expr_candidate_case_type_priority`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 82
- Candidate: `core_expr_candidate_case_type_priority`
- Fact refs: `core_expr_a_mode_case_priority`
- SQL:

```sql
SELECT CASE WHEN true THEN 1 ELSE 1.2 END;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_union_case_type_resolution`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 83
- Candidate: `core_expr_candidate_union_case_type_resolution`
- Fact refs: `core_expr_union_case_general_resolution`, `core_expr_a_mode_case_priority`
- SQL:

```sql
SELECT CASE WHEN true THEN 1 ELSE 1.2 END UNION ALL SELECT 1.2;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_null_compare_boundaries`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 84
- Candidate: `core_expr_candidate_null_compare_boundaries`
- Fact refs: `core_expr_null_comparison`, `core_expr_distinct_from`, `core_expr_between_equivalence`
- SQL:

```sql
SELECT NULL IS NULL, NULL IS NOT NULL, NULL IS DISTINCT FROM NULL, 2 BETWEEN 1 AND 3;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_row_comparison`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 85
- Candidate: `core_expr_candidate_row_comparison`
- Fact refs: `core_expr_row_comparison`
- SQL:

```sql
SELECT ROW(1,2)=ROW(1,2), ROW(1,2)<ROW(1,3);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_null_semantics`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 86
- Candidate: `core_expr_candidate_array_null_semantics`
- Fact refs: `core_expr_array_in_null_semantics`, `core_expr_array_any_all_null_semantics`
- SQL:

```sql
SELECT 1 IN (1,NULL), 1 IN (2,NULL), 1 < ANY(ARRAY[NULL,2]), 1 < ALL(ARRAY[NULL,2]);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_subquery_predicates`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 87
- Candidate: `core_expr_candidate_subquery_predicates`
- Fact refs: `core_expr_exists_semantics`, `core_expr_any_some_all_subquery`
- SQL:

```sql
SELECT EXISTS(SELECT 1 WHERE false), 1 IN(SELECT * FROM (VALUES (1)) q(x)), 1 < ALL(SELECT * FROM (VALUES (2)) q(x));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## HLL (`hll_domain`)

Steps: 6; Review status: **pending_review**

### `oracle_core_expr_candidate_hll_hash`

- Batch / Plan order: `batch_03_structured_types` / 44
- Candidate: `core_expr_candidate_hll_hash`
- Fact refs: `funcop_hll_hash_functions`
- SQL:

```sql
SELECT hll_hash_text('abc'), hll_hash_integer(1), hll_hash_any(1.2::numeric);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_hll_empty_cardinality`

- Batch / Plan order: `batch_03_structured_types` / 45
- Candidate: `core_expr_candidate_hll_empty_cardinality`
- Fact refs: `funcop_hll_construct_functions`, `funcop_hll_cardinality_union`
- SQL:

```sql
SELECT hll_cardinality(hll_empty());
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_hll_add_agg`

- Batch / Plan order: `batch_03_structured_types` / 46
- Candidate: `core_expr_candidate_hll_add_agg`
- Fact refs: `funcop_hll_cardinality_union`
- SQL:

```sql
SELECT hll_cardinality(hll_add_agg(hll_hash_text(x))) FROM (VALUES ('a'),('b'),('a')) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_hll_union`

- Batch / Plan order: `batch_03_structured_types` / 47
- Candidate: `core_expr_candidate_hll_union`
- Fact refs: `funcop_hll_cardinality_union`
- SQL:

```sql
SELECT hll_cardinality(hll_union(hll_add(hll_empty(),hll_hash_text('a')), hll_add(hll_empty(),hll_hash_text('a'))));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_hll_metadata`

- Batch / Plan order: `batch_03_structured_types` / 48
- Candidate: `core_expr_candidate_hll_metadata`
- Fact refs: `funcop_hll_metadata_functions`
- SQL:

```sql
SELECT hll_log2m(hll_empty()), hll_type(hll_empty()), hll_schema_version(hll_empty());
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_hll_type_boundary`

- Batch / Plan order: `batch_03_structured_types` / 89
- Candidate: `core_expr_candidate_hll_type_boundary`
- Fact refs: `core_type_hll_purpose`, `core_type_hll_parameters`, `core_type_hll_type_match`, `funcop_hll_compare_operators`
- SQL:

```sql
SELECT hll_empty(12,4,8,0), hll_log2m(hll_empty(12,4,8,0)), hll_empty(12,4,8,0)=hll_empty(12,4,8,0);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## JSON / JSONB (`json_domain`)

Steps: 9; Review status: **pending_review**

### `oracle_core_expr_candidate_to_jsonb`

- Batch / Plan order: `batch_03_structured_types` / 36
- Candidate: `core_expr_candidate_to_jsonb`
- Fact refs: `funcop_json_conversion_functions`
- SQL:

```sql
SELECT to_jsonb(row(1,'x'));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_jsonb_build_object`

- Batch / Plan order: `batch_03_structured_types` / 37
- Candidate: `core_expr_candidate_jsonb_build_object`
- Fact refs: `funcop_json_build_functions`
- SQL:

```sql
SELECT jsonb_build_object('k',1,'nested',{'a':2}::jsonb);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_jsonb_path_access`

- Batch / Plan order: `batch_03_structured_types` / 38
- Candidate: `core_expr_candidate_jsonb_path_access`
- Fact refs: `funcop_json_access_functions`
- SQL:

```sql
SELECT '{"a":{"b":1}}'::jsonb #> '{a,b}', '{"a":1}'::jsonb -> 'a', '{"a":1}'::jsonb ->> 'a';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_jsonb_predicates`

- Batch / Plan order: `batch_03_structured_types` / 39
- Candidate: `core_expr_candidate_jsonb_predicates`
- Fact refs: `funcop_jsonb_predicate_functions`
- SQL:

```sql
SELECT '[1,2,3]'::jsonb @> '[1,3]'::jsonb, '{"k":1}'::jsonb ? 'k';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_json_path_functions`

- Batch / Plan order: `batch_03_structured_types` / 40
- Candidate: `core_expr_candidate_json_path_functions`
- Fact refs: `funcop_json_path_search_functions`
- SQL:

```sql
SELECT json_extract_path_text('{"a":{"b":"x"}}','a','b'), json_depth('{"a":[1,2]}');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_json_mutators`

- Batch / Plan order: `batch_03_structured_types` / 41
- Candidate: `core_expr_candidate_json_mutators`
- Fact refs: `funcop_json_mutation_functions`
- SQL:

```sql
SELECT json_set('{"a":1}','$.a',2), json_remove('{"a":1,"b":2}','$.b');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_json_aggregate`

- Batch / Plan order: `batch_03_structured_types` / 42
- Candidate: `core_expr_candidate_json_aggregate`
- Fact refs: `funcop_json_aggregate_functions`
- SQL:

```sql
SELECT jsonb_agg(x) FROM (VALUES (1),(2)) v(x);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_json_type_functions`

- Batch / Plan order: `batch_03_structured_types` / 43
- Candidate: `core_expr_candidate_json_type_functions`
- Fact refs: `funcop_json_type_functions`
- SQL:

```sql
SELECT jsonb_typeof('{"a":1}'::jsonb), jsonb_typeof('[1]'::jsonb), jsonb_typeof('1'::jsonb);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_json_iteration_populate`

- Batch / Plan order: `batch_03_structured_types` / 94
- Candidate: `core_expr_candidate_json_iteration_populate`
- Fact refs: `funcop_json_iteration_functions`, `funcop_json_populate_record`, `funcop_json_record_conversion`
- SQL:

```sql
SELECT * FROM jsonb_array_elements('[1,2]'::jsonb);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 数字函数 (`numeric_functions`)

Steps: 6; Review status: **pending_review**

### `oracle_core_expr_candidate_numeric_operators`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 17
- Candidate: `core_expr_candidate_numeric_operators`
- Fact refs: `funcop_numeric_operators`, `funcop_numeric_division_no_truncation`
- SQL:

```sql
SELECT 2+3, 8-3, 4*5, 4/3, 5%4, @-5, 2.0^3;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_numeric_abs_floor_ceil`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 18
- Candidate: `core_expr_candidate_numeric_abs_floor_ceil`
- Fact refs: `funcop_numeric_function_inventory`
- SQL:

```sql
SELECT abs(-17.4), ceil(-42.8), floor(42.8);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_numeric_round_trunc`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 19
- Candidate: `core_expr_candidate_numeric_round_trunc`
- Fact refs: `funcop_round_semantics`, `funcop_trunc_semantics`
- SQL:

```sql
SELECT round(42.4382,2), trunc(42.4382,2);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_numeric_power_log`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 20
- Candidate: `core_expr_candidate_numeric_power_log`
- Fact refs: `funcop_numeric_function_inventory`
- SQL:

```sql
SELECT exp(1), ln(10), log(100), power(2,10);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_numeric_trig`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 21
- Candidate: `core_expr_candidate_numeric_trig`
- Fact refs: `funcop_numeric_function_inventory`
- SQL:

```sql
SELECT cos(0), sin(0), tan(0), atan2(2,1);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_bitwise_integer`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 22
- Candidate: `core_expr_candidate_bitwise_integer`
- Fact refs: `funcop_numeric_operators`
- SQL:

```sql
SELECT 91&15, 32|3, 17#5, ~1, 1<<4, 8>>2;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 数值类型域 (`numeric_type_domain`)

Steps: 3; Review status: **pending_review**

### `oracle_core_expr_candidate_integer_value_domain`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 1
- Candidate: `core_expr_candidate_integer_value_domain`
- Fact refs: `core_type_integer_family`, `core_type_integer_unsigned_mode`, `core_type_integer_display_width_zerofill`
- SQL:

```sql
SELECT 1::int1, 1::int2, 1::int4, 1::int8, 2147483647::integer, 9223372036854775807::bigint;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_money_roundtrip`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 2
- Candidate: `core_expr_candidate_money_roundtrip`
- Fact refs: `core_type_money_conversion`
- SQL:

```sql
SELECT '12.34'::numeric::money AS money_value, '52093.89'::money::numeric::float8 AS back_to_float8;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_float_precision`

- Batch / Plan order: `batch_01_scalar_types_conditionals` / 3
- Candidate: `core_expr_candidate_float_precision`
- Fact refs: `core_type_float_approximate_risk`, `core_type_b_mode_float_input_output`
- SQL:

```sql
SELECT 0.1::float4, 0.1::float8, 0.1::float4 + 0.2::float4;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 范围类型 (`range_domain`)

Steps: 7; Review status: **pending_review**

### `oracle_core_expr_candidate_range_constructor`

- Batch / Plan order: `batch_03_structured_types` / 57
- Candidate: `core_expr_candidate_range_constructor`
- Fact refs: `core_type_built_in_range_types`, `funcop_range_functions`
- SQL:

```sql
SELECT int4range(1,10), numrange(1.1,2.2), tsrange(TIMESTAMP '2026-01-01',TIMESTAMP '2026-12-31');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_contains`

- Batch / Plan order: `batch_03_structured_types` / 58
- Candidate: `core_expr_candidate_range_contains`
- Fact refs: `funcop_range_operators`
- SQL:

```sql
SELECT int4range(1,10) @> 5, int4range(1,10) @> int4range(2,3);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_overlap`

- Batch / Plan order: `batch_03_structured_types` / 59
- Candidate: `core_expr_candidate_range_overlap`
- Fact refs: `funcop_range_operators`
- SQL:

```sql
SELECT int4range(1,10) && int4range(5,20);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_bounds`

- Batch / Plan order: `batch_03_structured_types` / 60
- Candidate: `core_expr_candidate_range_bounds`
- Fact refs: `funcop_range_functions`
- SQL:

```sql
SELECT lower(int4range(1,10)), upper(int4range(1,10)), lower_inc(int4range(1,10)), upper_inc(int4range(1,10));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_set_ops`

- Batch / Plan order: `batch_03_structured_types` / 61
- Candidate: `core_expr_candidate_range_set_ops`
- Fact refs: `funcop_range_operators`
- SQL:

```sql
SELECT int4range(1,10)+int4range(5,15), int4range(1,10)*int4range(5,15), int4range(1,10)-int4range(5,15);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_empty_behavior`

- Batch / Plan order: `batch_03_structured_types` / 62
- Candidate: `core_expr_candidate_range_empty_behavior`
- Fact refs: `funcop_range_empty_behavior`
- SQL:

```sql
SELECT int4range(1,5) << int4range(10,20), int4range(10,20) >> int4range(1,5);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_range_datea_boundary`

- Batch / Plan order: `batch_03_structured_types` / 92
- Candidate: `core_expr_candidate_range_datea_boundary`
- Fact refs: `core_type_datea_not_range_subtype`, `funcop_range_datea_restriction`
- SQL:

```sql
SELECT daterange(DATE '2026-01-01',DATE '2026-12-31'), int4range(1,10) @> 5;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 字符串与模式匹配 (`string_domain`)

Steps: 11; Review status: **pending_review**

### `oracle_core_expr_candidate_char_length_family`

- Batch / Plan order: `batch_02_strings_and_conversion` / 8
- Candidate: `core_expr_candidate_char_length_family`
- Fact refs: `core_type_char_basic`, `core_type_varchar_max_length`, `funcop_string_inventory`
- SQL:

```sql
SELECT char_length('GaussDB'), character_length('GaussDB'), bit_length('GaussDB'), octet_length('GaussDB');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_trim_functions`

- Batch / Plan order: `batch_02_strings_and_conversion` / 9
- Candidate: `core_expr_candidate_trim_functions`
- Fact refs: `funcop_string_inventory`
- SQL:

```sql
SELECT btrim('sring','ing'), ltrim('xxabc','x'), rtrim('abcxx','x'), trim(both 'x' from 'xxabcxx');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_case_transform`

- Batch / Plan order: `batch_02_strings_and_conversion` / 10
- Candidate: `core_expr_candidate_case_transform`
- Fact refs: `funcop_string_inventory`
- SQL:

```sql
SELECT upper('gaussdb'), lower('GAUSSDB'), initcap('gaussdb database');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_substring_family`

- Batch / Plan order: `batch_02_strings_and_conversion` / 11
- Candidate: `core_expr_candidate_substring_family`
- Fact refs: `funcop_string_inventory`
- SQL:

```sql
SELECT substr('GaussDB',1,5), left('GaussDB',5), right('GaussDB',2), substring('GaussDB' from 2 for 3);
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_split_position`

- Batch / Plan order: `batch_02_strings_and_conversion` / 12
- Candidate: `core_expr_candidate_split_position`
- Fact refs: `funcop_string_inventory`
- SQL:

```sql
SELECT split_part('a,b,c',',',2), strpos('abc','b'), position('b' in 'abc');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_regexp_replace_count`

- Batch / Plan order: `batch_02_strings_and_conversion` / 13
- Candidate: `core_expr_candidate_regexp_replace_count`
- Fact refs: `funcop_regexp_functions_inventory`
- SQL:

```sql
SELECT regexp_replace('a1b2','[0-9]','*','g'), regexp_count('a1b2','[0-9]');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_like_patterns`

- Batch / Plan order: `batch_02_strings_and_conversion` / 14
- Candidate: `core_expr_candidate_like_patterns`
- Fact refs: `funcop_pattern_matching_operators`, `funcop_like_escape_rules`
- SQL:

```sql
SELECT 'GaussDB' LIKE 'Gauss%', 'GaussDB' NOT LIKE 'mysql%', 'abc' ILIKE 'ABC';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_similar_to_regex`

- Batch / Plan order: `batch_02_strings_and_conversion` / 15
- Candidate: `core_expr_candidate_similar_to_regex`
- Fact refs: `funcop_similar_to_metacharacters`, `funcop_regexp_operators`
- SQL:

```sql
SELECT 'abc' SIMILAR TO 'a+', 'abc123' ~ '[0-9]+', 'ABC' ~* 'abc';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_concat_and_quote`

- Batch / Plan order: `batch_02_strings_and_conversion` / 16
- Candidate: `core_expr_candidate_concat_and_quote`
- Fact refs: `funcop_string_inventory`
- SQL:

```sql
SELECT concat_ws(',', 'a', NULL, 'b'), quote_ident('table name'), quote_literal("O'Reilly");
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_special_char_types`

- Batch / Plan order: `batch_02_strings_and_conversion` / 90
- Candidate: `core_expr_candidate_special_char_types`
- Fact refs: `core_type_special_char_types`, `funcop_b_mode_string_helpers`, `funcop_bpchar_like_compare_guc`
- SQL:

```sql
SELECT 'abc'::name, 'a'::"char", 'abc' LIKE 'a%', 'abc' ~ '^a';
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_regexp_function_inventory`

- Batch / Plan order: `batch_02_strings_and_conversion` / 93
- Candidate: `core_expr_candidate_regexp_function_inventory`
- Fact refs: `funcop_regexp_functions`
- SQL:

```sql
SELECT regexp_count('a1b2','[0-9]'), regexp_instr('a1b2','[0-9]'), regexp_substr('a1b2','[0-9]');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 类型转换 (`type_conversion`)

Steps: 9; Review status: **pending_review**

### `oracle_core_expr_candidate_basic_casts`

- Batch / Plan order: `batch_02_strings_and_conversion` / 27
- Candidate: `core_expr_candidate_basic_casts`
- Fact refs: `core_expr_function_cast_resolution`, `core_expr_unknown_text_literal`
- SQL:

```sql
SELECT '42'::integer, 42::text, '42.5'::numeric, NULL::integer;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_cast_precision`

- Batch / Plan order: `batch_02_strings_and_conversion` / 28
- Candidate: `core_expr_candidate_cast_precision`
- Fact refs: `core_type_numeric_rounding_to_scale`, `core_expr_function_cast_resolution`
- SQL:

```sql
SELECT CAST('42.4382' AS numeric(10,4));
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_to_char_number`

- Batch / Plan order: `batch_02_strings_and_conversion` / 29
- Candidate: `core_expr_candidate_to_char_number`
- Fact refs: `funcop_typecast_to_char`
- SQL:

```sql
SELECT to_char(42.4382,'FM999.999');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_to_date_format`

- Batch / Plan order: `batch_02_strings_and_conversion` / 30
- Candidate: `core_expr_candidate_to_date_format`
- Fact refs: `funcop_typecast_to_date`
- SQL:

```sql
SELECT to_date('2026-09-28','YYYY-MM-DD');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_to_number_format`

- Batch / Plan order: `batch_02_strings_and_conversion` / 31
- Candidate: `core_expr_candidate_to_number_format`
- Fact refs: `funcop_typecast_to_number`
- SQL:

```sql
SELECT to_number('42.4382','999.9999');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_to_timestamp_format`

- Batch / Plan order: `batch_02_strings_and_conversion` / 32
- Candidate: `core_expr_candidate_to_timestamp_format`
- Fact refs: `funcop_typecast_to_timestamp`
- SQL:

```sql
SELECT to_timestamp('2026-09-28 10:00:00','YYYY-MM-DD HH24:MI:SS');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_interval_casts`

- Batch / Plan order: `batch_02_strings_and_conversion` / 33
- Candidate: `core_expr_candidate_interval_casts`
- Fact refs: `funcop_typecast_interval_functions`
- SQL:

```sql
SELECT to_dsinterval('1 02:03:04'), to_yminterval('1-2');
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_union_numeric_type_resolution`

- Batch / Plan order: `batch_02_strings_and_conversion` / 34
- Candidate: `core_expr_candidate_union_numeric_type_resolution`
- Fact refs: `core_expr_union_case_general_resolution`, `core_expr_a_mode_case_priority`
- SQL:

```sql
SELECT 1 UNION SELECT 1.2;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_array_constructor_resolution`

- Batch / Plan order: `batch_02_strings_and_conversion` / 35
- Candidate: `core_expr_candidate_array_constructor_resolution`
- Fact refs: `core_expr_array_constructor_type_resolution`
- SQL:

```sql
SELECT ARRAY[1,1.2];
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 窗口函数 (`window_domain`)

Steps: 8; Review status: **pending_review**

### `oracle_core_expr_candidate_row_number`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 71
- Candidate: `core_expr_candidate_row_number`
- Fact refs: `funcop_window_rank_functions`
- SQL:

```sql
SELECT x,row_number() OVER(ORDER BY x) FROM (VALUES (2),(1)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_rank_dense_rank`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 72
- Candidate: `core_expr_candidate_rank_dense_rank`
- Fact refs: `funcop_window_rank_functions`
- SQL:

```sql
SELECT x,rank() OVER(ORDER BY x),dense_rank() OVER(ORDER BY x) FROM (VALUES (1),(1),(2)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_ntile_percent`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 73
- Candidate: `core_expr_candidate_ntile_percent`
- Fact refs: `funcop_window_rank_functions`
- SQL:

```sql
SELECT x,ntile(2) OVER(ORDER BY x),percent_rank() OVER(ORDER BY x),cume_dist() OVER(ORDER BY x) FROM (VALUES (1),(2),(3)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_lag_lead`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 74
- Candidate: `core_expr_candidate_lag_lead`
- Fact refs: `funcop_window_lag_lead`
- SQL:

```sql
SELECT x,lag(x) OVER(ORDER BY x),lead(x) OVER(ORDER BY x) FROM (VALUES (1),(2),(3)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_first_last_value`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 75
- Candidate: `core_expr_candidate_first_last_value`
- Fact refs: `funcop_window_first_last_value`
- SQL:

```sql
SELECT x,first_value(x) OVER(ORDER BY x),last_value(x) OVER(ORDER BY x) FROM (VALUES (1),(2),(3)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_nth_value`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 76
- Candidate: `core_expr_candidate_nth_value`
- Fact refs: `funcop_window_nth_value`
- SQL:

```sql
SELECT x,nth_value(x,2) OVER(ORDER BY x) FROM (VALUES (1),(2),(3)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_ratio_to_report`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 77
- Candidate: `core_expr_candidate_ratio_to_report`
- Fact refs: `funcop_window_ratio_to_report`
- SQL:

```sql
SELECT x,ratio_to_report(x) OVER(PARTITION BY x%2) FROM (VALUES (1),(2),(3),(4)) v(x) ORDER BY x;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

### `oracle_core_expr_candidate_window_filter_pushdown`

- Batch / Plan order: `batch_04_aggregates_windows_datetime` / 78
- Candidate: `core_expr_candidate_window_filter_pushdown`
- Fact refs: `funcop_window_filter_pushdown`
- SQL:

```sql
SELECT * FROM (SELECT x,row_number() OVER(ORDER BY x) rn FROM (VALUES (1),(2),(3)) v(x)) q WHERE rn <= 2;
```
- Planned assertions:
  - no_unexpected_error
  - rows_are_captured
  - sqlstate_is_captured
  - result_semantics_are_reviewed_against_fact_refs
- Review status: **pending_review**

## 边界

- Pending review 不代表数据库行为已验证。
- 完成确认必须记录实际 rows、notices、SQLSTATE 和 reviewer 结论。
- 不得在未捕获目标数据库证据时填写 expected value。
