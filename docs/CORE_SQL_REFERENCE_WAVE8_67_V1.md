# SQL Reference Wave 8-67 Extraction V1

## 目标

抽取 S 段开头：`SAVEPOINT` 保存点、`SECURITY LABEL ON` 安全标签应用与 `SELECT INTO` 建表插入。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.1` | 2 | SAVEPOINT |
| `1.13.19.2` | 3 | SECURITY LABEL ON |
| `1.13.19.4` | 3 | SELECT INTO |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- SAVEPOINT建立保存点、ROLLBACK TO/RELEASE语义
- 事务块限制、多保存点
- 节点/通信故障与COPY FROM结构不一致导致整体回滚
- 同名保存点GaussDB保留旧点但只用最近点
- 子事务嵌套≤10000建议
- ROLLBACK TO SAVEPOINT行为基线
- SECURITY LABEL ON语法（ROLE/USER/TABLE/COLUMN）与NULL取消
- 初始用户/SYSADMIN/gs_role_seclabel权限
- 应用与取消标签行为基线
- SELECT INTO建新表不返回客户端、CTAS超集建议与存储过程限制
- 完整INTO语法（TEMP/UNLOGGED等）
- 非日志表速度/清空风险/不复制备机/备份场景/索引重建
- 全局/本地临时表语义、ON COMMIT两种模式、pg_temp_ schema注意事项
- SELECT INTO行为基线

## Open questions

| ID | 内容 |
|---|---|
| `select_into_wave8_67_oq_runtime` | SAVEPOINT异常回滚边界、SECURITY LABEL权限组合和SELECT INTO临时表/非日志表在真实并发、故障恢复路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_67_v1.yaml
generated/core_sql_reference_wave8_67_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_67.py
python scripts/build_core_sql_reference_wave8_67.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_67.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行保存点/标签/建表语句。
