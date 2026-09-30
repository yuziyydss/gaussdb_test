# Tools Wave 8-8 Extraction V1

## 目标

抽取 `5.8 数据库扩/缩容工具`，补齐 `gs_expand`、`gs_redis`、`gs_redis_bucket`、`gs_shrink` 的静态事实。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.8` | 17 | 数据库扩/缩容工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 扩/缩容工具概览
- `gs_expand` 升副本状态与副本上限
- License/ETCD/AZ 配置约束
- 主机 locale/encoding 与依赖对象锁
- `gs_expand` 扩容、重分布、回滚、资源管控
- 重分布失败/追增阈值和锁等待边界
- 重分布并行度、锁等待、追增与多表join配置

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_8_oq_runtime` | 真实集群下的扩/缩容边界、副本切换和数据重分布性能需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_8_v1.yaml
generated/core_tools_wave8_8_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_8.py
python scripts/build_core_tools_wave8_8.py --check
python -m pytest -q tests/test_core_tools_wave8_8.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行扩/缩容工具。
