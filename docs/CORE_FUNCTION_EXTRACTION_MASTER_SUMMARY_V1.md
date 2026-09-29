# Core Function Extraction Master Summary V1

## 目标

聚合核心函数抽取链路中的全部 `core_*_v1/manifest.json`，建立顶层facts总账和覆盖视图。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Manifest artifacts | 52 |
| Sources | 140 |
| Source page slices | 1219 |
| Unique pages | 1050 |
| Sections | 99 |
| Full coverage sections | 43 |
| Partial coverage sections | 56 |
| 结构化 facts | 1475 |
| Open questions | 109 |

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 823 |
| constraint | 388 |
| behavior_oracle | 151 |
| environment | 113 |
| 总计 | 1475 |

所有facts全局ID唯一，状态均为`confirmed`；所有open questions全局ID唯一，状态均为`open`。

## 覆盖口径

覆盖模式为`included_extraction_artifacts`，表示只统计已纳入52个manifest的source切片，不宣称整本手册已全覆盖。

当前：

- 已覆盖unique页：1050
- 已纳入artifact所在章节 required 页：1055
- 缺失页：137、179、187、247、1146
- 完整覆盖小节：43
- 部分覆盖小节：56

缺失页主要来自早期类型/表达式域中按目标事实选择页面的部分抽取；后续可按需补页或保持按事实覆盖。

## 产物

```text
generated/core_function_extraction_master_summary_v1/summary.json
```

## 机器校验

```bash
python scripts/build_core_function_extraction_master_summary.py
python scripts/build_core_function_extraction_master_summary.py --check
python -m pytest -q tests/test_core_function_extraction_master_summary.py
```

## 边界

- 本总账只聚合静态抽取facts，不判定每个函数都有可执行SQL。
- 109个open questions仍需授权环境和实机验证。
- `confirmed`表示原文事实确认，不表示runtime verified。
- 不连接数据库、不执行系统函数。
