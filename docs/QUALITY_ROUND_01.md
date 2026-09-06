# 第一轮：全库质量待办与 12 包有限域复核

范围：冻结本地 PDF 的 224 个 general SQL 包。只检查和完善原文抽取、规格与静态 SQL；不连接数据库、不提交推送、不改 V1 公共模型。

## 全库待办清单

新增 `scripts/build_quality_backlog.py`，直接严格加载全部包并重新运行审计，不依赖只含有 manifest 包的生成报告。

| 待办类型 | 本轮数量 |
| --- | ---: |
| 待确认事实 | 603 |
| 特性覆盖缺口 | 869 |
| 维度取值覆盖缺口 | 244 |
| 规则证据缺口 | 1 |
| 待校准错误 Oracle | 98 |
| 未就绪场景 | 507 |
| 尚无对应场景的事实 | 7 |
| 无普通 manifest 的包 | 56 |
| 关联待办合计 | 2385 |

条目可能对应同一个根因，**不能相加为特性分母，也不能用作通过率**。每条保存稳定 ID、所属包、具体文件/引用、原始证据、可用的 fact/source unit 定位、处理路径、下一动作和验收条件。自动路由不是根因判断，不会按关键词自动把功能标成“不支持”，也不改规格或队列状态。

本地证据：`work/quality_round_01/backlog_before.json`、`backlog_after.json`。后者修正了 `dimension.value_id` 的定位，使取值待办能回到真实 factor/matrix 与来源事实；无选项的空 token 可能没有独立 fact，不伪造引用。

## 固定复核范围

CREATE SCHEMA、DROP SCHEMA、GRANT、UPDATE、DELETE、INSERT ALL、REPLACE、CREATE TABLE PARTITION、CREATE TABLE SUBPARTITION、ALTER TABLE PARTITION、ALTER TABLE SUBPARTITION、COPY。

复核方式是**代表产生式与 PDF 对照，加已生成有限域的自动检查**，不是人工逐条证明所有 SQL 可执行，也不是这 12 章完整语义审计。

## 已实施的三项改进

### 1. AUTHORIZATION 模式创建的清理缺口

原清单的两条候选 `setup_sqls/teardown_sqls` 都为空，虽有预配置角色门禁，创建模式后仍缺少回收步骤。现加入独立事务 fixture：`BEGIN → CREATE SCHEMA … AUTHORIZATION … → ROLLBACK`，同时覆盖显式模式名与按角色名创建的形式。

不删除预配置角色，不用 `DROP OWNED BY` 或清空角色对象兜底。需要独立连接、无外层事务，仍为 syntax_only；实际失败路径和权限语义未验证。

### 2. COPY 括号选项与原文对齐

PDF 物理页 1379 的 option 产生式写为 `FORMAT 'format_name'`。将现有 `FORMAT TEXT/CSV` 改为 `FORMAT 'text'/'csv'`，同时将值的来源引用指向实际语法行。CSV 的 HEADER/FORCE_QUOTE 不进入 TEXT 分支。

这是消除未证实语法变体，**不是声称旧写法在数据库中必然报错**。COPY TO STDOUT 仍需要协议级结果收集器，不能因生成成功标为行为通过。

### 3. 分区提供者接入 UPDATE/DELETE

旧待确认项仍声称分区建表章节未进入 catalog；本轮已将实际补充正文、限定 Fact 和现有分区 fixture 接入两个包。

- 每个包新增 4 个目标 profile：一级名称、一级 FOR 值、二级名称、二级 FOR 值。
- 两个新 manifest 分别生成 8 条候选，合计 16 条。
- 使用已有两列 INT 的 RANGE / RANGE-RANGE 表和种子数据；WHERE 引用 col_1，UPDATE 使用 `col_2 = col_2` 保持键值不变，避免错误引用旧普通表的 id/note/qty。二级表两列都是分区键；抽查完整 SQL 时发现初稿的 `col_2 = 42` 会超出叶子边界，已用失败回归捕获并修正，不将此候选当作键移动或实际数据变更的验证。
- SETUP 按 Schema → BEGIN → 分区表 → seed 排序，TEARDOWN 先 ROLLBACK 再回收专用 Schema。
- 独立有限域投影核对 UPDATE 98/98 pair、DELETE 164/164 pair；包含固定维度的 pair，不把数量当作额外交互能力。

