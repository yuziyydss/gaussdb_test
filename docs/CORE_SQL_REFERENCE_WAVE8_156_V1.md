# SQL Reference Wave 8-156 Extraction V1

## 目标

抽取 高级包第十五批切片：`3.12.2.13 DBE_OUTPUT`（缓冲输出）与 `3.12.2.14 DBE_PROFILER`（存储过程profiling）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2801–2812，两个完整小节） |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_OUTPUT：十接口全原型（PRINT/PRINT_LINE、SET_BUFFER_SIZE 20000/2000规则、DISABLE/ENABLE、GET_LINE status 0/1、GET_LINES numlines INOUT、NEW_LINE/PUT/PUT_LINE）；九组示例基线（disable不输出、put+new_line输出a、get_line/get_lines取回）；server_encoding非UTF-8特殊字符与enable_convert_illegal_char说明
- DBE_PROFILER：plprofiler原理（打桩+内存+事务提交落表）、commit/rollback语义、普通用户只读权限、PL_START_PROFILING（sessionid_runid唯一标识）/PL_CLEAR_PROFILING；四张系统表全列（FUNCTIONS/DETAILS含BODY类清单与_FUNCCALL后缀/CALLGRAPH/TRACKINFO）；七条约束（存储过程内不生效、runid 64字节、匿名块/PACKAGE初始化/自治事务不支持、500层嵌套上限）；p1/p2/p3示例基线

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_156_oq_runtime` | ENABLE/DISABLE切换对已缓冲未输出内容的保留策略、GET_LINES取出后的缓冲区指针复位行为、profiling数据在500层嵌套与max_stack_depth组合下的实际截断点需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_156_v1.yaml
generated/core_sql_reference_wave8_156_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_156.py
python scripts/build_core_sql_reference_wave8_156.py --check
python -m unittest tests.test_core_sql_reference_wave8_156 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行profiling。
