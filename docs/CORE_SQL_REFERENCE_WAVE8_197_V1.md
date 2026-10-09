# SQL Reference Wave 8-197 Extraction V1

## 目标

抽取 MySQL兼容B模式数据类型：`4.4.3.1 数据类型`（数值/日期时间/字符串/二进制/JSON/属性/转换，表4-170~4-178，页 3498–3525）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 27 |
| 结构化 facts | 26 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 整数类型公共差异：输入截断行为/操作符类型提升/负数转换/显示宽度/聚集函数variance stddev差异
- BOOL/BOOLEAN：MySQL TINYINT vs GaussDB BOOL真值假值文本
- MEDIUMINT：3字节 vs 4字节INT映射
- 任意精度：FIXED不支持；DECIMAL ^指数/精度整型/截断差异
- 浮点类型：KEY分区不支持/^操作符/精度整型/非法入参ERROR
- SERIAL：BIGINT(20) UNSIGNED AUTO_INCREMENT vs INTEGER NOT NULL nextval/INSERT DEFAULT/REPLACE引用列差异
- DATE/DATETIME/TIMESTAMP/TIME/YEAR：输入格式/分隔符/无分隔符/输出格式/0值转换/取值范围/精度/p 'str'表达式/操作符/类型转换/时区差异
- INTERVAL：数据类型 vs 表达式/负数/运算表达式/返回类型/范围
- CHAR/VARCHAR/TEXT/LONGTEXT：长度校验/转义字符/Cast as char/操作符（整型返回/除以0/~ / ^）差异
- ENUM不支持SET支持
- BINARY/VARBINARY/BIT不支持
- BLOB系列：BYTEA映射/1GB/转义/'\0'输出/不支持运算符
- JSON：与原生JSON一致
- 数据类型属性（表4-178）：全部支持
- 数据类型转换规则：pg_cast vs MySQL任意转换/目标类型确定规则差异
