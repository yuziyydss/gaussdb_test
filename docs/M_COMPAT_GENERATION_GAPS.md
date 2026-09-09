# M 六包生成模型缺口收敛（2026-09-08）

范围：CREATE TABLE、CREATE TABLE PARTITION、CREATE TABLE SUBPARTITION、DROP FUNCTION、EXPLAIN、INSERT。仅校对本地PDF来源、规格、生成SQL和静态回归；无数据库连接/执行、无Git提交推送，原循环保持暂停。

## 六个缺口及根因

| 包 | 实际问题 | 修正与证据 | 普通用例前→后 |
|---|---|---|---:|
| m_create_table | ORIENTATION=column被标成valid，但M原文明示不支持；已有负向，审计仍要求正向 | 改为invalid，保留原rule与负向，不生成伪成功 | 18→18 |
| m_insert | 给生成列赋具体值被标成valid；ON DUPLICATE只有视图负向，缺表正向 | generated_literal改invalid；duplicate仍valid；新增真实主键冲突表和更新用例 | 22→26 |
| m_create_table_partition | auto_count把“此批选三个分区”误当产品必须指定数量 | 保留取值策略为hash_auto的local_rule，新增原文明示合法的HASH/KEY省略数量正向；不造错误负向 | 30→35 |
| m_create_table_subpartition | automatic/implicit是内部profile标签，两条命名策略被当成数据库约束 | 两条表达式及理由移入各manifest的local_rules；真实显式数量不匹配rule和负向不变 | 22→22 |
| m_drop_function | 显式RESTRICT依赖括号签名的语法规则没有负向 | 新增省略签名但写RESTRICT的目标负向；真实函数前置、内部接口和独占库门禁保留 | 8→9 |
| m_explain | BUFFERS TRUE需要ANALYZE，但只有正向/过滤，没有规则负向 | 对真实表SELECT新增ANALYZE FALSE + BUFFERS TRUE负向，不用DML制造额外副作用 | 21→22 |

主要来源：M CREATE TABLE的ORIENTATION限制；M INSERT L15–16、L105–107和L147；M CREATE TABLE PARTITION L425–434；M CREATE TABLE SUBPARTITION L279–292；M DROP FUNCTION完整产生式；M EXPLAIN L100–104。正式factor/source中继续保留原始章节、行锚点及哈希。

三条分区规则的迁移不是取消产品约束来让指标变绿：反向组合的SQL并不必然非法。原文明确“不列定义、不指定数量”会创建一个分区；automatic和implicit标签本身更不会发送给数据库。因此选域策略属于manifest，而显式定义数不匹配、边界逆序等真实产品限制仍留在factor.rules中并保留正反例。没有改审计器的规则正反覆盖标准。

## 一个真实新增例子

INSERT的新增fixture：

```sql
CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);
INSERT INTO m_b01_upsert VALUES (7,3);
```

目标候选：

```sql
INSERT INTO m_b01_upsert VALUES (7,9)
ON DUPLICATE KEY UPDATE qty = VALUES(qty);
```

这里id=7确实与主键冲突，不是只拼上关键字。planned场景预期最后只有`(7,9)`，精确清理为`DROP TABLE m_b01_upsert`。初次新增fixture时，DDL的主键非空与provides中的nullable=true不一致，被现有生成门禁拒绝；已改为nullable=false，未降低列合同校验。

上述SQL是离线说明，不应拼成脚本直接执行。新负向用例只有来源支持的错误类别，SQLSTATE仍标记needs_verification，不将任意失败当通过。

## 当前结论与边界

- 新增4个manifest、11条普通SQL；M总数1059→1070，全库4980→4991。
- 原有731份SQL快照均未修改或删除，包括528份通用模式快照；新文件仅位于上述4个包。
- 六包的generation_model_complete由false变为true；当前92个有普通生成域的M包均通过该包级生成模型检查。
- 这仅表示目前声明的有限取值、规则证据和组合生成闭合，不表示完整PDF章节已抽全。六包的source/static/behavior全章完整标志仍为false。
- 93/93已建包；GENERATED UPDATE SYSTEM仍是审阅包，不加入92个普通生成域，也不加入1070条SQL。
- 错误Oracle、未建模正文、原子性精审和planned场景保留真实缺口，后续仍需按依赖推进。

## 验证入口

```bash
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_generation_gaps -v
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_remaining.py
GAUSSDB_ENABLED=false python3 -m unittest discover -s tests -p 'test_m_compat*.py' -v
```

不要重跑第二批固定基线验证器覆盖`combined_progress.json`。修正位于原有pilot/batch03/batch04/batch06构建器中，可以由它们输出补丁复建，没有手改SQL。

专项6/6通过（13.802秒），完整M静态回归178/178通过（411.692秒），全量生成及累计审计退出0；3038/3038可行pair覆盖。仍有28个M包需要校准错误Oracle，156个planned场景，不能把它们算作行为已验证。

原始审计与快照哈希保存在`generated/m_compat_generation_gaps/before.json`；最新累计报告为`generated/m_compat_remaining/progress.json`。本轮完整回归结果与失败历史保存于`generated/m_compat_generation_gaps/verification.json`，未将旧批次回归冒充本轮。
