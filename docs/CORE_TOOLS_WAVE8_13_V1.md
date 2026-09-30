# Tools Wave 8-13 Extraction V1

## 目标

抽取 `5.5 数据库性能监控工具`，补齐 `gs_checkos`、`gs_cgroup`、`gs_check` 和 `gstrace` 能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.5` | 41 | 数据库性能监控工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 41 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 四个性能监控工具概览
- `gs_checkos` 检查项、前置条件、输出和日志
- `gs_cgroup` 资源控制组管理
- `gs_check` 统一检查
- `gstrace` 采集、dump、分析、模块过滤和共享内存边界

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_13_oq_runtime` | 真实集群/高负载环境下的检查项、资源控制和trace性能分析需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_13_v1.yaml
generated/core_tools_wave8_13_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_13.py
python scripts/build_core_tools_wave8_13.py --check
python -m pytest -q tests/test_core_tools_wave8_13.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行监控工具。
