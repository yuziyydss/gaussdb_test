# GUC Wave 8-10 Extraction V1

## 目标

抽取 `7.1 查看参数` 和 `7.2 设置参数`，建立 GUC/CM 参数查看、设置方式、优先级和单位边界事实。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `7.1` | 2 | 查看 GUC/CM 参数 |
| `7.2` | 5 | 设置 GUC/CM 参数 |
| 合计 | **6** | **2章** |

> 页4136由 `7.1` 收尾和 `7.2` 起始共享；manifest按章节切片记录，页级统计去重后为6页。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 6 |
| 结构化 facts | 23 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- `SHOW`、`SHOW ALL`、`pg_settings`
- `cm_ctl list --param`
- 参数类型、布尔值、枚举、浮点和单位
- `INTERNAL`、`POSTMASTER`、`SIGHUP`、`BACKEND`、`SUSET`、`USERSET`、`PDB_SIGHUP`
- SQL修改数据库级、用户级、会话级参数
- 参数设置优先级
- PDB参数设置与动态加载
- CM参数重启与reload

## Open questions

| ID | 内容 |
|---|---|
| `guc_wave8_10_oq_runtime` | 不同GUC/CM参数的实际生效优先级、单位解析和PDB动态加载行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_guc_wave8_10_v1.yaml
generated/core_guc_wave8_10_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_guc_wave8_10.py
python scripts/build_core_guc_wave8_10.py --check
python -m pytest -q tests/test_core_guc_wave8_10.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改参数。
