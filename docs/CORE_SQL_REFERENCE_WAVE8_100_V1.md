# SQL Reference Wave 8-100 Extraction V1

## 目标

抽取 D 族与 ROLLBACK 收官批：`DEALLOCATE`、`DECLARE`、`DO`、`ROLLBACK`、`ROLLBACK PREPARED` 与 `ROLLBACK TO SAVEPOINT`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.1` | 2 | DEALLOCATE |
| `1.13.10.2` | 4 | DECLARE |
| `1.13.10.4` | 1 | DO |
| `1.13.18.11` | 2 | ROLLBACK |
| `1.13.18.12` | 2 | ROLLBACK PREPARED |
| `1.13.18.13` | 2 | ROLLBACK TO SAVEPOINT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- DEALLOCATE删除预备语句、PREPARE关键字语法兼容、会话结束自动清除
- q1-q4删除单个/全部行为基线（pg_prepared_statements）
- DECLARE双语义（游标+匿名块）、BINARY/NO SCROLL/WITH HOLD参数、WITH HOLD缓存耗时须知
- cursor1 FETCH基线、匿名块DECLARE...BEGIN...END语法
- DO匿名代码块VOID返回、plpgsql默认语言、不受信任语言USAGE权限
- DO动态GRANT循环示例
- ROLLBACK与ABORT等价、事务外NOTICE、DDL回滚恢复表结构基线
- ROLLBACK PREPARED两阶段提交回滚、标识符唯一性、发起用户/系统管理员权限
- ROLLBACK TO SAVEPOINT语义（保存点保持有效、未定义报错）
- 游标非事务性行为（FETCH位置不回滚、游标不可执行状态）
- RELEASE SAVEPOINT保留命令结果
- my_savepoint/foo游标位置行为基线

## Open questions

| ID | 内容 |
|---|---|
| `dcl_tcl_wave8_100_oq_runtime` | WITH HOLD游标大数据量缓存的耗时边界、两阶段提交PREPARE/ROLLBACK PREPARED与故障恢复组合、保存点内游标FETCH位置在异常回滚下的行为在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_100_v1.yaml
generated/core_sql_reference_wave8_100_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_100.py
python scripts/build_core_sql_reference_wave8_100.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_100.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行预备语句/游标/事务回滚语句。
