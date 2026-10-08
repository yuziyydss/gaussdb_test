# SQL Reference Wave 8-42 Extraction V1

## 目标

抽取 `1.13.9.45 CREATE SEQUENCE`，补齐序列创建、LARGE/TEMPORARY、取值范围、缓存、循环和OWNED BY能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.45` | 5 | CREATE SEQUENCE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 序列等差数列用途、属主和Schema/命名规则
- `nextval()`与`generate_series(1,N)`调用次数约束
- `CREATE ANY SEQUENCE`权限
- rowid/rowno关联限制
- LARGE int64/int128范围
- TEMPORARY/TEMP会话生命周期、隔离与Schema规则
- 临时序列对同名永久序列的遮蔽
- IF NOT EXISTS、名称长度
- INCREMENT、MINVALUE/MAXVALUE默认范围、START
- CACHE、CYCLE/NOCYCLE、OWNED BY
- 表自增列实现与CYCLE示例

## Open questions

| ID | 内容 |
|---|---|
| `seq_wave8_42_oq_runtime` | CREATE SEQUENCE在真实并发、缓存、CYCLE、临时序列和OWNED BY组合下的取值连续性与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_42_v1.yaml
generated/core_sql_reference_wave8_42_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_42.py
python scripts/build_core_sql_reference_wave8_42.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_42.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE SEQUENCE或DDL。
