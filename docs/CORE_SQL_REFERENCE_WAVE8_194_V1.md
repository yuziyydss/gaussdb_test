# SQL Reference Wave 8-194 Extraction V1

## 目标

抽取 MySQL兼容M模式DML：`4.4.2.7.5 DML`（表4-164 DML语法兼容介绍：DELETE/UPDATE多表/SELECT INTO/REPLACE INTO/LOAD DATA/LIMIT/反斜杠/INSERT少于字段/ORDER BY/UPDATE DELETE ORDER BY LIMIT/外键timestamp/NATURAL JOIN/JOIN语法/SELECT列名/INTO OUTFILE/三段式/UPDATE SET顺序/IGNORE/SHOW系列/ONLY_FULL_GROUP_BY/SELECT变量/子查询多列/子查询精度/SHOW DATABASES/行表达式/TIME DATETIME精度/日期数值运算/unsigned/FOR UPDATE/SELECT语法范围/UNION顺序/WITH AS/用户变量/ON DUPLICATE KEY/TABLE语法/INSERT VALUES SET别名/FORCE USE IGNORE INDEX/UNION EXCEPT类型/子查询目标表/LIMIT NULL，页 3434–3485）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 51 |
| 结构化 facts | 45 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 多表操作：DELETE/UPDATE并发重新匹配范围差异；m_format_dev_version='s2'后校验一致
- SELECT INTO：GaussDB可建表/不支持集合运算/不支持用户变量赋值
- REPLACE INTO：时间0值严格/宽松模式差异
- LOAD DATA：严格模式一致宽松未适配/IGNORE LOCAL功能限制/列重复/换行符/SET表达式/表vs视图/Windows换行/LOCAL参数/字段多于目标表/文件尾分隔符
- LIMIT：BIGINT vs unsigned LONGLONG上限/小数取值
- 反斜杠：NO_BACKSLASH_ESCAPES vs standard_conforming_strings
- INSERT少于字段：按顺序赋值 vs 报错
- ORDER BY：GROUP BY/DISTINCT排序列限制
- UPDATE DELETE ORDER BY LIMIT：并发重新排序差异
- 外键timestamp/datetime：UPDATE/DELETE外表报错
- NATURAL JOIN：LEFT/RIGHT不指定/多次JOIN/join顺序/歧义场景
- JOIN语法：逗号连接/USE INDEX FOR JOIN/STRAIGHT_JOIN执行计划
- SELECT列名：select_column_name配置/注释/转义/截断/布尔值/null/表达式/-含表达式/pymysql编码
- INTO OUTFILE：FLOAT DOUBLE REAL精度
- 三段式：SELECT/UPDATE REPLACE SET/INSERT SET差异
- UPDATE SET顺序：顺序执行 vs 一次性UPDATE/同一列多次
- IGNORE特性：WARNING差异
- SHOW系列：COLUMNS/CREATE DATABASE/CREATE TABLE/CREATE VIEW/PROCESSLIST/ENGINES/STATUS/INDEX/CHARACTER SET/COLLATION/TABLES/TABLE STATUS
- ONLY_FULL_GROUP_BY：非聚合列限制/函数列表达式/正整数
- SELECT变量：@不指定变量名/BOOLEAN输出t/f vs 1/0
- 子查询：多列/精度传递/PBE精度/目标表引用
- SHOW DATABASES/行表达式：utf8mb4_bin/row()支持
- TIME DATETIME精度：NUMERIC转TIME/DATETIME进位差异
- 日期数值运算：enable_precision_decimal转换差异
- unsigned：嵌套子查询unsigned覆盖差异
- FOR UPDATE/SHARE：与UNION/DISTINCT等/外连接锁/ORDER BY并发/多次锁子句
- SELECT语法范围：HAVING/WITH ROLLUP/空表/表别名带字段/无FROM带WHERE
- UNION ORDER：hashagg不保证顺序
- WITH AS：递归列类型/不支持聚合窗口/LIMIT OFFSET/DISTINCT GROUP BY/列宽截断/外连接
- 用户变量：变量名转义/求值顺序/子查询赋值/ORDER BY赋值/IF IFNULL COALESCE赋值/FROM子查询物化
- ON DUPLICATE KEY UPDATE：VALUES()三段式/子查询引用/多列顺序/受影响行数/VARCHAR转数值
- TABLE语法/INSERT VALUES SET别名/FORCE USE IGNORE INDEX
- UNION EXCEPT类型：第三查询类型为准
- LIMIT NULL：等价无LIMIT vs 报错
