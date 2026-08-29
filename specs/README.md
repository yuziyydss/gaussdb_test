# Factor Packages V1

`specs/` 是新一代规格的唯一写入位置。每条 SQL 语句使用一个自包含目录，目录内以引用连接 source ledger、factor、syntax、manifest、matrix、fixture 和 scenario。

可生成 SQL 的最小因子包需要 `source ledger + factor + syntax + manifest`；matrix、fixture、scenario 仅在存在复杂能力、对象依赖或多步骤行为时添加。旧架构中的 grammar 和 manifest 没有被取消，而是改为与因子同目录管理。

规范：

- [Factor Package Schema V1](../docs/FACTOR_PACKAGE_SCHEMA_V1.md)
- [Doc2Spec Extraction Rules V1](../docs/DOC2SPEC_EXTRACTION_RULES_V1.md)
- [当前系统架构](../docs/ARCHITECTURE.md)
- [内网批量运行手册](../docs/INTRANET_AI_BATCH_EXTRACTION.md)

当前边界：

- 根目录中的 `factors/`、`grammars/`、`matrices/`、`manifests/` 是 Legacy V0，现有运行时仍可能使用。
- 新文档抽取只写入 `specs/<category>/<statement>/`。
- V1 严格加载器、静态生成器和 Web/API 已读取该目录；数据库执行器仍未接入 V1 fixture/scenario。
- 不要在 V0 与 V1 之间手工双写规则。迁移应由单独的校验与转换任务完成。
- 当前目录包含 5 个 factor、19 个 fixture、56 个 manifest、8 个 matrix、61 个 scenario、5 个 source ledger 和 5 个 syntax；这些是当前提交的基线，不代表产品文档全量覆盖。

静态检查：

```bash
python3 -B scripts/lint_factor_packages_v1.py
```

该检查不连接数据库，通过严格 Pydantic 模型和注册表验证嵌套未知字段、ID 唯一性、引用闭合、syntax 槽位、manifest bindings、规则 DSL、confirmed rule 证据和 negative manifest 目标规则。

因子级全局覆盖审计：

```bash
python3 -B scripts/audit_factor_coverage_v1.py --factor create_view
```

审计同时检查原文单元处置、fact 溯源与消费、有效值选择、硬规则正负证据、manifest/Pairwise、文档 feature 和 scenario，不用 SQL 条数代替“全覆盖”。

生成确定性 SQL 快照与覆盖报告：

```bash
python3 -B scripts/generate_factor_package_sql.py --factor create_view
```
