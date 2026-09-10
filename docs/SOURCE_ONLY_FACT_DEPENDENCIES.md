# 来源事实与包调度：最小阶段合同

实际消费者：CREATE INDEX二级分区profile需要CREATE TABLE SUBPARTITION的组合规则。旧图同时把CREATE SCHEMA内嵌索引的来源引用、索引对二级分区的来源引用、二级表fixture对schema资产的依赖，都当作“等待整个提供者包完成”，造成环。但真实schema→表的fixture执行DAG没有环。

## 显式、逐引用选择阶段

```yaml
# create_index.factor.yaml
source_only_fact_refs:
  - create_table_subpartition::create_table_subpartition_fact_body_12
```

这表示只读取该章已登记的事实，不等待该章全部manifest、fixture与场景完成；它不是忽略依赖或认可数据库能力。实际matrix/profile仍保留同一个fact_refs引用。原ci_table_subpartitioned仍为conditional，无fixture，不能因为来源引用通过就进入正向清单。

默认行为不变：没有显式声明的引用仍参与包调度。不能一次性把提供者所有引用都移出调度；同一提供者还有其他包阶段引用或真实fixture依赖时，等待关系仍在。

加载检查逐引用要求：跨包、已导出、confirmed、实际被合法类型消费者引用、来源unit均mapped、账本与provider声明的章节SHA一致。不允许空泛声明、重复、未消费、未导出或未映射事实借此绕过依赖检查。

## 三个边界

| 接口 | 用途 | 保留内容 |
| --- | --- | --- |
| factor_dependency_graph | 来源记录、变更失效传播 | 所有事实与fixture归属边，允许出现混合阶段的来源环 |
| factor_scheduling_graph / factor_topological_order | 包任务等待顺序 | 只排除明确且合法的source-only引用；仍拒绝真正包等待环 |
| fixture_topological_order | 前置资产的创建/反向清理顺序 | 原有requires_fixture_refs全部保留，仍拒绝缺失与fixture环 |

队列使用调度图排列包任务，并保存source_only_fact_refs。验证快照仍遍历完整来源图，所以提供者事实、包文件或正文改变仍使下游验证过期；有环时去重遍历，不把消费者自身再记成外部依赖。source-only任务遇到无法加载的当前registry，不允许退回旧依赖信息伪造新快照。

生成报告同时输出完整依赖、调度依赖和source-only声明，不能把来源图当成单一线性执行顺序。跨章节试点按实际字段独立声明引用阶段：校验来源和失效时用完整图；排队模拟时用调度图。

## 没有承诺的能力

- mapped/confirmed是规格声明，不是PDF重新校对、来源正确性或数据库运行证明。实际正文文件hash与过期检查仍由原有来源验证/依赖快照负责，不能省略。
- 不是通用流程引擎，也没有增加跨数据库、跨会话、并发、失败恢复或运行时阶段调度。
- 没有把普通schema fixture的owner置空、删除来源或取消循环检测。
- 二级分区的真实DDL树、索引键和LOCAL位置映射是后续独立生成合同；通过依赖检查不等于那两条草稿SQL已验收。

测试应分别验证默认环拒绝、明确来源引用、非法引用、实际fixture边保留、同提供者的其他包阶段边保留，以及来源变化仍被快照检测。有关补充正文的真实磁盘hash验证由原有来源闭包测试独立覆盖。
