# SQL Reference Wave 8-189 Extraction V1

## 目标

抽取 MySQL兼容M模式系统函数：`4.4.2.2 系统函数`（流程控制/日期时间/字符串/强制转换/加密/比较/聚合/JSON/窗口/数字/网络/其他函数，页 3331–3379）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 48 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 同名函数处理：不支持清单（isEmpty/overlaps/point）+ 保持GaussDB行为清单（ceil/decode等）+ GUC控制切换（enable_conflict_funcs/enable_samename_funcs）
- 公共差异：返回值类型（Var/Const限定）、LIMIT/OFFSET逐行调用差异、pg_catalog调用限制、NULL入参处理差异
- 流程控制：IF/IFNULL/NULLIF差异（隐式转换错误处理、float精度差异基线2.123 vs 2.1229...）
- 日期时间函数：ADDDATE~YEARWEEK全系列
- 字符串函数：ASCII~UNHEX全系列
- 强制转换/加密/比较/聚合/JSON/窗口/数字/网络地址/其他函数兼容情况

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_189_oq_runtime` | 同名函数GUC控制（enable_conflict_funcs/enable_samename_funcs）的完整行为矩阵、LIMIT/OFFSET场景逐行调用函数报错中断与MySQL不中断的行为差异影响范围、IFNULL/NULLIF float精度差异的完整影响面需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_189_v1.yaml
generated/core_sql_reference_wave8_189_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_189.py
python scripts/build_core_sql_reference_wave8_189.py --check
python -m unittest tests.test_core_sql_reference_wave8_189 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
