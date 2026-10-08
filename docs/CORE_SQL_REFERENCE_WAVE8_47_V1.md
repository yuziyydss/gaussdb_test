# SQL Reference Wave 8-47 Extraction V1

## 目标

合并抽取 `CREATE TABLESPACE` 与 `ALTER TABLESPACE`，补齐表空间创建、路径/限额、成本参数、属性修改和限额调整能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.52` | 4 | CREATE TABLESPACE |
| `1.13.7.39` | 4 | ALTER TABLESPACE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- CREATE TABLESPACE权限、事务限制、失败残留与两阶段事务边界
- HCS/PDB场景建议
- 主语法、OWNER、RELATIVE、LOCATION、MAXSIZE
- 名称唯一性和pg前缀限制
- 绝对路径权限、空目录、特殊字符、数据目录和文件系统建议
- WITH filesystem/address/cfgpath/storepath/cost参数
- ALTER TABLESPACE权限、owner成员关系、系统表空间限制
- RENAME TO、OWNER TO、SET/RESET属性
- seq_page_cost/random_page_cost语义与默认值
- RESIZE MAXSIZE、UNLIMITED和超限额处理

## Open questions

| ID | 内容 |
|---|---|
| `tbs_wave8_47_oq_runtime` | CREATE/ALTER TABLESPACE在真实多节点、路径权限、限额调整和并发DML组合下的残留清理、回滚与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_47_v1.yaml
generated/core_sql_reference_wave8_47_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_47.py
python scripts/build_core_sql_reference_wave8_47.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_47.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE/ALTER TABLESPACE。