`needs_profile` 改为有有限代表，但仍是 `coverage_mode: representative`，相关 open question 不关闭。多分区并集、其余分区策略、分区键移动和受影响行 Oracle 继续留账。

## 排除的误判与保留边界

- DELETE 多表语法中的 FROM/USING 在 PDF 物理页 1650 明确可选；未按其他数据库习惯强行改写。
- UPDATE 支持目标别名限定 SET 列，正文已有例证；未误删该分支。
- GRANT 的 PUBLIC/GRANT OPTION、权限与对象类别有限组合继续检查；高级权限和外部对象不假装已覆盖。
- INSERT ALL 的 ALL/FIRST、单行 VALUES 和最终查询保留 A 模式门禁；REPLACE 使用真实默认值和主键冲突种子。
- 分区九种布局、边界递增、切点和同父叶子合并有有限检查；未提供 GLOBAL 索引时不宣称索引行为覆盖。
- 固定命名空间和外部角色不是共享业务库的执行许可。隔离环境、所有权保护以及 setup 失败后的安全清理仍是数据库阶段的前置门槛。

## 验证与交付状态

修复前 12 项复核测试有 3 项失败；修复后本轮与第十一批联合专项 32/32 通过，待办脚本 6/6 通过。严格 lint 通过；全库重新生成 521 个 manifest、3782 个唯一 case ID（3754 条不同 SQL 文本，28 个跨因子同文组）。本轮 12 包合计 63 个 manifest、632 条候选。

首轮全量回归 371 项有 1 项失败：旧 12 章依赖清单未包含新分区提供者。已将验收清单扩展为 15 章（增加 CREATE SCHEMA、一级/二级分区表），补实际 profile/fixture 依赖闭包与来源校验，保留依赖图精确比较；专项 4/4 通过。后续重跑在发现分区键赋值问题后主动中止，不计作成功。

最终重跑 **372/372 通过，1117.948 秒**；本轮修正后的联合专项 **22/22 通过**。最终日志为 `work/quality_round_01/tests_full.log`，机器结果及证据哈希为 `work/quality_round_01/result.json`。15 章的实际正文/PDF 哈希、20 条 Fact 引用、2 条直接 fixture 引用和 6 组 fixture 闭包已重新核对；没有将历史 12 章整套 PDF 再抽取/失效注入报告冒充本轮新跑的 15 章报告。

2385 条待办总数未下降是预期结果：没有通过关闭 open question 或缩小特性分母制造进步。224 包原文审计仍通过；没有新的数据库行为验证。

## 重跑入口

```bash
python3 scripts/build_quality_backlog.py --output work/quality_round_01/backlog_current.json \
  --review-factor create_schema --review-factor drop_schema --review-factor grant \
  --review-factor update --review-factor delete --review-factor insert_all \
  --review-factor replace --review-factor create_table_partition \
  --review-factor create_table_subpartition --review-factor alter_table_partition \
  --review-factor alter_table_subpartition --review-factor copy
python3 -m unittest tests.test_quality_backlog tests.test_quality_round_01 -v
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 -m unittest discover -s tests -v
```

第七至十一批和剩余 129 包报告保留为历史验收快照，不重写其历史哈希和数量。当前生成数量以最新生成报告为准。

下一轮优先处理：固定命名空间的执行前所有权门禁、COPY 协议契约、SET/目标列的通用结构约束，以及分区 DML 行为场景。任何数据库执行另行授权。
