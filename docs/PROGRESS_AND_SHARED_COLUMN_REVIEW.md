# 进度口径与共享列契约评审

日期：2026-09-06。用户已要求落实分层展示、评审DEFAULT/视图契约、逐类推进无manifest包。该请求不包含数据库执行、Git发布或未经评审的公共Schema升级。

## 1. 展示口径（本次实现）

| 阶段 | 分子条件 | 不代表什么 |
| --- | --- | --- |
| 包已建 | Registry成功加载的包 | 不代表文档语义已穷尽 |
| 能生成候选 | 至少一条真实生成候选；异常另标部分生成 | 不代表全部分支或全部有效值已覆盖 |
| 静态覆盖满足 | 有候选、无生成异常，且现有静态审计条件满足 | 不代表实机成功；无用例不计通过 |
| 实机验证 | 必须接入匹配当前版本/输入/环境的实际运行和Oracle证据 | 不可从ready、behavior规格布尔值或单元测试推断 |

当前未接入实机证据读取器，API以null、页面以“未接入”表示，而不是凭空给出实机通过数0或绿色完成。来源账本、有限Pairwise和规格状态作为附属指标；零适用pair不能写成全部100%。

为兼容现有消费者，旧`conclusions`和`*_complete_count`保留且不改语义；新增`display_progress`和聚合`progress`供页面与导出使用。旧统计不能作为可执行覆盖率。首页不运行全库审计以获取卡片，避免增加首页负担；全库审计沿用现有质量总览入口。

## 2. 共享列契约评审结论

**后续状态：用户已批准继续最小内部实现，公共结构仍不变。** 首轮实现与验收边界见 [内部共享列契约](SHARED_COLUMN_CONTRACT.md)。以下保留实施前评审范围；应从实际DDL派生共享证据，不在每个INSERT/UPDATE模板中复制默认值和可写性规则。夜间评审材料见`work/overnight_2026_09_06/default_contract_review.md`与`remaining_review_plan.md`。

### 共同输入与产品证据

- INSERT：已建`fixture_insert_declared_defaults`，id DEFAULT 701、note DEFAULT 'declared'；正文L272–299说明省略列与DEFAULT，L16–17另有限制生成列。
- UPDATE：已建`fixture_update_declared_defaults`，note DEFAULT 'declared'、qty DEFAULT 7；正文L170–172说明被赋值列DEFAULT。未赋值列不能按INSERT缺省规则覆盖。
- INSERT视图：`fixture_insert_view_target`直接投影id/note并依赖真实基表；UPDATE视图：`fixture_update_view`直接投影id/note/qty。UPDATE正文L118–140与CREATE VIEW正文L94–113共同限制可更新目标和直接引用列。

行号定位当前冻结PDF的本地抽取正文，不替代source unit与fact引用。明确不改变父PDF或各包事实状态。

### 分层对象，不立即固定新YAML字段

1. **列事实**：名称、顺序、类型、nullability证据、默认值状态、生成列属性、真实DDL与来源哈希、生效时点。
2. **投影血缘**：视图/子查询输出列对应哪些基表列；表达式列与直接投影区分。
3. **写入能力**：INSERT与UPDATE分别判断列是否可写，另看READ ONLY、CHECK OPTION、RULE、触发器和保留键限制。列存在不等于可写。
4. **语句消费**：INSERT列重排/省略/DEFAULT VALUES与UPDATE SET分别处理；共享事实不共享错误的语句求值语义。
5. **运行时Oracle**：默认表达式结果、行数、错误身份、权限和状态变化保持独立，不由静态层标记通过。

默认值至少区分“证实无声明、显式NULL、有限常量、动态表达式、未解析”；缺DDL或解析失败不得当作NULL。视图UNKNOWN不能通过同名基表或仅复制provides列来消除。

### 最小实施范围与迁移

先考虑独立内部派生契约，保留V1 YAML字段、case ID及生成报告格式。首轮只处理普通基表有限完整DDL、整数/文本/布尔常量默认值和单表直接投影视图。动态函数、域、序列/identity、生成列、连接视图、触发器/RULE、递归/DML CTE、兼容模式错误降级均不默认放行。

以两个声明默认值fixture、原无默认值fixture、两个视图fixture作对照。实际SQL/ID/expected不变，新增用例独立记录。ALTER/DROP/重建、共享fixture与依赖正文变化必须使派生证据失效。公共字段如确需增加或语义变更，另交版本化方案审批。

### 开始实现前必须具备的失败先行测试

- 无声明与未知证据不混淆；DEFAULT NULL与NOT NULL矛盾显式返回。
- INSERT省略列/前N列映射与UPDATE未赋值列不混用。
- 类型族相同不等于长度、范围、隐式转换安全。
- 视图直接列与计算列、READ ONLY、CHECK OPTION、键保留未知分别保持证据边界。
- ALTER/DROP和依赖变化撤销旧证据；错误Oracle不被setup失败满足。
- 固定3830case分母逐项对账；列契约解析进展不自动变成实机通过。

37条DEFAULT类是第一停止原因，另41条中10条也含DEFAULT；不得预先承诺关闭37或47条，更不能将各契约覆盖收益相加。

## 3. 56个无普通manifest包

完整成员及下一项验收条件见`NO_MANIFEST_REVIEW_ROUTES.json`。五个路线互斥只为调度，真实能力/风险可以重叠：当前PDF明确限制6、内部/工具协议15、外部资产/驱动15、隔离管理生命周期14、模型/计划语义6。

目前完成分类与六个明确限制章节的原文复核；其余50个需要按组继续补具体资产/协议/能力契约，未声称已修复或已可生成。没有更改这些包的manifest、support或scenario状态。

56包后续建议先做DBLINK/外表资产需求与表空间生命周期的文档设计；共享列契约现按用户批准的最小内部范围单独实现、验收。任何数据库操作另行授权，不由此文档或静态状态自动触发。
