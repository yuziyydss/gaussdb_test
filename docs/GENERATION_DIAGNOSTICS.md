# 如何理解“为什么未完整”

进度诊断只解释既有审计结果，不增加SQL支持范围、不修改规格状态，也不把未知能力变成“不支持”。

## 在哪里看

- 因子详情 `/specs/factor/<factor_id>`：在“原文覆盖账本 / 因子级全局审计”中展开“为什么未完整”。
- 覆盖总览 `/coverage`：新增“生成模型诊断”列，同时分别统计待校准Oracle涉及的包数和清单数。
- JSON `/api/coverage/summary`：每包 `display_progress.generation_diagnostics` 与总览 `progress` 使用同一计算入口。
- Markdown `/api/coverage/export-md`：导出相同诊断口径。详细取值ID、规则与错误清单以JSON和详情页为准。

页面只复用当前审计数据，没有为每个诊断额外运行一遍SQL生成或全文审计。现有全库报告的冷启动成本仍存在，本次没有实现全库缓存或分页优化。

## 三类问题不要混在一起

| 层次 | 例子 | 不能推导什么 |
| --- | --- | --- |
| 候选生成 | 实际生成异常、缺少候选 | 无候选不等于产品不支持 |
| 生成模型 | 已声明取值缺覆盖、规则无对应目标、缺要求pair、重复输入/ID | 有SQL不等于完整模型；条件值不是直接补入正向的任务 |
| 静态覆盖及运行时 | 负向Oracle待校准、来源和场景缺口 | 未校准Oracle不是生成异常；单元测试或场景ready不是实机结果 |

例如CREATE/ALTER RESOURCE POOL的MAX_DOP值是`conditional`，原规格已经记录DDL与系统目录的集中式支持冲突。诊断显示“条件值尚未纳入”，并列出包级待审事实供查证；不会追加正向绑定，也不会宣布该参数不支持。

CREATE INDEX的条件取值缺口与负向Oracle待校准分开展示。即使某包的生成模型已满足，仍可能有未校准Oracle阻止静态覆盖闭合。

M SELECT已有同SQL、不同实际setup的COUNT对照。`duplicate_sql`是目标文本重叠事实，明确的空`duplicate_inputs`不能被诊断层重新当作重复输入阻断；旧报告没有这个区分字段时保留其保守重复检查，不猜前置相同或不同。

## API诊断字段

`generation_diagnostics`包括：

- `status`：`satisfied`、`gaps`、`no_cases`、`unavailable`或`inconsistent`。
- `declared_complete`：保留审计器原始生成模型结论。
- `blockers`：含稳定`code`、展示`label`、数量`count`和可定位的`items`。
- `unresolved_error_oracles`：单独列出待校准负向manifest，不计作生成模型阻断。
- `review_context_fact_refs`：包级未决事实，只供查证；不自动与每个值域缺口建立因果关系。
- `limits`：解释上述证据边界。

取值缺口按条件值未纳入、无效值缺负例、有效值缺正例、其他未分类缺口划分，每个取值只进入一个分组。规则、错误、ID和pair是不同类别，类别之间可能关联；不能把总数相加作为完成率。

诊断从现有证据解释原结论，再核对二者是否一致。字段不完整或解释与原结论矛盾时显示“无法核对”，不悄悄把原结论改成通过。该层不读取数据库运行收据，`runtime_verified`仍是`null`，表示未接入而非实机通过或实机失败。

## 本轮验证范围

初始9项新增测试真实失败，随后覆盖条件限制、取值分组、不改变原审计、零候选、缺字段/矛盾结论、同SQL不同前置和Oracle层级。另有真实全包审计与页面/API/导出一致性测试，并验证错误消息在HTML中自动转义。

最终7模块52项相关回归全部通过，进程收据481.169秒，无跳过或预期失败。独立核验本轮仅7个诊断/展示/测试输入变化，所有生成器、规格及生成产物哈希不变，817份manifest、5187条case保全。原9项RED日志未覆盖。

浏览器检查覆盖实际资源池、CREATE INDEX和无候选包三个详情片段及本地CSS；资源池诊断另检查390px手机布局。这是HTMX片段验证，不冒充完整壳页面/CDN导航验证。临时Web服务在检查后关闭。最终收据及生成快照保全证明见本地 `work/progress_diagnostics_20260910/acceptance.json`与`regression/receipt.json`；不把本次结果说成新增代码后的全217模块回归。

这次没有改Factor Package模型、审计判定、生成器、产品规格或SQL快照，没有数据库执行、Git提交推送或新的夜间调度。
