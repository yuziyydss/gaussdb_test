# SQL Reference Wave 8-129 Extraction V1

## 目标

抽取 M 兼容 2.5 收官批：`其他函数`、`安全函数`、`失效重编译函数` 与 `计划外应用无损透明`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 21 |
| 结构化 facts | 21 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- 其他函数13个：ANY_VALUE/BENCHMARK/CHARSET/COLLATION/CONNECTION_ID/CURRENT_USER/DATABASE/DEFAULT/FOUND_ROWS/ROW_COUNT/SCHEMA/SLEEP/SYSTEM_USER/USER/UUID/UUID_SHORT
- FOUND_ROWS/ROW_COUNT的s2+enable_conflict_funcs行为开关
- 安全函数pg_delete_audit/pg_query_audit（多租non-PDB/PDB差异、13个审计字段）
- 失效重编译transform_view_dep_source/gs_compile_schema（compile_all/retry_times、pg_object.valid基线）
- 计划外ALT概述与表2-60~2-71全部函数ALT支持清单（流程控制/日期时间/字符串/强制转换/加密/比较/聚合/JSON/窗口/数字/网络地址/其他）

## Open questions

| ID | 内容 |
|---|---|
| `m_other_wave8_129_oq_runtime` | 计划外ALT故障切换时各函数会话状态恢复的完整边界、FOUND_ROWS/ROW_COUNT在s2开关下的行为差异矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_129_v1.yaml
generated/core_sql_reference_wave8_129_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_129.py
python scripts/build_core_sql_reference_wave8_129.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_129.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容其他/安全/重编译函数。
