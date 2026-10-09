# SQL Reference Wave 8-220 Extraction V1

## 目标

抽取 GUC版本和平台兼容性：`7.3.17 版本和平台兼容性`（历史版本兼容性/平台和客户端兼容性，页 4494–4649）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 155 |
| 结构化 facts | 10 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 历史版本兼容性（7.3.17.1）：array_nulls/backslash_quote（on_with_encoding_warning等5种模式）/escape_string_warning/quote_all_identifiers/sql_inheritance/standard_conforming_strings/synchronize_seqscans/enable_beta_features/enable_recordtype_check_strict/plsql_block_concat_typename/default_with_oids/system_view_version/enable_subtype_inherit_notnull_constraint
- 字符集参数：character_set_connection/client/database/server/results系列+collation系列（MySQL兼容/查看返回当前会话值非GUC副本）/enable_multiple_charset/enable_show_view_original_definition
- 日期/格式：fixed_date（影响SYSDATE/CURRENT_DATE等/视图函数默认值编译产物计划缓存）nls_date_format/nls_timestamp_format/nls_timestamp_tz_format/nls_nchar_characterset/mapping_date_to_datea
- 兼容开关：group_concat_max_len/lastval_supported/max_function_args/max_subpro_nested_layers/transform_null_equals/support_extended_features
- sql_compatibility INTERNAL（A=O/B=MY/C=TD/PG=POSTGRES/M=M-Compatibility/CREATE DATABASE设置）
- b_format_behavior_compat_options（B模式表7-21：enable_set_variables等/当b_format_version非空时设为all不可修改）
- a_format_version+a_format_dev_version（A兼容10c/s1~s6版本增强/a_format_func_col_name投影列名/影响视图函数默认值编译产物计划缓存）
- m_format_behavior_compat_options（M兼容表7-22：enable_escape_string/select_column_name/cast_as_new_json/disable_illegal_function_syntax/grant_database_nomapping等/m_format_dev_version s1/s2/s4/选项变化不让计划重新生成）
- gs_format_behavior_compat_options（表7-37：sqrt_karatsuba/allow_textconcat_null等）
- 其他兼容参数：max_allowed_packet/div_precision_increment/lower_case_table_names（M兼容0/1/2）/sql_select_limit/forbid系列/enable系列/~30个其他兼容性参数
