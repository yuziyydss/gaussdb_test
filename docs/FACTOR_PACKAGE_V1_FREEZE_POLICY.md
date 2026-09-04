# Factor Package V1 冻结与批次推进规则

本文档固定 Factor Package V1 进入批量抽取后的变更边界。五个首批因子是框架验收样本，不是必须在扩批前完成所有数据库行为的“精修项目”。

## 1. 冻结范围

第二批开始后，下列公共契约按 V1 冻结：

- `factor/source/syntax/manifest/matrix/fixture/scenario` 七类产物的职责边界；
- `schema_version: 1` 下已发布字段的名称和语义；
- `FactorPackageRegistry` 的严格加载、引用闭合与错误原则；
- `generate_with_report()` 输出的 case、case ID、消费维度、Pairwise 报告和环境门禁语义；
- source/generation/static/behavior 四层结论的口径；
- PDF 父文档哈希、章节哈希、抽取规则版本和任务信封的对账契约。

“冻结”不表示代码不能修 bug，也不表示各因子的值域、Fixture、Scenario 或 Oracle 不能迭代。它表示不再因为单个章节的特例随意改变全局 Schema 和生成接口。

## 2. 允许的 V1 内变更

- 新增因子包及其文档事实、值、规则和能力 profile；
- 关闭已登记的 open question、feature gap、Oracle 或 scenario 缺口；
- 不改变公共契约的生成器 bug 修复和性能优化；
- 增加更严格但不改写旧字段语义的 lint/审计项；
- 增加可选字段，前提是旧 V1 包继续可加载且有默认安全语义。

## 3. 需要版本化评审的变更

出现以下情况时，不允许某个 worker 直接修改 core：

- 删除或重命名 V1 字段；
- 改变已有字段、覆盖结论或 Oracle 的语义；
- 改变 case ID 或生成报告的稳定格式；
- 将一个章节特例上升为所有因子的强制规则；
- 为了让当前任务变绿而降低严格加载、原子性、Pairwise 或 Oracle 门禁。

候选架构变更必须有至少两个章节的共性证据、迁移方案、回归测试和影响清单；不兼容变更进入新 Schema 版本。

## 4. 扩批门禁

开始第二批的前提是“框架可信”，而不是“五个样本数据库行为 100%”。需要同时满足：

1. PDF 父文档和章节可确定性重新抽取并对账；
2. 严格 lint、全局 ID/引用检查和完整回归通过；
3. 生成后可证明所有已建模可行 pair 覆盖，case ID/SQL 无重复；
4. 未建模值域、source atomicity、feature、环境、Oracle 和 scenario 缺口会显式使结论为 false/pending；
5. 高风险或无法自动表达的章节可进入 `needs_review`/`blocked` 队列，不阻断其他独立章节。

真实数据库行为、多会话、性能和 metadata Oracle 属于独立执行轨道，不是开始第二批的前置条件。

## 5. 批次节奏

1. 五个框架验收样本：校准公共模型和信任门禁；
2. 第二批约 10 章：覆盖简单 DDL、DCL、TCL、普通 DML 和一到两个复杂语法；
3. 稳定后每批 20～30 章：按章节独立通过/进入人工队列，不使用“全批最慢任务”作为完成条件；
4. 通用 SQL 目录完成后，再单独处理 M/B 兼容模式和非 SQL 参考类型。

每批都必须输出首轮通过率、重试率、`needs_review`/`blocked` 数、source atomicity gap、feature gap、生成 case 数与人工抽检错误率。
