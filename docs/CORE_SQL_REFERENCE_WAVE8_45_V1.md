# SQL Reference Wave 8-45 Extraction V1

## 目标

抽取 `1.13.7.6 ALTER DATABASE`，补齐数据库属性修改、会话参数、对象隔离、时区和ILM能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.6` | 6 | ALTER DATABASE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- ALTER DATABASE属性族与权限边界
- 改名、owner、默认表空间权限要求
- 当前库不能重命名与templatem重命名限制
- CONNECTION LIMIT、RENAME、OWNER TO、SET TABLESPACE
- 新表空间物理迁移和已有对象冲突
- SET/RESET数据库会话参数
- ENABLE/DISABLE PRIVATE OBJECT及系统表行级访问控制
- SET DBTIMEZONE
- MOVE BUCKETS当前不支持
- `SET ILM = on/off`
- 会话参数下一次会话生效

## Open questions

| ID | 内容 |
|---|---|
| `altdb_wave8_45_oq_runtime` | ALTER DATABASE在真实连接、权限、表空间迁移、对象隔离和时区组合下的生效结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_45_v1.yaml
generated/core_sql_reference_wave8_45_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_45.py
python scripts/build_core_sql_reference_wave8_45.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_45.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER DATABASE或DDL。
