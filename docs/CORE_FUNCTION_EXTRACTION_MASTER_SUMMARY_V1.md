# Core Function Extraction Master Summary V1

## 目标

聚合核心函数抽取链路中的全部 `core_*_v1/manifest.json`，建立顶层facts总账和覆盖视图。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Manifest artifacts | 150 |
| Sources | 379 |
| Source page slices | 2758 |
| Unique pages | 2396 |
| Sections | 332 |
| Full coverage sections | 282 |
| Partial coverage sections | 50 |
| 结构化 facts | 3416 |
| Open questions | 207 |

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 1594 |
| constraint | 1290 |
| behavior_oracle | 375 |
| environment | 157 |
| 总计 | 3416 |

所有facts全局ID唯一，状态均为`confirmed`；所有open questions全局ID唯一，状态均为`open`。

## 覆盖口径

覆盖模式为`included_extraction_artifacts`，表示只统计已纳入150个manifest的source切片；当前纳入小节的页级覆盖已闭环。

当前：

- 已覆盖unique页：2396
- 已纳入artifact所在章节 required 页：2396
- 缺失页：无
- 完整覆盖小节：282
- 部分覆盖小节：50

部分覆盖小节表示对应大章节的manifest只按目标事实或目标函数族选择页面，不代表整章所有页都纳入。

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
- 207个open questions仍需授权环境和实机验证。
- `confirmed`表示原文事实确认，不表示runtime verified。
- 不连接数据库、不执行系统函数。
