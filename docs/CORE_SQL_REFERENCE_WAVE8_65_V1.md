# SQL Reference Wave 8-65 Extraction V1

## 目标

合并抽取 R 段后部：`REINDEX` 索引重建（含在线重建）、`RELEASE SAVEPOINT` 保存点释放与 `RENAME TABLE` 表改名。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.18.5` | 4 | REINDEX |
| `1.13.18.6` | 2 | RELEASE SAVEPOINT |
| `1.13.18.7` | 2 | RENAME TABLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- REINDEX四种使用场景
- DATABASE/SYSTEM事务块限制、物化视图不支持
- lpi_parallel_method并行重建限制
- 在线重建查询计划变化、ubtree RCR/PCR类型保持、rowid索引排除
- 三种语法形式与CROSSBUCKET option（CBI/LBI，排除集中式hashbucket与GSI）
- INDEX/TABLE/DATABASE/SYSTEM对象范围、TOAST、unusable限制、INTERNAL TABLE故障恢复
- CONCURRENTLY完整约束：锁级别、排除项、事务禁止、索引类型、并行支持、失败自动/手动清理、死锁场景
- Astore两次扫描/Ustore一次扫描+cctmp临时表过程
- name/FORCE/partition_name规则
- behavior oracle：索引膨胀64kB→376kB→REINDEX回64kB
- RELEASE SAVEPOINT语义、嵌套保存点级联删除、未定义/回滚状态限制、同名最近优先
- RENAME TABLE单/多表改名与ALTER TABLE等价性、本地临时表混用限制
- B模式5.7 s2的#MySQL50#前缀与新旧同名不报错

## Open questions

| ID | 内容 |
|---|---|
| `reindex_wave8_65_oq_runtime` | REINDEX（含CONCURRENTLY与失败清理路径）、RELEASE SAVEPOINT异常路径和RENAME TABLE多表/临时表组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_65_v1.yaml
generated/core_sql_reference_wave8_65_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_65.py
python scripts/build_core_sql_reference_wave8_65.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_65.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行索引/保存点/改名语句。
