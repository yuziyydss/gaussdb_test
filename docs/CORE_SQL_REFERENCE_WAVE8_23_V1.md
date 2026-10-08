# SQL Reference Wave 8-23 Extraction V1

## 目标

抽取 `1.13.7.36 ALTER TABLE`，补齐表结构演进、在线/离线DDL、列定义变更、约束体系、触发器/行级安全、逻辑复制身份、字符集和ILM策略能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.36` | 30 | ALTER TABLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 30 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- ALTER TABLE主action族与权限边界
- 分区表空间、ORIENTATION、系统列、行访问控制和SET SCHEMA限制
- ADD COLUMN默认值快速路径与FIRST/AFTER位置约束
- 表约束数量、在线DDL磁盘预留和执行限制
- ONLINE/OFFLINE退化场景、并行与追增参数、失败残留清理
- ADD/DROP/VALIDATE约束、DROP PRIMARY KEY/FOREIGN KEY
- CLUSTER、SET WITH ROWID、存储参数、属主和表空间
- 触发器、行访问控制、TDE密钥轮转
- REPLICA IDENTITY逻辑复制记录级别
- AUTO_INCREMENT、默认字符集和CONVERT TO字符集
- ILM高级压缩策略与分区策略管理
- ADD/MODIFY/CHANGE/DROP/ALTER COLUMN、USING转换、统计信息和IDENTITY

## Open questions

| ID | 内容 |
|---|---|
| `alt_wave8_23_oq_runtime` | ALTER TABLE在真实表规模、在线/离线DDL、分区、约束、字符集转换、ILM和逻辑复制组合下的结果、锁等待、残留对象与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_23_v1.yaml
generated/core_sql_reference_wave8_23_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_23.py
python scripts/build_core_sql_reference_wave8_23.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_23.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER TABLE或DDL。
