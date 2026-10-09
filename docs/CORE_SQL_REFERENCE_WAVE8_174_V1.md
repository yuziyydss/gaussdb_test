# SQL Reference Wave 8-174 Extraction V1

## 目标

抽取 高级包第二十五批切片：`3.12.2.25 DBE_XMLPARSER`（XML反序列化7接口）与 `3.12.2.26 PRVT_ILM`（ILM内部接口清单，页 3068–3077）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3068–3077，两个完整小节） |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_XMLPARSER：SQL_ASCII报错、仅A兼容、存储上限16777215；七接口全原型（FREEPARSER/GETDOCUMENT三种null语义/GETVALIDATIONMODE默认开启/NEWPARSER/PARSEBUFFER/PARSECLOB 2GB限制/SETVALIDATIONMODE空值不改）
- PARSECLOB与A数据库五类差异（UTF8/version/DTD/命名空间/预定义实体）
- 验证模式示例基线（false正常解析保留DOCTYPE、true报invalid XML document）
- PRVT_ILM：内部接口29个名称清单（维护窗口/评估/帮助函数/序列/状态刷新）、帮助函数映射关系、废弃接口（compress_block_single/eval_comp_relgrowth）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_174_oq_runtime` | PARSECLOB对2GB边界clob的报错形态、XMLPARSER数据类型16777215上限耗尽行为、PRVT_ILM内部接口在ILM调度故障时的自恢复语义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_174_v1.yaml
generated/core_sql_reference_wave8_174_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_174.py
python scripts/build_core_sql_reference_wave8_174.py --check
python -m unittest tests.test_core_sql_reference_wave8_174 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不解析XML。
