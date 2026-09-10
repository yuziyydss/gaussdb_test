# 项目路线图

本路线图只记录已由代码和测试证明的能力，以及具有明确验收条件的下一阶段。数据库执行和当前 PDF（5686 个物理页）全量分类/抽取未完成前，不使用“工业级闭环”描述。

## 当前阶段

```text
Legacy V0兼容
      │
      ├── 已完成：生成器正确性加固
      ├── 已完成：Factor Package V1静态架构
      ├── 已完成：PDF五章框架验收与信任门禁校准
      ├── 已完成：内网离线任务队列
      ▼
已完成：冻结 Factor Package V1 公共契约并验收第二批 10 章
      ▼
已完成：224 个 general SQL 章节包绑定与原文账本审计
      ▼
当前：有限生成域、运行时契约与 Oracle 缺口处置
      ▼
后续：V1真实执行与非SQL参考Schema
```

当前质量状态见 [夜间演进](NIGHT_EVOLUTION_20260910.md)；前一完整全量回归见 [历史静态验收节点](MILESTONE_STATIC_ACCEPTANCE_20260909.md)，不得沿用旧测试数认证新版本。此前来源与修复过程见 [9月9日演进记录](PROJECT_EVOLUTION_20260909.md)；较早历史记录保留在 [第三轮质量复核](QUALITY_ROUND_03.md)和[第二轮质量复核](QUALITY_ROUND_02.md)。有限写入形状检查不等于
完整 SQL 解析；原文全域缺口、conditional 环境消费和未校准 Oracle 继续单独留账。

## 已完成并有自动化证据

- [x] 约束解析失败即报错，不再静默放行。
- [x] 约束感知Pairwise生成和100%可行Pair后置验证。
- [x] case ID和跨manifest SQL重复检测。
- [x] Pydantic严格模式、重复ID和引用闭合校验。
- [x] Factor Package V1单一写入目录和七类文件职责。
- [x] 有限展开的结构化AST、重复结构和受控嵌套查询；任意深度递归仍按 feature gap 管理。
- [x] SELECT、INSERT和CREATE INDEX结构契约。
- [x] Fixture setup/provides/teardown静态模型。
- [x] 负向用例目标错误类别、SQLSTATE集合和错误正则。
- [x] Source Unit逐行账本和原子性审计器。
- [x] 本地冻结 PDF 的完整书签目录、父文档哈希和五章精确拆章文本。
- [x] CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT、INSERT 五章均改为 PDF 绑定的 V1 校准包。
- [x] 生成层区分实际消费的 AST 维度、代表值覆盖与 feature 全域覆盖。
- [x] AI厂商无关的内网任务队列、SHA-256对账和断点恢复。

## 阶段A（已完成）：五章框架验收与 V1 冻结

目标：让五个样本证明公共模型能发现错误生成、假 Pairwise、来源漂移、环境混淆和假闭环，然后冻结 V1 公共契约。

验收：

- source unit 重叠、未审阅和复合主张都能被机器发现并使 source 结论为 false；未关闭的章节级项可留在队列中；
- matrix 中每项 feature 都区分 `all/any/representative`，已知遗漏不得缩小分母；
- 每个 confirmed 非 example fact 都有与事实类型匹配的下游消费者；
- 负向错误 Oracle 有 PDF/实机证据；未校准错误保持 pending，不伪造 SQLSTATE；
- 严格 lint、全量回归和 PDF 来源对账通过；已建模的可行 pair 全部覆盖；
- 不通过删除事实或降低门禁制造“绿色”。

阶段A不要求五章 `static_complete=true`，也不要求数据库行为 100%。章节级缺口继续作为并行质量队列。

## 阶段B（已完成）：第二批约 10 个代表性章节

状态：已完成静态抽取与生成验收；10 个章节的公开缺口保留在
`needs_review`。详细证据见 [第二批 PDF Doc2Spec 验收结果](BATCH_02_RESULT.md)。

建议选择简单 DDL、DCL、TCL、普通 DML 和复杂语法的代表，例如 UPDATE、DELETE、MERGE、CREATE TABLE、CREATE SEQUENCE、DROP TABLE、TRUNCATE、GRANT、COMMIT/事务语句以及一个复杂章节。

验收：

- 每个章节对应一个稳定任务和一个Factor Package；
- 任务信封SHA-256、行数与package一致；
- 统计首轮门禁通过率、重试次数、open question和人工抽检错误率；
- 发现的模型缺口先集中评审，不让单个AI私自修改Schema；
- 10个任务完成后再决定是否扩大批量。
- 失败或高风险章节进入 `needs_review`/`blocked`，不阻断其他章节完成。

## 阶段C：批次抽取已覆盖 general SQL，质量缺口继续处置

已按对象家族完成 224 个 general SQL 章节包的绑定与原文审计，见 [剩余129包交付结果](REMAINING_129_EXTRACTION_RESULT.md)。这不是整本 PDF 所有正文或所有 SQL 特性的生成与行为闭环。继续按下列门禁处理有限生成域、待审核语义及运行时契约，不再把增加文件数作为完成指标。

验收：

- 文档总目录与语料任务清单可以取差集；
- 跨包 confirmed Fact 与 Fixture 依赖形成无环 DAG，队列按拓扑推进；上游章节
  或包哈希变化只把依赖闭包内的下游任务标为 stale；
- 相同命令的general、M/B兼容模式彼此隔离；
- 全库严格加载和全局ID检查持续通过；
- 失败原因可以归类为原文问题、抽取问题、模型缺口或生成器缺陷；
- 人工抽检达到团队设定的质量阈值后才扩容。

## 阶段D：V1数据库执行

范围：把V1 fixture、manifest Oracle和scenario接入执行器。

验收：

- fixture setup失败不能满足目标负向用例；
- teardown在成功和失败路径都可恢复；
- 负向用例匹配目标SQLSTATE/错误类别，而非任意错误；
- planned scenario能记录真实执行状态；
- 权限、多会话和生命周期场景使用隔离环境；
- 静态闭环与行为闭环仍分开报告。

## 阶段E：非SQL命令参考

数据类型、函数、操作符、GUC和系统目录不应强行套用单条SQL命令Factor。先分别确定输入、事实类型和Oracle，再建立专用Schema或共享能力包。

在此之前，相关内容只能登记为任务库存或未来需求，不能计入SQL Factor覆盖率。
