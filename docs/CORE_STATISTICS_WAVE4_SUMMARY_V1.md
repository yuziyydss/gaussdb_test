# Core Statistics Functions Wave 4 Summary V1

## 目标

汇总 `1.6.29 统计信息函数` 的 Wave 4-1 至 Wave 4-10 静态抽取结果，审计页面覆盖、facts 和 open questions 总量。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1.6.29 统计信息函数 |
| 物理页 | 812–900，共89页 |
| Wave数 | 10 |
| 结构化 facts | 290 |
| Open questions | 20 |
| Source resolved | 10 / 10 |
| 页面覆盖 | 89 / 89 |
| 缺失页面 | 0 |

## 覆盖结论

- 页面覆盖采用 `page_union` 口径：所有 Wave 页面切片并集后完整覆盖 catalog 中的 1.6.29 全章。
- 无页面缺失，也无超出章节的额外页面。
- 5个页面存在 Wave 间重叠，用于跨页函数、表格或示例的边界衔接：`821、834、864、874、889`。
- 所有 facts 全局 ID 唯一，均为 `confirmed`。
- 所有 open questions 全局 ID 唯一，均为 `open`。

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 108 |
| constraint | 130 |
| behavior_oracle | 36 |
| environment | 16 |
| 总计 | 290 |

## Wave索引

| Wave | 物理页 | Facts | Open questions | 文档 |
|---|---|---:|---:|---|
| 4-1 | 812–821 | 33 | 2 | [CORE_STATISTICS_WAVE4_1_V1.md](CORE_STATISTICS_WAVE4_1_V1.md) |
| 4-2 | 821–834 | 45 | 2 | [CORE_STATISTICS_WAVE4_2_V1.md](CORE_STATISTICS_WAVE4_2_V1.md) |
| 4-3 | 834–842 | 36 | 2 | [CORE_STATISTICS_WAVE4_3_V1.md](CORE_STATISTICS_WAVE4_3_V1.md) |
| 4-4 | 843–852 | 55 | 2 | [CORE_STATISTICS_WAVE4_4_V1.md](CORE_STATISTICS_WAVE4_4_V1.md) |
| 4-5 | 853–864 | 20 | 2 | [CORE_STATISTICS_WAVE4_5_V1.md](CORE_STATISTICS_WAVE4_5_V1.md) |
| 4-6 | 864–874 | 23 | 2 | [CORE_STATISTICS_WAVE4_6_V1.md](CORE_STATISTICS_WAVE4_6_V1.md) |
| 4-7 | 874–880 | 24 | 2 | [CORE_STATISTICS_WAVE4_7_V1.md](CORE_STATISTICS_WAVE4_7_V1.md) |
| 4-8 | 881–889 | 19 | 2 | [CORE_STATISTICS_WAVE4_8_V1.md](CORE_STATISTICS_WAVE4_8_V1.md) |
| 4-9 | 889–896 | 14 | 2 | [CORE_STATISTICS_WAVE4_9_V1.md](CORE_STATISTICS_WAVE4_9_V1.md) |
| 4-10 | 897–900 | 21 | 2 | [CORE_STATISTICS_WAVE4_10_V1.md](CORE_STATISTICS_WAVE4_10_V1.md) |

## 机器校验内容

汇总脚本会校验：

- 10个 Wave manifest 存在且 `id` 正确。
- 每个 manifest 的 facts YAML 哈希未漂移。
- 每个 manifest 的 resolved source 文件哈希未漂移。
- manifest 与 facts 的 facts / open questions 计数一致。
- 所有 Wave 共享同一 catalog 与 chapter hash。
- 页面并集完整覆盖 catalog 的 812–900。
- 全局 facts 和 open questions ID 唯一。

## 产物

```text
generated/core_statistics_wave4_summary_v1/summary.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_summary.py
python scripts/build_core_statistics_wave4_summary.py --check
python -m pytest -q tests/test_core_statistics_wave4_summary.py
```

## 边界

- 本汇总只审计静态抽取覆盖，不判定原文中每个函数都已有可执行SQL。
- 20个 open questions 仍需授权环境和实机验证。
- `confirmed` 表示原文事实确认，不表示 runtime verified。
- 本轮不连接数据库、不执行任何统计信息函数。
