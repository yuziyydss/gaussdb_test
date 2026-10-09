# SQL Reference Wave 8-176 Extraction V1

## 目标

抽取 M 兼容参考与报表章：`第9章 系统表和系统视图-M-Compatibility`、`第12章 WDR报告`、`第13章 ASP报告`（页 5423–5686）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整章） |
| 物理页 | 31 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- Ch9 M-Compatibility系统表/视图：继承GaussDB原有系统表、小写查询规则、information_schema例外、gs_masking/gs_seclabels/pg_seclabels空视图说明、十二分类视图清单
- Ch12 WDR报告：14种报表全列（Database Stat 19列/PDB Info/Load Profile 18指标/Efficiency 5比率/Top Events/Wait Classes四类/Host CPU/IO Profile/Memory/Time Model 10指标/SQL Statistics 40列/Wait Events）
- Ch13 ASP报告：Report Header/System Load/Top Client（含后台与外部客户端清单）/Active Sessions/Top Events Summary/Graph/Sessions with Top event/Slots 分片展示

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_176_oq_runtime` | M-Compatibility模式 gs_masking/gs_seclabels/pg_seclabels 空视图在后续版本是否启用、WDR PDB Info在单机模式的输出格式、ASP报告在PDB场景的采样范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_176_v1.yaml
generated/core_sql_reference_wave8_176_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_176.py
python scripts/build_core_sql_reference_wave8_176.py --check
python -m unittest tests.test_core_sql_reference_wave8_176 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不生成报表。
