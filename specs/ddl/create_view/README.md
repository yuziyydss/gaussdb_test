# CREATE VIEW Factor Package

本目录只建模 GaussDB 集中式版参考 `V2.0-10.0.0` 的 general 章节 `1.13.9.60 CREATE VIEW`。M-Compatibility 章节没有合并进本因子。

主来源：

- catalog：`intranet_corpus/catalog.json`
- 章节文本：`intranet_corpus/general/ddl/create_view.txt`
- document_id：`gaussdb_v2_0_10_0_0_centralized_reference_01`
- 父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`
- 抽取规则：`gaussdb-pdf-outline-v1`
- 章节 SHA-256：`e66079b4f289b10874a1e5fa5abdfc5fdc8b1d026ebdfb05e3c593d64f7eedc5`
- outline：`1 SQL参考 > 1.13 SQL语法 > 1.13.9 C > 1.13.9.60 CREATE VIEW`
- 物理页：1636–1642；印刷页：1587–1593
- 起点：物理页 1636，`pdf_top=756.8504`；终点：物理页 1642，`pdf_top=262.6586`，end-exclusive

文件职责：

- `create_view.factor.yaml`：来源绑定、维度、事实、硬规则与待验证问题。
- `create_view.source.yaml`：406 行章节文本的逐行处置与 fact 映射账本。
- `create_view.syntax.yaml`：CREATE VIEW 第 22–25 行主产生式和槽位顺序。
- `matrices/query_capabilities.matrix.yaml`：本章足以支撑的查询候选 profile 与 16 类不可更新特性台账。
- `fixtures/source_two_ints.fixture.yaml`：静态候选 SQL 共用的两列整数源表能力。
- `manifests/*.manifest.yaml`：按目的拆分的静态生成清单。
- `scenarios/*.scenario.yaml`：需要数据库状态、会话、权限或后续 DML 的计划场景。

来源账本共 116 个 unit，406/406 行已登记，其中 7 行是保留的 PDF 页码标记。对 PDF 同一行承载多个事实的 25 个重叠行已用 `overlap_group` 和理由显式登记；16 类不可更新特征、CHECK 限制和 3 个缺失子语法已逐项拆开，当前原子性审计无缺口，因此本章的 source extraction 层已闭环。外部 V8 网页与旧附件不再作为主依据或补充依据。

当前静态模型包含 46 条 confirmed fact、11 条 open question、7 个 manifest 和 12 个 planned scenario。可由本章可靠实例化的 13 类不可更新查询特性保留 profile；UNPIVOT、START WITH CONNECT BY 与闪回仅在本章中被点名，没有完整 SELECT 子语法，因此标为 `needs_profile`，不会生成候选 SQL。文档普通示例和 security_barrier 安全目的由独立 scenario 承接，不能再由一个泛化查询 profile 冒充行为覆盖。对应的旧 V8 profile 和 Ustore 闪回 fixture 已移除。

静态生成现为 122 条候选 SQL（54 条正向、68 条负向）；已建模值域与可行 Pair 完整，所以 `generation_model_complete=true`。source extraction 已闭环，但 feature domain 仍为 13/16，另有 11 个未决事实、3 个未校准错误 Oracle 和 12 个 planned scenario，因此 static/behavior 仍为 false，`--fail-on-gaps` 应诚实返回非零。这些候选不能表述为已被 GaussDB 实机接受。
