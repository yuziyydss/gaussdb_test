# Logs Wave 8-11 Extraction V1

## 目标

抽取 `6 日志参考`，补齐日志类型、路径、格式、清理和内存日志机制。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `6` | 26 | 日志参考 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 26 |
| 结构化 facts | 26 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 系统日志、操作日志、审计日志、WAL日志、内存日志
- 各类日志默认路径
- DN/CM/om 日志格式
- 告警日志字段和清除类型
- 系统日志丢弃机制
- 操作日志轮转
- WAL 复用和清理
- 内存日志触发机制

## Open questions

| ID | 内容 |
|---|---|
| `logs_wave8_11_oq_runtime` | 真实部署下各日志路径、审计输出、WAL清理和内存日志触发行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_logs_wave8_11_v1.yaml
generated/core_logs_wave8_11_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_logs_wave8_11.py
python scripts/build_core_logs_wave8_11.py --check
python -m pytest -q tests/test_core_logs_wave8_11.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不读取日志文件。
