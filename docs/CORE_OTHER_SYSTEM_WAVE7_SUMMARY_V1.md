# Core Other System Functions Wave 7 Summary V1

## 目标

汇总 `1.6.60 其他系统函数` 的 Wave 7-9 与 Wave 7-10 静态抽取结果。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1.6.60 其他系统函数 |
| 物理页 | 1058–1114，共57页 |
| Wave数 | 2 |
| 结构化 facts | 51 |
| Open questions | 4 |
| 页面覆盖 | 57 / 57 |

## Wave索引

| Wave | 物理页 | Facts | Open questions | 文档 |
|---|---|---:|---:|---|
| 7-9 | 1058–1075 | 13 | 2 | [CORE_OTHER_SYSTEM_PG_COMPAT_WAVE7_9_V1.md](CORE_OTHER_SYSTEM_PG_COMPAT_WAVE7_9_V1.md) |
| 7-10 | 1076–1114 | 38 | 2 | [CORE_OTHER_SYSTEM_INTERNAL_WAVE7_10_V1.md](CORE_OTHER_SYSTEM_INTERNAL_WAVE7_10_V1.md) |

## 覆盖结论

- 页面并集完整覆盖1058–1114。
- 无页面缺失，也无额外页面。
- 两个批次在页1075/1076无缝衔接，无页级重叠。
- 所有facts全局ID唯一且为confirmed；所有open questions全局ID唯一且为open。

## Fact分布

| 类型 | 数量 |
|---|---:|
| syntax | 45 |
| environment | 5 |
| constraint | 1 |
| 总计 | 51 |

## 产物与校验

```text
generated/core_other_system_wave7_summary_v1/summary.json
```

```bash
python scripts/build_core_other_system_wave7_summary.py
python scripts/build_core_other_system_wave7_summary.py --check
python -m pytest -q tests/test_core_other_system_wave7_summary.py
```

## 边界

- 本汇总只审计静态抽取覆盖，不判定每个函数都有可执行SQL。
- 4个open questions仍需授权环境和实机验证。
- confirmed表示原文事实确认，不表示runtime verified。
