# 文档索引

## 当前权威文档

| 文档 | 用途 |
|---|---|
| [Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md) | V1文件类型、字段、引用和验收契约 |
| [Factor Package V1 冻结与批次推进规则](FACTOR_PACKAGE_V1_FREEZE_POLICY.md) | 冻结范围、版本化变更门禁和 10 章/20～30 章批次节奏 |
| [Factor Package V1.1 变更提案登记](FACTOR_PACKAGE_V1_1_CHANGE_PROPOSALS.md) | 第二批重复暴露的公共模型缺口、兼容方向和实现门禁 |
| [第二批 PDF Doc2Spec 抽取计划](BATCH_02_EXTRACTION_PLAN.md) | 第二批 10 章的固定选择、独立队列、命令与验收口径 |
| [第二批 PDF Doc2Spec 验收结果](BATCH_02_RESULT.md) | 第二批来源对账、生成指标、人工复核缺陷、诚实缺口与扩批结论 |
| [12 章跨因子依赖验证](CROSS_CHAPTER_DEPENDENCY_RESULT.md) | 真实引用、拓扑认领、Fixture SQL 顺序及隔离副本中的失效传播实验 |
| [Doc2Spec Extraction Rules V1](DOC2SPEC_EXTRACTION_RULES_V1.md) | 从产品原文抽取 source/factor/syntax/manifest 等文件的规则 |
| [PDF 到 Factor Package 权威流程](PDF_DOC2SPEC_PIPELINE.md) | 整本PDF目录、精确拆章、来源证据和五章校准门禁 |
| [内网批量 Doc2Spec 运行手册](INTRANET_AI_BATCH_EXTRACTION.md) | 文档不能外传时的语料切片、任务队列、AI协作和批量节奏 |
| [当前系统架构](ARCHITECTURE.md) | V1数据流、模块职责、覆盖结论和Legacy边界 |
| [路线图](ROADMAP.md) | 当前完成项、已知缺口和下一验收阶段 |

项目级快速开始见根目录 [README](../README.md)，内网 AI 的最短入口见 [INTRANET_AI_INSTRUCTIONS](../INTRANET_AI_INSTRUCTIONS.md)。

## Legacy 与历史资料

以下文件保留用于理解和维护旧运行时，不再定义新的抽取格式：

| 文档 | 状态 |
|---|---|
| [Legacy V0三文件规格指南](SPEC_SPECIFICATION_GUIDE.md) | 仅维护 `grammars/matrices/manifests` |
| [Legacy V0 Doc2Spec指南](DOC2SPEC_EXTRACTION_GUIDE.md) | 旧提示词与旧输出目录 |
| [Legacy V0单文件因子指南](FACTOR_GUIDE.md) | 仅维护 `factors/` |
| [架构演进记录](EVOLUTION_PLAN.md) | 历史决策与当前落地对照 |
| [海量文档与GUC边界说明](LARGE_DOC_EXTRACTION_AND_GUC_GUIDE.md) | 当前入口和GUC未来建模边界 |

如当前权威文档与 Legacy 文档冲突，以 Factor Package Schema V1 和实际 Pydantic模型为准。
