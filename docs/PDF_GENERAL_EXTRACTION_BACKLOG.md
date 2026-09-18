# PDF 通用 SQL 抽取进度与剩余质量工作

本次对账依据冻结本地 PDF：GaussDB V2.0-10.0.0 centralized，文档版本 01，2026-04-30。
范围为 **224 个 general SQL 章节**，不是旧版 226 因子，也不是 PDF 全部函数、数据类型、GUC 和系统目录。

| 状态 | 结果 | 含义 |
| --- | ---: | --- |
| 正文已拆分、包已绑定 | 224 / 224 | 章节、父 PDF 和包内来源哈希一致 |
| 原文账本审计通过 | 224 / 224 | 单元处置及事实消费通过，不等于语义全域验证 |
| 尚未建包 | 0 | 本轮剩余 129 包均已落盘 |
| 有有限 SQL 清单的包 | 168 / 224 | 其余包不计为 SQL 生成通过 |
| 全库候选用例 | 3766 | 全局 case ID 唯一；519 个 manifest |
| 全本队列 static_complete | 0 | 不把来源完成或部分生成冒充完整静态验收 |
| 本轮数据库执行 | 0 | planned scenario 与运行时 Oracle 未执行 |

本次基线 95 包 + 第七至十一批 129 包 = 224 包。新增的 129 包中，73 包有 781 条有限候选；56 包无普通清单，其中 6 包有文档不支持证据，48 包待工具或运行时契约，2 包待内部回调契约。

全量回归 **353/353** 通过。包级审计的 static_coverage_complete 为 9，其中包含 6 个不支持功能的证据包；它不等于 9 个 SQL 命令通过数据库验证，也不等于全本队列完成。

## 本地事实源

- 最终汇总：[剩余 129 包交付结果](REMAINING_129_EXTRACTION_RESULT.md)。
- 逐包机器对账：`work/doc2spec/remaining_129_completion.json`。
- 章节正文与目录：`work/doc2spec/full_general_corpus/catalog.json` 及 `general/`。
- 全本队列：`work/doc2spec/full_general_queue.json`（224 个 needs_review）。
- 可重算目录报告：`work/doc2spec/full_general_coverage.json`。
- [第七批](BATCH_07_EXTRACTION_PROGRESS.md)、[第八批](BATCH_08_EXTRACTION_PROGRESS.md)、[第九批](BATCH_09_EXTRACTION_PROGRESS.md)、[第十批](BATCH_10_EXTRACTION_PROGRESS.md)、[第十一批](BATCH_11_EXTRACTION_PROGRESS.md)。

```bash
python3 scripts/manage_extraction_queue.py --state work/doc2spec/full_general_queue.json summary
python3 scripts/audit_pdf_catalog_coverage.py --source-catalog work/doc2spec/full_general_corpus/catalog.json --spec-root specs --queue work/doc2spec/full_general_queue.json --output work/doc2spec/full_general_coverage.json
```

## 2026-09-17 质量增量

[DROP FOREIGN TABLE CASCADE](PDF_QUALITY_BATCH_20260917.md) 关闭该包最后一个值域缺口：
有限候选从 4 条增至 6 条，`generation_model_complete` 从 false 变为 true。
该代表仍使用无下游依赖的 fresh log_fdw 生命周期，不证明依赖视图/索引级联行为；
dependencies 与 runtime feature gap 继续保留。

[CREATE INDEX ACTIVE_PAGES](PDF_QUALITY_BATCH_20260917_ACTIVE_PAGES.md) 关闭
`ci_active_pages_manual` 值域缺口：create_index 候选从 345 条增至 346 条。
该值仍是 syntax-only 且带 `syntax_only_not_recommended` 门，不证明统计更新或执行效果；
`ci_feature_active_pages_execution_profile` 继续保留。

[CREATE RESOURCE POOL IO_PRIORITY](PDF_QUALITY_BATCH_20260917_IO_PRIORITY.md) 覆盖
Low/Medium/High/None 四个字面量，并加入 `complex_jobs_only` 环境门；
create_resource_pool 候选从 11 条增至 15 条。阈值冲突、IO_LIMITS 数值域和
MAX_DOP 集中式支持缺口继续保留。

[ALTER RESOURCE POOL IO_PRIORITY](PDF_QUALITY_BATCH_20260917_ALTER_IO_PRIORITY.md) 覆盖
ALTER分支的Low/Medium/High/None四个字面量，候选从6条增至10条；
90%阈值、多租冲突和MAX_DOP缺口继续保留。

