# SQL Reference Wave 8-200 Extraction V1

## 目标

抽取 MySQL兼容B模式SQL/驱动：`4.4.3.7 SQL` + `4.4.3.8 驱动`（表4-192~4-196，页 3549–3573）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 24 |
| 结构化 facts | 15 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 表达式（表4-192）：@var_name/@@var_name部分支持
- DDL（表4-193）：UNIQUE INDEX|KEY不支持/ustore ubtree；自增列（建议索引第一字段/AUTO_INCREMENT范围/自增值达最大值/innodb_autoinc_lock_mode/批量混合/并行导入/临时表/SERIAL/offset increment/ALTER TABLE重写/统计信息/last_insert_id 128位/触发器刷新/GUC超范围/no_auto_value_on_zero）；前缀索引（2676/不支持函数名前缀键/主键不支持）；字符集排序规则/添加列/修改列/EVENT/分区表/comment支持；EXCHANGE PARTITION（自增列/tablespace/默认值/DROP列/hash算法/外键）；DROP KEY；CREATE TABLE LIKE（CHECK/主键名/唯一键名/CHECK名/索引名/跨sql_mode/跨数据库）；RENAME（语法/Schema/临时表/校验顺序）；ADD PARTITION多分区语法差异
- DML（表4-194）：DELETE多表/ORDER BY LIMIT/指定分区支持；UPDATE多表/ORDER BY LIMIT/指定多分区支持；SELECT指定多分区/SELECT INTO建表不支持集合运算；REPLACE INTO时间0值/位串初始值；LOAD DATA（严格一致宽松未适配/IGNORE LOCAL/路径/单引号分隔符/列重复/分隔符相同/转换报错/SET表达式/表vs视图/Windows换行/字段多于目标表/文件尾分隔符）；INSERT IGNORE（降级错误信息/时间零值1970 vs 0000/bit类型/精度显示/warnings条数/触发器/bool serial零值）
- DCL（表4-195）：SET用户变量64字节截断；SET TRANSACTION session/global差异；SET NAMES指定COLLATE
- 驱动（表4-196）：getString ZEROFILL补位差异
