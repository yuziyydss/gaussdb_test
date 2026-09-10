# 候选回到待审：保留历史，不修改预期凑通过

当原文不足以证明某条硬规则时，负向SQL即使已生成，也不能被继续当作确定的目标错误。本机制只恢复证据等级，不说明SQL成功或失败；数据库执行仍单独授权。

## 真实例子：一般INSERT的query/subquery

本地V2.0-10.0.0 PDF的INSERT章中，`subquery`是插入对象（物理1741/印刷1692页），`query`是提供数据的SELECT（物理1743/印刷1694页）。物理1744/印刷1695页只写“不支持插入子查询”，未明确其指代。旧提取却将其提升为“ON CONFLICT禁止SELECT输入”，并作为全局组合硬规则，证据不足。

修正：保留L357–366其他明确限制；L367单独登记为open_question，移除这条未经证实的硬规则。原`manifest_insert_conflict_query_negative_d77629272b13`移到`scenario_insert_conflict_query_review`，status=planned；原始SQL、完整setup/teardown、PG要求、原error类别、未校准Oracle、原规则表达式全部保全。

这不是把负例改成正例，也不是把特性标记unsupported。INSERT活跃用例111→110（100正向＋10负向），待审历史候选＋1；其他110条完整字段不变。未来绑定域扩大时须重新审查，不可把这个差异结论推广到所有SQL组合。

## 三种资产及其作用

- `specs/dml/insert/scenarios/conflict_query_review.scenario.yaml`：可追溯的待审问题和历史候选。`original_case`只保留过去的假设；`execution_allowed: false`，不是已完成Oracle。
- `archive/spec_reviews/20260909/insert/conflict_query_negative.manifest.yaml`：原manifest的归档正文，不再由规格加载器读取。原SQL快照仍在原路径，字节不变，是历史资产，不能批量执行。
- `generated/factor_packages/candidate_retirements.json`：显式登记归属、待审场景、原case ID及完整case/SQL/归档manifest哈希，防止用“待审”掩盖删除或篡改。

当前活跃manifest以严格注册表及`generation_report.json`为准，不以目录内SQL文件数为准。前端因子页从`factor.manifest_refs`获取当前清单，已归档manifest的原入口不再是活跃生成入口；open_question仍应可见。

## 生成和对账

生成器在写快照前核对历史登记及场景身份。整包生成发现未登记的多余SQL时失败，不再自动删除；先解释其归属，不能通过批量批准或删除绕过。已登记历史SQL保留原字节；部分manifest生成不会把其他未选中的活跃SQL视为过期。

全量生成后运行：

```bash
GAUSSDB_ENABLED=false python3 scripts/audit_candidate_inventory.py --output work/<本次目录>/candidate_inventory.json
```

输出必须分开列出活跃manifest数、活跃case数、历史待审快照数、历史case数、物理SQL文件数。不允许遗漏未分类文件、活跃/历史重复ID、历史场景变ready、丢失待审来源、修改历史完整case字段或文件哈希。报告输出使用新路径，保留此前证据。

本次正式生成及对账（`work/project_evolution_20260909_1700/candidate_inventory.json`）为772个活跃manifest、5061个活跃case，外加1份历史SQL、1个历史case；物理SQL文件共773份。全库预览与正式产物逐项核对，剩余5061条完整case、772份活跃SQL字节及5061条写入审计记录均不变。

历史目录`archive/spec_reviews`已加入本地回归的输入指纹，归档被修改时撤销通过证据；它不再被当作可忽略的报告输出。七批冻结版1295项回归是迁移前的历史证据，不能充当本次新代码的全量验收。

## 限制

历史归档不是新的公共V1模型类型；使用已有planned scenario，不增加positive/negative之外的新suite。登记只支持有明确未解决来源问题且能够保全原候选的迁移，不是“任意失败移出统计”的授权。对账不证明SQL正确性、环境满足、Pairwise语义全覆盖或目标SQLSTATE。重新加入活跃清单前必须解决原问题、重新确定规则方向和Oracle，并明确回迁差异。
