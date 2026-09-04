# ALTER TABLE Factor Package V1

该目录是 ALTER TABLE 的单一规格入口。产品事实只来自 `intranet_corpus/general/ddl/alter_table.txt`，其父文档为 GaussDB V2.0-10.0.0《GaussDB Kernel 参考》文档版本 01；稳定章节由 `intranet_corpus/catalog.json` 中完整书签路径和页内坐标确定。旧 Factor Package、网页与模型记忆只可用于发现差异，不能补写产品规则。

## 当前结果

- PDF 稳定文本：1636 / 1636 行已登记，185 / 185 个 Source Unit 均有处置；更严格的复合枚举检查仍识别出 11 个 atomicity gap。
- 事实：56 条 confirmed，19 条 open question；没有使用当前 catalog 之外的补充来源。
- 结构：1 个多顶层、有限展开的结构化 AST、2 个能力 matrix、4 个 fixture。
- 生成：16 个 manifest，共 277 条静态 SQL；266 条正向，11 条目标负向。
- 覆盖：所有 manifest 的可行 Pair 100% 覆盖；73 / 74 个 valid value 实际进入渲染，未选的分区 SET TABLESPACE 负向值作为显式缺口保留；目标语法形式仅按 `representative` 声明，继承作用域不计入行为覆盖。
- 行为：22 个 scenario 已规划；ONLINE 生效、分区表 SET TABLESPACE 目标错误和星号/ONLY 继承作用域都未被静态 SQL 成功替代。本轮明确不连接数据库。

## 关键建模决定

1. 通用 action、表/列/约束重命名、SET SCHEMA、ADD/MODIFY 多列和 GSIWAITALL 分别使用顶层 AST 分支。
2. `action [, ...]`、`ADD (...)` 和 `MODIFY (...)` 使用 AST `repeat` 与有限 `properties.items`，不把 PDF 的 BNF 或逗号列表伪装成一条 SQL 字符串。
3. `table_name`、`table_name*`、`ONLY table_name`、`ONLY (table_name)` 使用目标 choice，而不是字符串后处理。
4. ONLINE 不支持某形态时，PDF 规定 NOTICE 后降级离线；ONLINE 清单带显式环境门禁且 `scope: syntax_only`，只有 planned 多会话场景才能验证是否真正在线。
5. `SET NOT NULL` 使用初始可空但种子数据无 NULL 的 `required_later` 列，使状态迁移可观察；不再对已是 NOT NULL 的 `amount` 列执行无效重复操作。
6. 分区表 SET TABLESPACE 负向用例需要真实的第二表空间；在安全 Fixture 完成前只保留 planned scenario，不用 `pg_default -> pg_default` 冒充目标错误。
7. `table_name`、星号和两种 ONLY 值只证明语法代表被渲染；父子表作用域由独立 planned scenario 承接。
5. B/A/M 兼容模式、在线故障、TDE、ILM、COLVIEW、内部扩缩容、外表、加密列和子分区在缺少环境或跨章证据时保持 conditional/open question/needs_profile。
6. PDF 没有给出 SQLSTATE 或稳定错误文本，因此 8 个负向 manifest 全部使用 `oracle_status: needs_verification`，不使用宽泛正则；`nextval()` 用例仍预建序列，避免非目标错误。

## 尚未闭环

目前 documented feature 中仍明确保留 ONLINE、继承作用域、A/B/M 兼容 variant、Owner/表空间、触发器、内部扩缩容、TDE/KMS、ILM、COLVIEW/HTAP、外键、生成列、加密列、外表和子分区等缺口。另有已知值尚未进入合适的环境绑定 manifest，未校准的目标错误 Oracle 仍保持 pending。

因此当前结论仍是：`source_extraction_complete=false`、`generation_model_complete=false`、`static_coverage_complete=false`、`behavior_coverage_complete=false`。其中 11 个 source atomicity gap 保持原样，本轮没有为追求指标而伪闭环；277 条 SQL 只通过静态渲染、引用、规则和 Pairwise 审计，不能称为已在 GaussDB 可执行或行为已验证。
