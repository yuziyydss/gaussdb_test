# 剩余无manifest因子包阻断清单（2026-09-20）

当前317个注册包中，309个有manifest，8个没有。无manifest不是“不支持”的统一结论；
本清单只说明当前为什么不能生成普通正向清单。

| 阻断类别 | 因子包 | 当前原因 |
|---|---|---|
| 文档不支持 | `alter_language` | 当前集中式PDF明确不支持，未提供可执行产生式。 |
| 双会话运行时绑定 | `alter_system_kill_session` | SID/SERIAL不能写死，需要双会话身份、时效与误杀防护。 |
| 内部实现与未知编码域 | `create_conversion` | 内部函数实现未闭合；UTF8/LATIN1仍是unknown候选，不能转正向。 |
| 文档不支持 | `create_global_index` | 当前集中式形态明确不支持，不能与CREATE INDEX GLOBAL混用。 |
| 文档不支持 | `create_language` | 当前集中式PDF明确不支持，未提供可执行产生式。 |
| 文档不支持 | `drop_language` | 当前集中式PDF明确不支持，未提供可执行产生式。 |
| 文档不支持 | `lock_buckets` | 当前版本明确不支持，不能把标题当SQL。 |
| 文档不支持 | `mark_buckets` | 当前版本明确不支持，不能把标题当SQL。 |

## 机器可审计版本

结构化数据见 [NO_MANIFEST_REMAINING_20260920.json](NO_MANIFEST_REMAINING_20260920.json)。
`scripts/generate_factor_package_sql.py` 会加载该文件，并把
`blocking_category`、`blocking_reason` 和 `next_action` 写入
`generated/factor_packages/generation_report.json` 的
`package_inventory.without_manifest`。若后续新增或关闭manifest导致集合漂移，生成报告会直接失败，要求先更新处置清单。

Web与API也已接入同一份处置数据：

- `/coverage` 页面显示“无普通manifest处置”表；
- `/api/coverage/summary` 返回 `without_manifest` 与分类统计；
- `/api/coverage/export-md` 导出处置表；
- 因子详情页对无manifest包显示当前阻断原因和下一步动作。

## 处理原则

1. 不把章节标题、示例常量或占位运行时值伪装成可执行SQL。
2. 不把“无manifest”改写成“不支持”；二者必须分开。
3. 文档不支持的包保留原文证据与planned scenario，等待产品形态变化。
4. 运行时绑定包先实现身份、授权、资产和恢复契约，再考虑清单。
5. 任何新增manifest仍需通过严格加载、生成、覆盖审计和静态回归。
