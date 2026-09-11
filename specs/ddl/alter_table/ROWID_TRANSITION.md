# SET WITH ROWID：一个有限转换，不是整个特性完成

本地ALTER TABLE正文L208–216明确：该动作添加rowid、rowno并开启hasrowid，
只支持A模式，不允许系统/临时/unlogged/外表、oid/gs_tuple_uid及普通同名列。
L787–801又说明不能用普通SET/RESET将hasrowid改成不同值。

本批只生成：

```sql
-- 前置：另行授权的A模式、新用户Schema、同一表创建主体
CREATE TABLE g_a3_at_rowid (id INTEGER) WITH (hasrowid = off);
ALTER TABLE g_a3_at_rowid SET WITH ROWID;
-- 候选清理；需要实际归属回执，不表示已执行或恢复完成
DROP TABLE g_a3_at_rowid RESTRICT;
```

通过原AST的action列表生成，不手写SQL快照。独立的表/动作profile只选择
这个有限形态；共享system_column_contract核对实际setup、目标及teardown。
已开hasrowid的表不能冒充从off到on，普通rowid列也不能代替系统列。

CREATE SEQUENCE的系统列负向用例恰好相反：它必须以hasrowid=on为前置。
两类用例复用同一个有限表结构/模式/清理检查，但不混用初始状态或Oracle。

候选预期仅为syntax_only成功；目录行为另有planned场景，仍缺前后目录状态、
隐式序列/索引的真实归属与清理回执。空表不覆盖压缩数据解压；未覆盖所有
受限对象、冲突列、重复操作、在线DDL、继承或分区。原通用ROWID场景和
needs_profile标记保留。没有连接数据库，也没有增加执行授权。
