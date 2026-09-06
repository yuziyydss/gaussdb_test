# 剩余 129 个 PDF 因子包交付结果

## 结论与范围

本次将 **95 个已有包补齐至 224 个 general SQL 章节包**，新增 129 包全部通过章节哈希、原文账本与事实消费审计。依据是本地 GaussDB V2.0-10.0.0 centralized PDF，文档版本 01（2026-04-30）。

**完成的是本批原文抽取及有限生成交付，不是全特性 SQL 或数据库行为闭环。** 没有普通清单的包、原文歧义、needs_profile 和 planned scenario 均继续留账；全部新增包保持 needs_review。

## 分批结果

| 批次 | 新包 | 有有限 SQL 的包 | 候选用例 |
| --- | ---: | ---: | ---: |
| 第七批：类型、扩展与外部对象 | 26 | 21 | 130 |
| 第八批：数据库与工具命令 | 25 | 4 | 56 |
| 第九批：身份、权限与安全标签 | 24 | 21 | 216 |
| 第十批：策略、事件、程序包与外部资源 | 29 | 16 | 182 |
| 第十一批：分区、数据流、模型与恢复 | 25 | 11 | 197 |
| 合计 | **129** | **73** | **781** |

新增 171 个 manifest。56 个无普通 SQL 清单的包分为：

- 6 个文档明确不支持的证据包；
- 48 个待工具或运行时契约的包；
- 2 个待内部回调契约的包。

这 56 个包保留原文事实、限制、来源及待实施项，**不计作 SQL 生成通过**。不能把内部命令、文件输入、外部服务或跨库生命周期包装成假定可直接执行的 SQL。

## 验证证据

- 全量回归：**353/353**，1085.263 秒；日志 `work/doc2spec/batches/batch_11/tests_full.log`。
- 最终全库严格加载通过，所有 224 包的 source_extraction_complete 为 true。
- 新增 129 包与五批最终报告的包哈希一致；73 个有 SQL 的包逐 manifest 用例及组合报告与各批验证产物精确一致。
- 全库 168 包有普通清单，共 519 个 manifest、3766 个全局唯一 case ID；快照逐条包含对应 ID 和 SQL。
- SQL 文本去重后 3738 条，存在 28 个跨因子同文组（例如别名语句）；不把 case ID 唯一误称为 SQL 文本全部不同。
- 224 个章节来源与父 PDF 哈希一致；目录差集为 0。
- 本轮没有数据库执行、提交或推送。

冻结 PDF SHA-256：

`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 如何看产物

- 包规格：`specs/`，按类别与命令分目录。
- SQL 及生成报告：`generated/factor_packages/`。
- 完整机器对账：`work/doc2spec/remaining_129_completion.json`（224 行，含 129 包所属批次及限制）。
- 各批证据：`work/doc2spec/batches/batch_07` 至 `batch_11/final_task_results.json`。
- [第七批](BATCH_07_EXTRACTION_PROGRESS.md)、[第八批](BATCH_08_EXTRACTION_PROGRESS.md)、[第九批](BATCH_09_EXTRACTION_PROGRESS.md)、[第十批](BATCH_10_EXTRACTION_PROGRESS.md)、[第十一批](BATCH_11_EXTRACTION_PROGRESS.md)。
- [目录进度与质量待办](PDF_GENERAL_EXTRACTION_BACKLOG.md)。

`generation_report.json.factor_coverage` 只包含有 manifest 的 168 包。查看全部 224 包的原文审计应使用本次完整机器对账或全注册表审计，不能把报告中缺少的 56 包误判为原文未抽取。

## 尚未完成

原文审计通过仅证明规定的来源处置、原子性及消费检查通过，不能替代人工语义复核。Pairwise 只覆盖已声明有限域的可行二元交互，不能证明全部 SQL 语法域、三阶以上交互或实际可执行性。

全库包级 static_coverage_complete 为 9（含 6 个不支持证据包），behavior_coverage_complete 为 0；全本队列 static_complete 为 0。剩余生成域、跨模式环境、文件/服务运行时、目标错误校准和行为场景仍需后续实现，不能用 353 个软件回归通过替代数据库测试。

下一阶段应按这些真实缺口推进有限域完善和隔离环境验证，而不是继续为 general SQL 补目录或批量改状态。函数、类型、GUC、系统目录等非命令正文不在本次 224 章分母内。
