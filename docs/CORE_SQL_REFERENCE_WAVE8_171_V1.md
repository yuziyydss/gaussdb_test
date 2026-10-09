# SQL Reference Wave 8-171 Extraction V1

## 目标

抽取 高级包第二十三批切片：`3.12.2.23 DBE_XMLDOM` 第二切片——属性/检索/导航/转换族（页 3011–3027）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3011–3027） |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GETLENGTH双原型（map/nodelist）与两组计数基线
- GETLOCALNAME三原型（ATTR/ELEMENT返回、NODE存储过程OUT形式）
- GETNAMEDITEM双原型（name / name+ns；NULL可传但不可缺省、32767上限、int类型127位说明）
- GETNEXTSIBLING/GETNODENAME/GETNODETYPE（DOCUMENT=9/#document）/GETNODEVALUE/GETPARENTNODE/GETTAGNAME/HASCHILDNODES
- IMPORTNODE（deep递归语义、12种constants外抛异常、跨文档合并XML基线）
- ISNULL多类型原型、ITEM双原型（map对bool/clob默认指向第一个index）
- MAKEELEMENT/MAKENODE四原型（return语法限制建议）与id输出基线
- NEWDOMDOCUMENT（尾部边界）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_171_oq_runtime` | IMPORTNODE对12种constants之外类型的具体报错码、ITEM的map版对bool/clob入参默认指向第一个index的实现语义、MAKENODE的doc.id与dom_node.id编码差异含义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_171_v1.yaml
generated/core_sql_reference_wave8_171_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_171.py
python scripts/build_core_sql_reference_wave8_171.py --check
python -m unittest tests.test_core_sql_reference_wave8_171 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作XML文档。
