# Stored Procedure Wave 8-2 Extraction V1

## 目标

抽取 `3.9 事务管理`，补齐存储过程域中的事务边界、保存点与限制行为。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `3.9` | 9 | 事务管理 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 9 |
| 结构化 facts | 15 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 最外围存储过程调用的事务自动开启/提交/回滚
- `COMMIT` / `ROLLBACK` 后自动开启新事务
- `SAVEPOINT` / `ROLLBACK TO` / `RELEASE`
- 支持与不支持的事务控制上下文
- DDL、DML 和 GUC 参数的提交/回滚边界
- 变量与重启级 GUC 的不可回滚边界
- PG_STAT 统计刷新时机
- 外部保存点释放、游标/表达式调用、GUC 选项等错误行为

## Open questions

| ID | 内容 |
|---|---|
| `sp_txn_wave8_2_oq_runtime_matrix` | 外部事务、异常块、自治事务、GUC选项和游标场景下的事务边界与错误行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_stored_procedure_wave8_2_v1.yaml
generated/core_stored_procedure_wave8_2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_stored_procedure_wave8_2.py
python scripts/build_core_stored_procedure_wave8_2.py --check
python -m pytest -q tests/test_core_stored_procedure_wave8_2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行事务或存储过程。
