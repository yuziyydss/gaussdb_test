# Core System Function Extraction Summary V1

## 目标

汇总系统函数高价值章节的静态抽取结果：

```text
1.6.26 系统信息函数
1.6.27 系统管理函数
1.6.28 SPM计划管理函数
1.6.29 统计信息函数
```

本文档只做跨章节覆盖与规模对账，不替代各章 Wave 文档。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 批次 | 31 |
| 物理页并集 | 560–900，共341页 |
| 结构化 facts | 811 |
| Open questions | 63 |
| Source artifacts | 4 / 4 |
| 页面覆盖 | 341 / 341 |
| 缺失页面 | 0 |

## 章节索引

| 章节 | 标题 | 物理页 | 批次 | Facts | Open questions | 汇总产物 |
|---|---|---|---:|---:|---:|---|
| 1.6.26 | 系统信息函数 | 560–592 | 4 | 122 | 8 | [CORE_SYSTEM_INFO_WAVE5_SUMMARY_V1.md](CORE_SYSTEM_INFO_WAVE5_SUMMARY_V1.md) |
| 1.6.27 | 系统管理函数 | 592–804 | 16 | 378 | 33 | [CORE_SYSTEM_ADMIN_WAVE2B_SUMMARY_V1.md](CORE_SYSTEM_ADMIN_WAVE2B_SUMMARY_V1.md) |
| 1.6.28 | SPM计划管理函数 | 804–812 | 1 | 21 | 2 | [CORE_SPM_PLAN_WAVE3_1_V1.md](CORE_SPM_PLAN_WAVE3_1_V1.md) |
| 1.6.29 | 统计信息函数 | 812–900 | 10 | 290 | 20 | [CORE_STATISTICS_WAVE4_SUMMARY_V1.md](CORE_STATISTICS_WAVE4_SUMMARY_V1.md) |

## 覆盖口径

跨章节页面并集覆盖：

```text
1.6.26：560–592
1.6.27：592–804
1.6.28：804–812
1.6.29：812–900
```

章节目录的页级切片总数为344页，但跨章节并集为341页。页592、804和812是相邻章节边界页，用于承载上一章收尾和下一章开始，聚合时只计入一次：

```text
592
804
812
```

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 400 |
| constraint | 271 |
| behavior_oracle | 98 |
| environment | 42 |
| 总计 | 811 |

所有 facts 全局 ID 唯一，状态均为 `confirmed`；所有 open questions 全局 ID 唯一，状态均为 `open`。

## 机器校验内容

汇总脚本会校验：

- 4个章节在 full document catalog 中存在。
- 4个源 artifact 存在且 kind 正确。
- catalog SHA、chapter SHA 和页面范围一致。
- 1.6.26 / 1.6.27 / 1.6.29 的子汇总页面覆盖完整。
- 1.6.28 manifest 的 source resolved 和 facts bound 状态完整。
- 所有 facts YAML 仍可加载且全局 ID 唯一。
- facts / open questions 总数与各章汇总一致。
- 页592、804和812是仅有的章节边界重叠页。
- 页面并集完整覆盖560–900。

## 产物

```text
generated/core_system_function_extraction_summary_v1/summary.json
```

## 机器校验

```bash
python scripts/build_core_system_function_extraction_summary.py
python scripts/build_core_system_function_extraction_summary.py --check
python -m pytest -q tests/test_core_system_function_extraction_summary.py
```

## 边界

- 本汇总只审计静态抽取覆盖，不判定原文中每个函数都已有可执行SQL。
- 63个 open questions 仍需授权环境和实机验证。
- `confirmed` 表示原文事实确认，不表示 runtime verified。
- 本轮不连接数据库、不执行任何系统函数。
