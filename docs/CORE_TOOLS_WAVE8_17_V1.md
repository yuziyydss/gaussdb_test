# Tools Wave 8-17 Extraction V1

## 目标

抽取 `5.2 安装/卸载工具`，补齐数据库初始化、安装、预安装、卸载和环境清理能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.2` | 30 | 安装/卸载工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 30 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 工具概览：`gs_initdb`、`gs_install`、`gs_postuninstall`、`gs_preinstall`、`gs_uninstall`
- `gs_initdb` 初始化、模板库、认证方法和目录权限
- `gs_install` 前置条件、配置文件、2副本建议和初始用户密码边界
- `gs_postuninstall` 用户/用户组/虚拟IP清理
- `gs_uninstall` 卸载命令与日志路径

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_17_oq_runtime` | 多节点安装、卸载和环境清理的真实行为矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_17_v1.yaml
generated/core_tools_wave8_17_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_17.py
python scripts/build_core_tools_wave8_17.py --check
python -m pytest -q tests/test_core_tools_wave8_17.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行安装或卸载工具。
