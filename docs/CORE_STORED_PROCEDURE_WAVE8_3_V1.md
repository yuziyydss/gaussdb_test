# Stored Procedure Wave 8-3 Extraction V1

## 目标

抽取 `3.10 其他语句` 与 `3.11 游标`，补齐存储过程锁操作、失效重编译死锁和游标生命周期。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `3.10` | 5 | 锁操作 / DDL失效重编译死锁 |
| `3.11` | 10 | 显式游标、隐式游标、游标循环 |
| 合计（去重） | **14** | **2章** |

> 页2631由 `3.10` 收尾和 `3.11` 起始共享；manifest按章节切片记录，页级统计去重后为14页。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 14 |
| 结构化 facts | 21 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 存储过程读锁/写锁生命周期
- 高并发DDL死锁和失效重编译级联失效
- PACKAGE依赖读锁
- 游标定义、显式/隐式分类与六步生命周期
- JDBC返回游标限制
- commit/rollback时的游标缓存与回滚后FETCH报错
- `forbid_hold_cursor_with_forupdate`
- 静态/动态游标参数与`OPEN FOR`
- 隐式游标属性和`compat_cursor`
- `FOR AS`循环与共享游标属性

## Open questions

| ID | 内容 |
|---|---|
| `sp_wave8_3_oq_lock_cursor_runtime` | 失效重编译DDL死锁、游标缓存耗时和FOR UPDATE游标在事务边界后的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_stored_procedure_wave8_3_v1.yaml
generated/core_stored_procedure_wave8_3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_stored_procedure_wave8_3.py
python scripts/build_core_stored_procedure_wave8_3.py --check
python -m pytest -q tests/test_core_stored_procedure_wave8_3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DDL或游标。
