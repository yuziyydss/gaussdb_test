# INSERT Factor Package 适配验证

本目录使用 Factor Package Schema V1 抽取用户提供的 276 行 GaussDB `INSERT` 产品文档，用它验证现有架构能否承载 DML 写入语句的目标列、输入行、查询输出、冲突处理和环境行为。

来源：

- 文档标题：`INSERT`
- 产品版本：正文未显式标注，记为 `unknown`
- 原文 SHA-256：`31b8470b1c3e84a4849471102344dd74d0fb2417b8800af5bbaa7104d749eaa4`

## 当前静态结果

- 116 个 source unit 加 9 个空行登记了 276/276 行；全部完成 `atomic/grouped` 复核，原子性缺口为 0。
- 31 条 confirmed fact、1 条 inferred 结构事实和 2 条 open question；confirmed 非示例事实均有下游消费者。
- 目标和输入拆为两个 capability matrix；AST 使用 `choice + repeat + ref` 表达 DEFAULT VALUES、VALUES/VALUE、查询输入和 CTE。
- 生成器新增 `insert_input_contract`，在组合覆盖计算前校验显式/隐式目标列数、输入输出类型和 CTE 前置条件。
- 8 个 manifest 生成 45 条 SQL：40 条正向、5 条具有目标错误类别/消息 Oracle 的负向；所有可行 Pair 100% 覆盖，case ID 和 SQL 全局唯一。
- 5 个可执行 fixture 为普通目标表、唯一键目标表、查询源、分区目标以及视图/子查询目标生成 setup/seed/teardown。
- 9 个环境或行为 scenario 已登记但仍为 `planned`，未连接数据库执行。

审计结论：

- `source_extraction_complete=true`
- `generation_model_complete=true`
- `static_coverage_complete=false`
- `behavior_coverage_complete=false`

静态覆盖没有闭环的两个显式缺口是：原文没有给出具体可执行 `plan_hint`；DATABASE LINK 的目标语法依赖失效的外部章节。`IGNORE` 和 `ON CONFLICT` 的语法事实已保存，但由于需要 B 5.7/s1 或 PG 兼容数据库，目前保留为条件值并进入 planned scenario，不生成默认环境 success 用例。

生成结果位于 `generated/factor_packages/insert/`，全局报告位于 `generated/factor_packages/generation_report.json`，因子审计位于 `generated/factor_packages/insert/coverage_audit.json`。
