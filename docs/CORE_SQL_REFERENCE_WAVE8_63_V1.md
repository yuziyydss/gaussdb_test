# SQL Reference Wave 8-63 Extraction V1

## 目标

合并抽取 P 段语句族：`PREDICT BY` 模型推理、`PREPARE` 预备语句、`PREPARE TRANSACTION` 两阶段提交准备与 `PURGE` 回收站清理。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.17.1` | 2 | PREDICT BY |
| `1.13.17.2` | 2 | PREPARE |
| `1.13.17.3` | 2 | PREPARE TRANSACTION |
| `1.13.17.4` | 4 | PURGE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- PREDICT BY语法、gs_model_warehouse模型查看、训练+预测+DROP MODEL闭环
- PREPARE解析/分析/重写与EXECUTE规划执行的优化原理
- PREPARE生命周期：会话级存在、事务回滚不删除、DEALLOCATE显式删除
- PREPARE语法与statement语句类型；unknown参数解析规范
- PREPARE TRANSACTION两阶段提交语义、崩溃安全、跨会话COMMIT/ROLLBACK PREPARED
- 与ROLLBACK差异、失败即回滚；max_prepared_transactions配置要求
- transaction_id字符串文本、小于200字节、唯一性
- PURGE五种形式与表/库回收站对象
- 表/索引、回收站、库级清理的权限矩阵与三权分立默认
- 事务块限制、并发容量不足重试、文件残留约束继承
- enable_recyclebin等五个前提参数
- behavior oracle：GS_RECYCLEBIN逐个/全量清理、gs_db_recyclebin系统名/原名/批量清理

## Open questions

| ID | 内容 |
|---|---|
| `purge_wave8_63_oq_runtime` | PREDICT BY模型推理、PREPARE/EXECUTE生命周期、PREPARE TRANSACTION两阶段提交和PURGE回收站清理在真实参数、权限、并发与崩溃恢复路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_63_v1.yaml
generated/core_sql_reference_wave8_63_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_63.py
python scripts/build_core_sql_reference_wave8_63.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_63.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行模型/事务/回收站语句。
