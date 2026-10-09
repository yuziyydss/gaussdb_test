# SQL Reference Wave 8-195 Extraction V1

## 目标

抽取 MySQL兼容M模式DCL/其他语句/用户与权限：`4.4.2.7.6 DCL` + `4.4.2.7.7 其他语句` + `4.4.2.7.8 用户与权限`（表4-165/4-166/4-167/4-168，页 3485–3495）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整节合并） |
| 物理页 | 10 |
| 结构化 facts | 14 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DCL（4.4.2.7.6）：SET NAMES指定COLLATE差异；DESCRIBE语句权限/模糊匹配差异；START TRANSACTION WITH CONSISTENT SNAPSHOT差异；SET设置用户变量差异（变量名转义/连续赋值/聚集函数）；SET设置系统参数差异（BOOLEAN/sql_mode）；USE切换当前模式差异
- 其他语句（4.4.2.7.7）：锁机制差异（事务块/read锁写/读其他表/同表锁释放/LOCK TABLE）；PBE差异（重复PREPARE/报错阶段）；ODBC转义表达式差异
- 用户与权限（4.4.2.7.8）：MySQL 27种赋权类型 vs GaussDB按级别支持（数据库/模式/表视图/列/序列）；GRANT语法差异（*.* vs {DATABASE}/schema vs {SCHEMA}/用户名/GRANT中修改用户属性/GRANT PROXY）；public/owner/USAGE差异；管理员角色/ANY权限差异；SHOW GRANTS vs gsql元命令/删除重建权限/模糊匹配/用户不存在默认创建
