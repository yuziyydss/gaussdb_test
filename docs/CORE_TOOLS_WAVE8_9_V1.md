# Tools Wave 8-9 Extraction V1

## 目标

抽取 `5.9 数据库升级工具`，补齐热补丁、升级方式、升级命令与回滚能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.9` | 36 | 数据库升级工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 36 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- `gs_hotpatch` 命令集和单节点边界
- 就地/灰度/滚动升级
- `gs_upgradectl` 命令族
- 灰度升级节点数与主机选择
- upgrade/rollback/commit 边界
- 容灾升级 `--force_commit` / `--hadr_force`
- `omRollback.py`

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_9_oq_runtime` | 就地升级、灰度升级、滚动升级和组件升级在真实集群、容灾与故障注入场景下的边界行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_9_v1.yaml
generated/core_tools_wave8_9_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_9.py
python scripts/build_core_tools_wave8_9.py --check
python -m pytest -q tests/test_core_tools_wave8_9.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行升级工具。
