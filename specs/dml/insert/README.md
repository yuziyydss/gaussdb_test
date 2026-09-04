# INSERT Factor Package（V10 文档重建）

本目录只以 `intranet_corpus/general/dml/insert.txt` 及其 `catalog.json` 章节记录为主事实源。旧规格只用于发现候选项，任何未被本章原文支持的 confirmed 断言均不保留。章节边界止于 INSERT 的第 918 行；下一章 `INSERT ALL` 不属于本因子。

来源契约：

- 产品版本：`V2.0-10.0.0`
- document_id：`gaussdb_v2_0_10_0_0_centralized_reference_01`
- source_relpath：`general/dml/insert.txt`
- 章节 SHA-256：`5383f2eca79ecbe64ce3e880c8e3a2a39178a6bd93ca328401740bf36c16fae5`
- 父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`
- 抽取规则：`gaussdb-pdf-outline-v1`
- catalog：`intranet_corpus/catalog.json`（主绑定同时保存父 PDF、抽取规则和 document_id/source_relpath/chapter_sha256）
- 目录路径：`1 SQL参考 > 1.13 SQL语法 > 1.13.14 I > 1.13.14.7 INSERT`
- 物理页：1737–1752；印刷页：1688–1703；结束 destination 为下一章第 1753 物理页的精确截断点（exclusive）。

## 当前职责

- `insert.source.yaml`：245 个 unit 连续处置 918/918 行；页标记、空行和标题也明确标为 `out_of_scope`，没有 ignored 或 unmapped。原复合的触发器路径、视图示例和性能约束已拆分为独立义务；封闭枚举值域附有具体原子性理由，atomicity gap 为 0。
- `insert.factor.yaml`：保存文档事实、条件值、跨维规则与目标/输入结构契约；主来源绑定章节 SHA 和 catalog ref。
- `insert.syntax.yaml`：只装配顶层语句顺序；目标、输入和冲突子文法由 profile/value 完整渲染。
- `matrices/`：枚举可静态生成的普通表、别名、视图、子查询、DEFAULT/VALUES/VALUE/query/SELECT CTE；视图、子查询和通用 query 只计代表性覆盖，不冒充完整语义矩阵。
- `manifests/`：14 个清单生成 98 条静态 SQL（87 条正向、11 条负向）；所有适用的可行 Pair 完整，case ID/SQL 无重复。多 CTE、MATERIALIZED/NOT MATERIALIZED、VALUES 和 DML CTE 以 `syntax_only` 覆盖，不将未执行的命令标签、计划或数据副作用冒充为已验证。PG ON CONFLICT 与 B/5.7/s1 IGNORE 的目标负向清单已带机器可判定环境门禁；另外 4 个 PG conditional 值尚未进入清单，所以 generation 仍为 false。
- `fixtures/`：普通目标、唯一目标、查询源、单表视图/子查询和分区目标具备声明式生命周期；二级分区及复杂对象能力继续保持缺口。
- `scenarios/`：12 个行为/环境场景均为 `planned`，包括权限、生成列与截断、IGNORE、CTE、视图/子查询、PG 冲突、触发器、分区、RETURNING、性能、DBLINK 和文档示例逐例回放。

## 如实保留的缺口

当前 source 抽取层已闭环；generation/static/behavior 三项仍为 false。具体缺口为：4 个未选择的 PG conditional 值、10 个 feature domain gap（含 3 项明确标记的代表性覆盖）、7 个 open question、8 个未校准错误 Oracle 和 12 个 planned scenario。缺口集中在 `plan_hint`、DATABASE LINK、保留键定义、二级分区、复杂字段、B/5.7/s1 IGNORE、PG ON CONFLICT，以及 CTE 命令标签/物化计划/数据副作用的实际回放。

校验命令：

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py --factor insert
python3 scripts/audit_factor_coverage_v1.py --factor insert --fail-on-gaps
```

最后一条在上述真实静态缺口消除前应返回非零；这表示覆盖缺口仍在，不表示审计脚本异常。
