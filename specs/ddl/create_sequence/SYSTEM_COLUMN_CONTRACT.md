# OWNED BY 系统列：有限静态合同

本批只补两个独立候选：A 模式的 `OWNED BY ...rowid` 和 `...rowno`。
本地 CREATE SEQUENCE 正文 L19 禁止这种关联；CREATE TABLE 正文
L617–632 描述 `hasrowid=on` 添加系统列的行为与模式、表形态限制。
跨包行为事实用于场景，环境与约束事实用于取值/环境要求，不混用事实类型。

## 从规格到 SQL

1. 两个 manifest 各选择一个完整的 OWNED BY 值，其余序列选项省略。
2. 取值引用 `fixture_create_sequence_system_owner`；前置为
   `CREATE TABLE g_a3_cs_system_owner (id INTEGER) WITH (hasrowid = on);`。
3. 生成器调用共享 `system_column_contract`，核对实际 setup、目标 SQL、
   teardown 和 A 模式/新用户 Schema/创建权限 gate，而不只相信 provides。
4. 两个 planned scenario 分别绑定对应候选，保留目录身份和目标错误校准。

普通 `rowid INTEGER` 列不能替代系统列；`hasrowid=off`、临时表、额外
未审 setup 或缺失模式 gate 均不能通过这个有限合同。系统列类型尚未校准，
所以 fixture 的普通列清单只声明 `id INTEGER`，不编造 rowid/rowno 类型。

## 仍未完成的内容

- 这是文档支持的负向候选，不是数据库通过记录。错误类别为
  `system_column_ownership_forbidden`，SQLSTATE 留空、Oracle 保持待验证。
- 执行前须确认 A 数据库、隔离命名空间、相同对象所有者及实际目录身份，
  并独立验证关联普通 id 列的正向对照；不能把 setup 错误算目标错误。
- hasrowid 还自动建立依赖序列/索引。真实创建回执、依赖归属清单及清理
  验证尚未实现；若目标意外创建成功，还需单独清理该目标序列。
- 当前单条 DROP TABLE RESTRICT 仅为候选清理声明，不证明已安全清理。
- 旧的通用系统列场景和能力矩阵缺口仍保留；没有完成所有系统列、所有
  序列选项、ALTER TABLE SET WITH ROWID 或跨模式的覆盖。

本地静态回归覆盖实际生成和伪造前置的拒绝；数据库执行需要另行授权。
