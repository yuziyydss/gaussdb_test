# Tools Wave 8-15 Extraction V1

## 目标

抽取 `5.6 备份/恢复工具`，补齐 Roach、`gs_backup`、`gs_finishredo_retrieve` 和容灾切换相关能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.6` | 97 | 备份/恢复工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 97 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- Roach备份/恢复/停止/删除/归档/快照
- 磁盘、OBS、NAS、REMOTE介质
- 元数据路径与REMOTE必要参数
- 管理员权限与恢复期动态库行为
- `gs_backup` 参数/二进制备份与恢复
- `gs_finishredo_retrieve` Xlog找回

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_15_oq_runtime` | Roach、gs_backup和Xlog找回在真实集群、OBS/NAS/REMOTE介质和容灾边界下的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_15_v1.yaml
generated/core_tools_wave8_15_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_15.py
python scripts/build_core_tools_wave8_15.py --check
python -m pytest -q tests/test_core_tools_wave8_15.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行备份恢复工具。
