# Core XML Wave 7-8 Extraction V1

## 目标

细抽并一次性完成XML两个章节：

```text
1.6.43 XML类型函数
1.6.44 XMLTYPE类型函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 2 |
| 物理页并集 | 952–980，共29页 |
| 结构化 facts | 29 |
| Open questions | 2 |
| Source resolved | 2 / 2 |
| Facts bound to scope | 29 / 29 |

## 覆盖内容

### XML类型函数

- 解析与序列化：`xmlparse`、`xmlserialize`
- 构造与聚合：`xmlcomment`、`xmlconcat`、`xmlelement`、`xmlattributes`、`xmlforest`、`xmlpi`、`xmlroot`、`xmlagg`
- 校验与查询：`xmlexists`、`xml_is_well_formed*`、`xpath`、`xpath_exists`
- 对象映射：`query_to_xml*`、`cursor_to_xml*`、`schema_to_xml*`、`database_to_xml*`、`table_to_xml*`
- 值与转换：`getclobval`、`getstringval`、`xmlsequence`、`xmlcast`

关键边界：

- XML嵌套层数最大256层。
- `xmlelement`/`xmlattributes`的NULL name行为与A数据库不一致。
- XPath相关函数仅支持`xpath`和`xpath_exists`；不支持XQuery、XML extension和XSLT。
- `xmlcast`仅A兼容模式支持，升级观察期不支持。

### XMLTYPE类型函数

- 构造：`createxml`、`xmltype`
- 值/元素提取：`getblobval`、`getclobval`、`getnumberval`、`getstringval`、`getrootelement`、`getnamespace`
- 判断与路径：`isfragment`、`existsnode`、`extractxml`、`extractvalue`
- 序列、转换和查询：`xmlsequence`、`xmlcast`、`xmlquery`

关键边界：

- blob入参最大256MB-1。
- PL/SQL中空串构造返回NULL。
- 字符串encoding仅支持UTF-8、GBK、ZHS16GBK、LATIN1~LATIN10。
- XPath仅支持1.0；不支持XQuery表达式。
- `xmlquery`仅A兼容模式支持，升级观察期不支持。

## Open questions

| ID | 内容 |
|---|---|
| `xml_wave7_8_oq_construct_xpath_matrix` | XML构造、序列化、XPath/extract在不同xmloption、兼容参数、命名空间和多层嵌套下的行为矩阵 |
| `xmltype_wave7_8_oq_mapping_cast_evidence` | 对象/表/库到XML映射以及xmlcast/xmlquery在大结果集、多命名空间和升级观察期下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_xml_wave7_8_v1.yaml
generated/core_xml_wave7_8_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_xml_wave7_8.py
python scripts/build_core_xml_wave7_8.py --check
python -m pytest -q tests/test_core_xml_wave7_8.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不构造XML、不执行XPath、不修改词典、不导出Schema/数据库XML。
- 不宣称目标环境行为验证通过。
