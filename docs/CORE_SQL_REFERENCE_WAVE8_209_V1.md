# SQL Reference Wave 8-209 Extraction V1

## 目标

抽取 GUC查询规划：`7.3.8 查询规划`（优化器方法配置/优化器开销常量/基因查询优化器/DSL规则引擎/其他优化器选项，页 4323–4398）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 75 |
| 结构化 facts | 14 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 概述：GUC参数影响优化器方法选择/更好方法（ANALYZE/statistics_target）/全局设置影响运维监控
- 优化器方法配置（7.3.8.1）：~35个enable/force类布尔参数（bitmapscan/hashagg/hashjoin/indexscan/nestloop/seqscan/sort/tidscan/vector_engine/opfusion_reuse/iud_fusion/smp_partitionwise/index_skip_scan/indexonlyscan_or/partition_statistic/constraint_optimization等）
- 优化器开销常量（7.3.8.2）：seq_page_cost/random_page_cost/cpu_tuple_cost/cpu_index_tuple_cost/cpu_operator_cost/effective_cache_size/allocate_mem_cost/smp_thread_startup_cost
- 基因查询优化器（7.3.8.3）：geqo/threshold/effort/pool_size/generations/selection_bias/seed
- DSL规则引擎（7.3.8.4）：enable_dsl_ruleengine/dsl_engine_max_iteration/dsl_rulelist
- 其他优化器选项（7.3.8.5）：enable_opfusion（简单增删改查优化限制）/query_dop（SMP并行度-128~128自适应）/enable_global_plancache/plan_cache_mode（auto/generic/custom）/default_statistics_target（正数桶数/负数百分比）/cursor_sharing（force/exact/off）/rewrite_rule/costbased_rewrite_rule/enable_codegen+bloom filter/sql_beta_feature/enable_hypo_index/enable_auto_explain/enable_smp_dml/enable_invisible_indexes等
