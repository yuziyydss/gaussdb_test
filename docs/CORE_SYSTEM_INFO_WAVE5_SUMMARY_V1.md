# Core System Information Functions Wave 5 Summary V1

## 目标

汇总 `1.6.26 系统信息函数` 的 Wave 5-1 至 Wave 5-4 静态抽取结果，审计页面覆盖、facts 和 open questions 总量。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1.6.26 系统信息函数 |
| 物理页 | 560–592，共33页 |
| Wave数 | 4 |
| 结构化 facts | 122 |
| Open questions | 8 |
| Source resolved | 4 / 4 |
| 页面覆盖 | 33 / 33 |
| 缺失页面 | 0 |

## 覆盖结论

- 页面覆盖采用 `page_union` 口径：所有 Wave 页面切片并集后完整覆盖 catalog 中的 1.6.26 全章。
- 无页面缺失，也无超出章节的额外页面。
- 2个页面存在 Wave 间重叠，用于跨页函数和表格的边界衔接：`571、586`。
- 所有 facts 全局 ID 唯一，均为 `confirmed`。
- 所有 open questions 全局 ID 唯一，均为 `open`。

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 74 |
| constraint | 27 |
| behavior_oracle | 16 |
| environment | 5 |
| 总计 | 122 |

## Wave索引

| Wave | 物理页 | Facts | Open questions | 文档 |
|---|---|---:|---:|---|
| 5-1 | 560–571 | 37 | 2 | [CORE_SYSTEM_INFO_WAVE5_1_V1.md](CORE_SYSTEM_INFO_WAVE5_1_V1.md) |
| 5-2 | 571–578 | 22 | 2 | [CORE_SYSTEM_INFO_WAVE5_2_V1.md](CORE_SYSTEM_INFO_WAVE5_2_V1.md) |
| 5-3 | 579–586 | 32 | 2 | [CORE_SYSTEM_INFO_WAVE5_3_V1.md](CORE_SYSTEM_INFO_WAVE5_3_V1.md) |
| 5-4 | 586–592 | 31 | 2 | [CORE_SYSTEM_INFO_WAVE5_4_V1.md](CORE_SYSTEM_INFO_WAVE5_4_V1.md) |

## 机器校验内容

汇总脚本会校验：

- 4个 Wave manifest 存在且 `id` 正确。
- 每个 manifest 的 facts YAML 哈希未漂移。
- 每个 manifest 的 resolved source 文件哈希未漂移。
- manifest 与 facts 的 facts / open questions 计数一致。
- 所有 Wave 共享同一 catalog 与 chapter hash。
- 页面并集完整覆盖 catalog 的 560–592。
- 全局 facts 和 open questions ID 唯一。

## 产物

```text
generated/core_system_info_wave5_summary_v1/summary.json
```

## 机器校验

```bash
python scripts/build_core_system_info_wave5_summary.py
python scripts/build_core_system_info_wave5_summary.py --check
python -m pytest -q tests/test_core_system_info_wave5_summary.py
```

## 边界

- 本汇总只审计静态抽取覆盖，不判定原文中每个函数都已有可执行SQL。
- 8个 open questions 仍需授权环境和实机验证。
- `confirmed` 表示原文事实确认，不表示 runtime verified。
- 本轮不连接数据库、不执行任何系统信息函数。
