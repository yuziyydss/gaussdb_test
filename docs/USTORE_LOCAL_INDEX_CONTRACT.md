# USTORE分区LOCAL：有限能力基线

本轮只补“实际USTORE分区表 → UBTree LOCAL候选”的静态合同，
没有证明ACTIVE_PAGES的手设范围或统计更新，也没有执行数据库。

## 来源与实际输入

- CREATE TABLE PARTITION正文L94、L102–106、L366–377：WITH存储参数、
  RANGE分区与USTORE。CREATE TABLE L458–460和分区章同时要求开启
  track_counts/track_activities；manifest保存要求，不偷偷SET参数。
- CREATE INDEX L224–227、L345–350、L412–417：UBTree/引擎与LOCAL关系。
  文档允许显式btree/ubtree不匹配时转换；本合同只选匹配的ubtree，
  拒绝btree表示**未评审这个分支**，不是判定该SQL非法。
- ACTIVE_PAGES L547–550只明确USTORE分区LOCAL生效与统计更新，
  没有在此定义数值范围；不把旧profile的16猜成正向或负向有效值。

新fixture是一个实际`storage_type=ustore`、单INTEGER列id、范围上界10/20
的两分区空表。旧ASTORE多列表不能只改能力标签冒充它。
`manifest_create_index_ustore_local_fresh`通过现有AST生成单个UBTree LOCAL候选，
不含ACTIVE_PAGES、唯一、在线、分类、显式索引分区或表空间选项。

## 校验什么，不校验什么

生成器读取实际setup/目标/teardown，核对引擎、真实列、分区键、严格递增边界、
分区名唯一、profile声明一致、目标索引方法与LOCAL、独占Schema/权限/跟踪要求。
同名索引与表、错引擎、缺列、错误边界、额外参数、CASCADE清理都被有限合同拒绝。
移除profile中的合同标记不能绕过该已登记目标的校验。

源码事实引用CREATE TABLE PARTITION，但没有引用该包的fixture：使用现有
`source_only_fact_refs`记录溯源边，保留来源哈希及失效传播；不制造
create_schema → create_index → create_table_partition → create_schema的混合阶段调度环。
真实fixture依赖并未被删除或绕过。

**静态输入匹配不等于实机就绪。** 目录中引擎/索引访问方法/两分区绑定仍须校准，
自动索引分区名不可预猜。实际授权、GUC值、创建回执、自动依赖归属与成功清理均待验证。
新增场景保持planned和手工目录Oracle，统计行为与原ACTIVE_PAGES泛化缺口仍保留。
后续若测VACUUM/ANALYZE，需要真实数据/统计状态与前后Oracle；不能从空表CREATE成功
推导这些行为通过，也不能以页数必须等于16作为未查证断言。
