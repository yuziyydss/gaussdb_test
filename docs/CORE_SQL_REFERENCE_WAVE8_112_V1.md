# SQL Reference Wave 8-112 Extraction V1

## 目标

抽取 M 兼容 `CREATE TABLE PARTITION`（2.4.2.8.17，15 页单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 四种分区方案定位与PARTITION BY四形式（RANGE/LIST/HASH/KEY + PARTITIONS自动生成）
- 分区三优势（查询剪枝/连续扫描/批量装卸避免VACUUM超载）
- 硬限制：1048575分区上限/建议400、哈希单列键、九类LOB/BIT禁作分区键、指定分区不走全局索引
- 并发UPDATE/DELETE跨分区报错机理与三条优化建议
- 约束键含全部分区键→LOCAL否则GLOBAL
- START END五规则（p1_0自动分区、START<END、END=下一START、禁混用、gs_dump转LESS THAN、仅1列）
- LIST 16键/64值、LESS THAN括号外MAXVALUE单键
- 字符序含gb18030_2022两种（比CREATE TABLE多）
- 生成列分区键交互与精度差异基线（mm1/mm2对照）
- RANGE/LIST/HASH三组示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_ctp_wave8_112_oq_runtime` | 分区表并发UPDATE/DELETE报错的具体触发概率与错误码、指定分区语句不走全局索引扫描的执行计划表现、START END与LESS THAN混用禁令的解析器行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_112_v1.yaml
generated/core_sql_reference_wave8_112_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_112.py
python scripts/build_core_sql_reference_wave8_112.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_112.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容分区表语句。
