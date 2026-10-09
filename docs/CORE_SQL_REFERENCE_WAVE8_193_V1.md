# SQL Reference Wave 8-193 Extraction V1

## 目标

抽取 MySQL兼容M模式DDL：`4.4.2.7.4 DDL`（表4-163 DDL语法兼容介绍：主键索引/自增列/字符集排序/基础表定义/分区表/交换分区/CREATE TABLE LIKE/TRUNCATE/DROP/分区索引/外键/RENAME/表达式展平/CREATE VIEW/视图依赖/视图修改/ANALYZE/虚拟生成列/CTAS/ALTER TABLE/UTF8长度/默认值/binary public schema，页 3410–3434）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 24 |
| 结构化 facts | 24 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 主键/索引：ustore+using btree建ubtree；索引名/约束名/key名SCHEMA级唯一 vs 表级唯一；UNIQUE自动索引命名差异；主键索引名列差异；ASC/DESC生效差异（MySQL 5.7忽略）；前缀长度/前缀键差异；algorithm_option/lock_option不生效
- 自增列：索引第一字段建议vs必须；AUTO_INCREMENT值域；达最大值行为差异；innodb_autoinc_lock_mode不支持；批量/并行导入自增值不连续；本地临时表不预留；SERIAL类型差异；auto_increment_offset/increment约束；ALTER TABLE重写顺序差异；触发器/函数刷新last_insert_id；no_auto_value_on_zero差异；check+auto_increment同字段差异
- 字符集排序：库级/表级/列级字符集与排序规则限制
- 基础表定义：不支持选项列表；ENGINE/ROW_FORMAT不生效；ALTER TABLE限制；NULL值处理差异；CHECK约束差异
- 分区表：表达式/多分区键支持差异；虚拟生成列分区键；hash函数差异；KEY分区algorithm；LINEAR/KEY hash不支持
- EXCHANGE PARTITION：自增列/tablespace/默认值/DROP列/hash算法/外键差异
- CREATE TABLE LIKE：CHECK/主键/唯一键/CHECK名/索引名/跨sql_mode差异
- TRUNCATE/DROP：语法差异；CASCADE差异
- 分区索引：LOCAL/GLOBAL；UPDATE GLOBAL INDEX；唯一+普通索引组合
- 外键：类型敏感性/MODIFY CHANGE/MATCH选项/SET DEFAULT/唯一索引/参考列索引/临时表/默认被参考列/foreign_key_checks/级联删除
- RENAME：语法/Schema/临时表限制
- CREATE VIEW：精度传递计算操作/系统函数列名/UNION文本类型/bitstring
- 视图依赖/修改：数据类型/列名/DROP列差异；可更新视图修改；嵌套视图
- ANALYZE PARTITION：统计信息收集/大小写/回显差异
- 虚拟生成列：索引/分区键/IGNORE/CHECK/存储生成列/视图更新/表达式等价/引用限制
- CTAS：分区表/replace ignore/NULL默认值/精度传递/列名截断
- 默认值：括号形式/BLOB TEXT JSON/溢出校验/时间常量
- binary public schema：字符序继承差异
