# SQL Reference Wave 8-146 Extraction V1

## 目标

抽取 高级包第五批切片：`3.12.1.3 DBE_XML`（页 2692–2715，解析器与DOM接口，3.12.1 基础接口收官）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2692–2715） |
| 物理页 | 24 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 接口总账：PARSER类7个 + DOM构建释放类13个 + 属性节点信息类26个 + 输出类6个 + 会话诊断类3个
- PARSER生命周期：NEW_PARSER→PARSE→GET_DOC→FREE，默认开启DTD验证、validate空值不改变模式
- XML_PARSE_BUFFER（32767上限）/XML_PARSE_CLOB（不支持≥2GB）与A数据库五类差异（UTF-8、version、DTD、命名空间、预定义实体）
- DOM构建/释放/导航/节点信息/检索/属性/类型转换/IMPORT_NODE 全原型
- SET_CHARSET/SET_DOCTYPE/SET_NODE_VALUE 元信息设置
- WRITE_TO_BUFFER/CLOB/FILE 六输出函数（FILE双原型带charset）
- 会话诊断三函数（dom树数量/内存占用/子节点明细）
- RAW(13)句柄约定与FREE_*释放要求

## Open questions

| ID | 内容 |
|---|---|
| `dbexml_wave8_146_oq_runtime` | XML_PARSE_BUFFER 32767长度边界与UTF-8多字节字符的截断行为、DOM树内存占用（GET_DOC_TREES_INFO）在大量FREE_*调用后的回收时机、WRITE_TO_FILE_DOC在safe_data_path白名单外路径的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_146_v1.yaml
generated/core_sql_reference_wave8_146_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_146.py
python scripts/build_core_sql_reference_wave8_146.py --check
python -m unittest tests.test_core_sql_reference_wave8_146 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不解析或写出XML文档。
