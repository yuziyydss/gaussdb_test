# 二级 RANGE 表上的有限 LOCAL 索引合同

此增量解决 CREATE INDEX 原 `ci_table_subpartitioned` 缺少真实前置的问题，但不把该泛化值改成 valid。

## 原文依据

- 一般 CREATE INDEX 正文 L100—121：分区索引及嵌套 SUBPARTITION 语法。
- L429—479：没有 FOR 时，索引分区数量必须与目标表分区逐一对应；FOR 分类索引是另一种能力，且可能触发自治事务创建分区，本批不涉及。
- CREATE TABLE SUBPARTITION L12—14：RANGE/RANGE 是文档列举的组合，二级分区仅支持行存；L38：RANGE 使用 VALUES LESS THAN。

两个独立跨章事实均通过 `create_index.source_only_fact_refs` 显式消费。仅来源读取不要求等待提供者其他 fixture；实际 fixture DAG、来源 hash 与失效检查继续保留。

## 新增产物与实际消费者

- `ci_table_subpartition_fresh`：ASTORE 新表 `g_ci_sub_source`，INTEGER 列 id、region 分别作两层 RANGE 键；两个一级分区，每个有两个二级分区。
- `fixture_create_index_subpartition_fresh`：实际 CREATE TABLE 一条，无 seed，因为仅测试目录 DDL；清理仅 DROP 本表，不使用预 DROP、CASCADE 或 ROLLBACK 推断归属。
- `manifest_create_index_subpartition_local_fresh`：非唯一、非在线 BTREE，自动 LOCAL 与显式两父四子分区，共两个候选。不是大规模 pairwise 覆盖。
- `scenario_create_index_subpartition_local_fresh`：绑定上述候选的真实索引身份，目录 Oracle 仍 planned/manual，不猜系统目录接口。

生成器调用 `core/index_partition_contract.py` 读取实际 setup、目标 SQL 和 teardown：校验 INTEGER 列、两个真实键、ASTORE、逐层递增的有限 INTEGER 上界、名字唯一，比较实际布局与 profile 声明；显式索引验证两层数量及逐位置名称映射。不认识的后缀、FOR、GLOBAL、UNIQUE、CONCURRENTLY 或其他方法不放行。

合同不是完整数据库解析器，只覆盖无修饰 INTEGER 列、两个单列 RANGE 键、显式有限上界的保守范围。没有验证数据路由、优化器、权限实际存在、目录关系或执行后清理。表为空也不等于可以省略运行时归属检查。

## 执行边界

要求独占 fresh 用户 schema、实际建表/建索引权限；只有确认本次成功创建且没有其他所有者依赖时才允许清理本表。setup 失败不得盲清理；运行控制器尚未提供这些回执。生成 SQL 是检查快照，不是授权直接整份执行的脚本。

原泛化二级分区值、ACTIVE_PAGES/USTORE 统计生命周期以及分类索引等缺口继续保留。静态形状检查通过不能推导行为覆盖或实机验证通过。
