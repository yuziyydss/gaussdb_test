# SQL Reference Wave 8-43 Extraction V1

## 目标

合并抽取 `ALTER SEQUENCE` 与 `DROP SEQUENCE`，补齐序列参数修改、归属列、LARGE标识、缓存清空和依赖删除能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.30` | 3 | ALTER SEQUENCE |
| `1.13.10.38` | 2 | DROP SEQUENCE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- ALTER SEQUENCE权限与owner变更约束
- 当前仅支持owner、归属列、最大值和cache的边界
- MAXVALUE事务限制与所有会话缓存清空
- LARGE标识一致性
- ALTER SEQUENCE阻塞nextval/setval/currval/lastval
- MAXVALUE/CACHE/OWNED BY语法
- 普通与LARGE序列的MAXVALUE、CACHE范围
- OWNED BY覆盖旧关联、所有者/Schema约束和NONE语义
- 新owner角色成员与模式CREATE权限
- 归属列和owner变更示例
- DROP SEQUENCE权限、LARGE一致性、IF EXISTS和CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `seq_wave8_43_oq_runtime` | ALTER/DROP SEQUENCE在真实并发、缓存、LARGE标识、OWNED BY和依赖对象组合下的阻塞、错误与依赖处理矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_43_v1.yaml
generated/core_sql_reference_wave8_43_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_43.py
python scripts/build_core_sql_reference_wave8_43.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_43.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER/DROP SEQUENCE或DDL。
