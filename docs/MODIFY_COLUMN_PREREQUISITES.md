# 双列 MODIFY 的有限前置合同

适用来源：本地 PDF 一般 ALTER TABLE 正文 L359–363 的括号多列形式。它与后面的 B 模式扩展 `MODIFY COLUMN ...` 分开处理；本实现不推导 M 兼容行为。

实际消费者是 `manifest_alter_table_modify_multi_fresh`：

```sql
CREATE TABLE t_at_modify_multi (id INTEGER,note VARCHAR(64),amount INTEGER);
INSERT INTO t_at_modify_multi VALUES (1,'alpha',10),(2,'beta',20);
ALTER TABLE t_at_modify_multi MODIFY (note VARCHAR(96), amount NOT NULL);
```

以前生成器主要核对声明的源列存在。现在，选中的表 profile 通过已有 `properties` 扩展槽声明：

```yaml
column_modify_contract:
  kind: ordinary_widen_and_not_null
  widen_column: note
  not_null_column: amount
```

生成器在实际 SQL 和 fixture 编译后调用共享合同，不能仅凭 `provides` 的列名通过：

- 真实第一条 setup 必须创建该普通新表，所有列原来可空、无默认及其他约束；后续只允许该表的有限种子 INSERT。
- 目标 SQL 必须恰好修改两个不同列：一个 VARCHAR 严格扩长，一个设为 NOT NULL；实际目标和列身份必须对应 profile。两项先后次序不改变列顺序。
- 只检查无列清单的全宽、按原列顺序的字面量 VALUES 种子。NULL/DEFAULT 不能留在要设 NOT NULL 的列中；因本合同排除默认定义，DEFAULT 代表 NULL。
- 每个种子值须先通过修改前的共享类型、范围和长度检查。80字符字符串不能因目标将扩大到96而跳过原64的限制；非ASCII的长度/编码语义仍待审。

源缩短、依赖对象、动态输入、不同类型转换、任意表达式、其他 MODIFY 产生式及未知模式不会自动获得此合同。长度解析暂限四位十进制字面量，这是当前有限实现范围，不是产品最大长度限制。

合同返回的是静态前置证据，不是修改后的数据库目录或行结果。现有场景仍 `planned`，统计信息、依赖重建、执行错误身份、并发与真实清理均需另外授权和验证。原用例的 SQL、ID、expected、fixture 和 Oracle 状态没有修改。

本轮结果与带源码指纹的证据见[9月9日演进记录](PROJECT_EVOLUTION_20260909.md)。

## 共用 fixture 入口

相同有限种子校验已经集中在 ADD、RENAME/CHANGE、MODIFY 共用的入口，而非仅在 MODIFY 中重复维护。它读取全宽字面量行，按原始列定义校验并返回已核对的行；`VALUES(id,...)`不再被当成已有行的字面量，未知查询、部分列种子及编码/长度情形也不冒充本合同覆盖。查询和部分列 INSERT 本身不因此被认定非法，只是不在当前这项“有限字面量 fixture”合同内。

NULL 仍可用于可空表的 ADD、RENAME 场景；只有确实要设置 NOT NULL 的 MODIFY 消费者拒绝它。这是共享前置校验，不是批量把所有 seed 改为非空。
