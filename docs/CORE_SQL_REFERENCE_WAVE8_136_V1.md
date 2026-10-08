# SQL Reference Wave 8-136 Extraction V1

## 目标

抽取 M 兼容 `LOAD DATA`、`LOCK` 与 `REPLACE`（2.4.2 语句章收官批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- LOAD DATA：LOCAL/服务端路径规则（enable_load_data_remote_transmission）、REPLACE/IGNORE冲突行为、FIELDS/LINES全参数（分隔符转义引号）、SET列值表达式、与INTO OUTFILE配合子句匹配规则、safe_data_path白名单、PARTITION导入
- LOCK：事务块内使用、READ/WRITE/ACCESS SHARE三种锁类型、表2-27锁冲突矩阵、NOWAIT、UNLOCK TABLE暂不支持、xc_maintenance_mode系统表WRITE报错
- REPLACE：三形式（值/查询/SET）、REPLACE 0 X返回格式、SET列依赖计算（f1零值+3）、默认零值表、多唯一约束全删警告、DEFERRABLE不支持、密态表/内存表不支持
- 示例基线（LOAD DATA三种导入/LOCK READ/REPLACE三种形式）

## Open questions

| ID | 内容 |
|---|---|
| `m_ld_lock_rep_wave8_136_oq_runtime` | M兼容LOAD DATA LOCAL与enable_load_data_remote_transmission组合的传输边界、REPLACE...SET列依赖计算的求值顺序、LOCK READ模式与分区表并发DML的锁冲突行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_136_v1.yaml
generated/core_sql_reference_wave8_136_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_136.py
python scripts/build_core_sql_reference_wave8_136.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_136.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容LOAD DATA/LOCK/REPLACE语句。