[ALTER RESOURCE POOL IO_LIMITS](PDF_QUALITY_BATCH_20260917_IO_LIMITS.md) 覆盖
0与2147483647两个边界代表，候选从10条增至12条；不宣称全整数域或限流行为。
[CREATE RESOURCE POOL MEMORY_LIMIT](PDF_QUALITY_BATCH_20260917_MEMORY_LIMITS.md) 覆盖
1KB、1MB与2047GB三个代表，候选从15条增至17条；不宣称内存限额或运行时优先级行为。
[ALTER RESOURCE POOL MEMORY_LIMIT](PDF_QUALITY_BATCH_20260917_ALTER_MEMORY_LIMITS.md) 覆盖
1KB、1MB与2047GB三个standalone代表，候选从12条增至15条；多租冲突与MAX_DOP缺口继续保留。
[ALTER RESOURCE POOL ACTIVE_STATEMENTS](PDF_QUALITY_BATCH_20260917_ACTIVE_STATEMENTS.md) 覆盖
-1、0、1与2147483647四个代表，候选从15条增至18条；不宣称并发控制行为。
[COMMENT外部对象](PDF_QUALITY_BATCH_20260918_COMMENT_FDW.md) 为FOREIGN TABLE与SERVER
增加真实log_fdw生命周期和四类文本交叉，comment候选从52条增至60条；
FDW数据读取、validator和目录Oracle仍待校准。

[COMMENT DOMAIN](PDF_QUALITY_BATCH_20260918_COMMENT_DOMAIN.md) 为实际CHECK DOMAIN
增加COMMENT目标与四类文本交叉，comment候选从60条增至64条；domain转换、约束和目录Oracle
仍待校准。

[COMMENT文本域闭合](PDF_QUALITY_BATCH_20260918_COMMENT_TEXT_ALL.md) 将四类注释文本
从representative升级为all，comment feature gap从33降至32；目录Oracle和对象行为仍待数据库校准。
[COMMENT OPERATOR](PDF_QUALITY_BATCH_20260918_COMMENT_OPERATOR.md) 为实际双目
INTEGER操作符增加COMMENT目标与四类文本交叉，comment候选从64条增至68条；
其他arity、operator class/family和目录Oracle仍待校准。当前全库为850个manifest、
5,332条候选，generation model complete仍为256/317。

[COMMENT TEXT SEARCH CONFIGURATION](PDF_QUALITY_BATCH_20260918_COMMENT_TSCONFIG.md) 为
实际default解析器配置增加COMMENT目标与四类文本交叉，comment候选从84条增至88条；
分词、映射和目录Oracle仍待校准。当前全库为855个manifest、5,352条候选，
generation model complete仍为256/317。

[COMMENT ROLE](PDF_QUALITY_BATCH_20260918_COMMENT_ROLE.md) 为实际NOLOG且PASSWORD DISABLE
的独占角色增加COMMENT目标与四类文本交叉，comment候选从80条增至84条；
角色权限行为和目录Oracle仍待校准。当前全库为854个manifest、5,348条候选，
generation model complete仍为256/317。

[COMMENT TABLE/COLUMN域闭合](PDF_QUALITY_BATCH_20260918_COMMENT_TABLE_COLUMN_ALL.md) 将
TABLE与两个COLUMN目标从representative升级为all，comment feature gap降至31；
其他对象类型和目录Oracle仍待校准。当前全库为853个manifest、5,344条候选，
generation model complete仍为256/317。

[COMMENT TEXT SEARCH DICTIONARY](PDF_QUALITY_BATCH_20260918_COMMENT_TSDICTIONARY.md) 为
实际Simple词典增加COMMENT目标与四类文本交叉，comment候选从76条增至80条；
词典分词行为和目录Oracle仍待校准。当前全库为853个manifest、5,344条候选，
generation model complete仍为256/317。

[COMMENT CAST](PDF_QUALITY_BATCH_20260918_COMMENT_CAST.md) 为实际函数转换CAST
增加COMMENT目标与四类文本交叉，comment候选从68条增至72条；转换行为和目录Oracle
仍待校准。[COMMENT TRIGGER](PDF_QUALITY_BATCH_20260918_COMMENT_TRIGGER.md) 为实际普通表上的
BEFORE INSERT触发器增加COMMENT目标与四类文本交叉，comment候选从72条增至76条；
触发行为和目录Oracle仍待校准。当前全库为852个manifest、5,340条候选，
generation model complete仍为256/317。

## 下一阶段：补质量缺口，不再补空目录

1. 按 feature gap 和 open question 选择可独立闭合的有限生成域，保留原文分母。
2. 为文件传输、外部目录、模型训练、密钥服务及跨会话功能定义真实运行时契约；未具备条件时保留 pending，不造占位 SQL。
3. 在明确授权的隔离数据库中校准 fixture、目标错误与行为 Oracle，分别记录 setup/test/teardown 结果。
4. 验证快照绑定源码、章节、包和依赖哈希，发生变化时重新核验。
5. 非 general SQL 正文另行分类建模，不据本报告宣称整本 PDF 已完成。

本轮未执行数据库、提交或推送。
