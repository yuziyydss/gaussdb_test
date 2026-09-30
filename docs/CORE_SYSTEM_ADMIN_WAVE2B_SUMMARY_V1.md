# Core System Management Wave 2B Summary V1

## 目标

汇总 `1.6.27 系统管理函数` 的 Wave 2B-1 至 Wave 2B-15 静态抽取结果，审计页面覆盖、子节覆盖、facts 与 open questions 总量。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1.6.27 系统管理函数 |
| 物理页 | 592–804，共213页 |
| Wave数 | 16 |
| 子节数 | 17（1.6.27.1–1.6.27.17） |
| 结构化 facts | 378 |
| Open questions | 33 |
| Source resolved | 16 / 16 |
| 页面覆盖 | 213 / 213 |
| 缺失子节 | 0 |

## 覆盖结论

- 页面覆盖采用 `page_union` 口径：所有 Wave 页面切片并集后完整覆盖 catalog 中的 1.6.27 全章。
- 无页面缺失，也无超出章节的额外页面。
- 11个页面存在 Wave 间重叠，用于跨页函数/表说明的边界衔接：`627、628、629、641、642、661、674、746、777、788、795`。
- `1.6.27.1` 到 `1.6.27.17` 全部子节均有 Wave 绑定。

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 208 |
| constraint | 108 |
| behavior_oracle | 42 |
| environment | 20 |
| 总计 | 378 |

所有 facts 均为 `confirmed`，全库 ID 唯一；所有 open questions 均为 `open`，全库 ID 唯一。

## Wave索引

| Wave | 物理页 | 子节 | Facts | Open questions |
|---|---|---|---:|---:|
| [2B-1](CORE_SYSTEM_ADMIN_WAVE2B1_V1.md) | 592–596 | 1.6.27.1–1.6.27.3 | 20 | 2 |
| [2B-2](CORE_SYSTEM_ADMIN_WAVE2B2_V1.md) | 597–617 | 1.6.27.4–1.6.27.5 | 30 | 2 |
| [2B-3](CORE_SYSTEM_ADMIN_WAVE2B3_V1.md) | 618–629 | 1.6.27.6–1.6.27.8 | 20 | 2 |
| [2B-4](CORE_SYSTEM_ADMIN_WAVE2B4_V1.md) | 627–642 | 1.6.27.9–1.6.27.10 | 28 | 2 |
| [2B-5A](CORE_SYSTEM_ADMIN_WAVE2B5A_V1.md) | 641–661 | 1.6.27.10 | 21 | 2 |
| [2B-5B](CORE_SYSTEM_ADMIN_WAVE2B5B_V1.md) | 661–674 | 1.6.27.10 | 29 | 3 |
| [2B-6](CORE_SYSTEM_ADMIN_WAVE2B6_V1.md) | 674–695 | 1.6.27.11 | 25 | 2 |
| [2B-7](CORE_SYSTEM_ADMIN_WAVE2B7_V1.md) | 696–714 | 1.6.27.12–1.6.27.13 | 28 | 2 |
| [2B-8](CORE_SYSTEM_ADMIN_WAVE2B8_V1.md) | 715–737 | 1.6.27.14–1.6.27.15 | 17 | 2 |
| [2B-9](CORE_SYSTEM_ADMIN_WAVE2B9_V1.md) | 738–746 | 1.6.27.16 | 11 | 2 |
| [2B-10](CORE_SYSTEM_ADMIN_WAVE2B10_V1.md) | 746–755 | 1.6.27.17 | 29 | 2 |
| [2B-11](CORE_SYSTEM_ADMIN_WAVE2B11_V1.md) | 756–764 | 1.6.27.17 | 35 | 2 |
| [2B-12](CORE_SYSTEM_ADMIN_WAVE2B12_V1.md) | 765–777 | 1.6.27.17 | 26 | 2 |
| [2B-13](CORE_SYSTEM_ADMIN_WAVE2B13_V1.md) | 777–788 | 1.6.27.17 | 25 | 2 |
| [2B-14](CORE_SYSTEM_ADMIN_WAVE2B14_V1.md) | 788–795 | 1.6.27.17 | 13 | 2 |
| [2B-15](CORE_SYSTEM_ADMIN_WAVE2B15_V1.md) | 795–804 | 1.6.27.17 | 21 | 2 |

## 机器校验内容

汇总脚本会校验：

- 16个 Wave manifest 存在且 `id` 正确。
- 每个 manifest 的 facts YAML 哈希未漂移。
- 每个 manifest 的 resolved source 文件哈希未漂移。
- manifest 与 facts 的 facts / open questions 计数一致。
- 所有 Wave 共享同一 catalog 与 chapter hash。
- 页面并集完整覆盖 catalog 的 592–804。
- 全局 facts 和 open questions ID 唯一。
- 17个子节全部有抽取绑定。

## 产物

```text
generated/core_system_admin_wave2b_summary_v1/summary.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b_summary.py
python scripts/build_core_system_admin_wave2b_summary.py --check
python -m pytest -q tests/test_core_system_admin_wave2b_summary.py
```

## 边界

- 本汇总只审计静态抽取覆盖，不判定原文中每个函数都已有可执行SQL。
- 33个 open questions 仍需授权环境和实机验证。
- `confirmed` 表示原文事实确认，不表示 runtime verified。
- 本轮不连接数据库、不执行任何系统管理函数。
