# 剩余生成模型缺口处置清单（2026-09-20）

当前308个有manifest因子包中，303个满足 `generation_model_complete`，5个仍不满足。
本清单只说明当前为什么不能继续补普通正向候选；不表示这些功能都不支持。

| 因子包 | 阻断类别 | 当前原因 | 下一步动作 |
|---|---|---|---|
| `alter_resource_pool` | 资源池支持冲突 | MAX_DOP在DDL参数说明中列出，但正文称集中式不适用；多租和阈值冲突未闭合。 | 取得集中式/扩容支持契约。 |
| `alter_table` | 复杂结构与运行时Profile | B兼容、外表、TDE、ILM、COLVIEW等目标/动作依赖大量fixture。 | 按目标形态拆分profile。 |
| `create_foreign_table` | file_fdw BINARY/FIXED合同 | BINARY字节合同缺失；FIXED要求FORMATTER且全列。 | 定义字节/定长布局和文件身份。 |
| `create_index` | TDE与索引域合同 | TDE索引依赖TDE环境与密钥状态；键列、存储、子分区域有缺口。 | 建立TDE profile和索引域闭环。 |
| `delete` | 游标与目标Profile | WHERE CURRENT OF需游标身份；DBLink、分区、计划提示等目标未闭合。 | 建立游标和目标profile。 |
| `update` | 游标赋值与目标Profile | WHERE CURRENT OF需游标身份；生成列、规则表、分区、DBLink等未闭合。 | 建立游标、生成列和目标fixture。 |

机器可读版本见
[GENERATION_MODEL_REMAINING_20260920.json](GENERATION_MODEL_REMAINING_20260920.json)。
`scripts/generate_factor_package_sql.py` 会校验该JSON与当前有manifest且
`generation_model_complete=false` 的包集合完全一致；新增或关闭缺口时必须同步更新处置清单。

Web与API也已接入同一份处置数据：

- `/coverage` 页面显示“生成模型剩余缺口”表；
- `/api/coverage/summary` 返回 `generation_model_gaps`；
- `/api/coverage/export-md` 导出处置表；
- 因子详情页显示当前生成模型阻断原因和下一步动作。
