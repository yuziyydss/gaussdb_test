# SQL Reference Wave 8-225 Extraction V1

## 目标

抽取 字符集和字符序+系统表/视图补充：`1.4.1-1.4.7 字符集和字符序`（客户端连接/数据库级/模式级/表级/列级/表达式/合并规则）+ `8.2.19.63 PG_RESOURCE_POOL` + `8.3.16.205 PLAN_TABLE`（页 180–186 + 5005–5006 + 5405–5407）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 9（完整节合并） |
| 物理页 | 6 |
| 结构化 facts | 7 |
| Open questions | 1 |
| source resolved | 7 / 7 |
| chapter has facts | 7 / 7 |

## 覆盖能力

- 客户端连接字符集（1.4.1）：client_encoding→server_encoding转换/character_set_results返回编码/character_set_connection+collation_connection字符串默认/编码校验ERROR
- 数据库级（1.4.2）：CREATE DATABASE ENCODING/LC_COLLATE/LC_CTYPE（B模式特有字符序不支持/locale -a查看）
- 模式级（1.4.3）：CREATE SCHEMA/ALTER SCHEMA CHARACTER SET|CHARSET/COLLATE/选择规则（同指定需对应/仅charset需带默认字符序/仅collation使用对应字符集）
- 表级（1.4.4）：CREATE TABLE/ALTER TABLE CHARACTER SET|CHARSET/COLLATE/CONVERT TO CHARACTER SET（转换所有字符类型编码）/default_collation仅B模式/binary默认字符序转换文本为二进制/不支持表默认字符集与server_encoding不同
- 列级（1.4.5）：CREATE TABLE (column_name data_type [CHARACTER SET charset] [COLLATE collation])/选择规则同上
- 表达式（1.4.6）：B模式b_format_version='5.7'+b_format_dev_version='s2'时由character_set_connection和collation_connection决定/不支持[_charset_name]'string'/EXPRESSION [COLLATE collation_name]
- 合并规则（1.4.7）：字符序优先级——COLLATE语法最高→字符序冲突表达式→支持字符序列/变量/参数/CASE→特定系统函数→字符串常量和绑定参数→NULL→不支持字符序类型最低
- PG_RESOURCE_POOL（8.2.19.63）：respool_name/control_group/cpu_percent/mem_percent/active_count等资源池字段
- PLAN_TABLE（8.3.16.205）：statement_id/statement_type/operation/options/object_name/cpu_cost/io_cost等执行计划字段
