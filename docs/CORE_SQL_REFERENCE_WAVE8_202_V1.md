# SQL Reference Wave 8-202 Extraction V1

## 目标

抽取 GUC使用说明：`7.3.1 GUC使用说明`（GUC参数修改注意事项/影响视图/函数默认值/存储过程编译/计划缓存的GUC参数，页 4141–4170）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 29 |
| 结构化 facts | 19 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GUC修改注意事项：内部参数/硬件限制/参数联动/设置极端/路径规则/INT_MAX DBL_MAX/影响机制（视图/函数默认值/编译产物/计划缓存）
- convert_string_to_digit：视图行为不一致
- behavior_compat_options='current_sysdate'：SYSDATE操作系统时间 vs 数据库时间
- a_format_version='10c'+a_format_dev_version='s1'：NVL2等新增功能
- fixed_date：固定时间不影响计划缓存
- a_format_func_col_name：投影列名差异
- m_format_behavior_compat_options：enable_escape_string等选项计划缓存
- disable_keyword_options：关键字行为
- backslash_quote：safe_encoding/off差异
- m_format_dev_version='s1'：FETCH FIRST/TRUNCATE CASCADE/USING INDEX TABLESPACE/DROP CASCADE语义/REFERENCES列约束
- m_format_dev_version='s2'：生成列STORED VIRTUAL默认
- sql_mode='ansi_quotes'：反引号+双引号标识符
- enable_indexonlyscan_or：索引扫描方式
- character_set_connection/collation_connection：常量字符集字符序
- standard_conforming_strings：Unicode转义
- ignore_like_default_escape：LIKE反斜杠
- enable_set_variables：SET @var语法
