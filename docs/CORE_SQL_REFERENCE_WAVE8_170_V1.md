# SQL Reference Wave 8-170 Extraction V1

## 目标

抽取 高级包第二十二批切片：`3.12.2.23 DBE_XMLDOM` 第一切片——类型/构建/释放/导航族（页 2995–3010）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2995–3010） |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 七种DOM数据类型（DOMATTR/DOMDOCUMENT/DOMELEMENT/DOMNAMEDNODEMAP/DOMNODELIST/DOMNODE/DOMTEXT）与SQL_ASCII字符集限制
- 41接口总账
- APPENDCHILD（ATTR挂载差异：operation not support、KEY重复禁止、HASCHILDNODES基线）
- CREATEELEMENT双原型（NULL/空tagName异常、32767长度上限）
- FREE四接口（FREEDOCUMENT/FREEELEMENT/FREENODE/FREENODELIST）与FREENODE后A库差异
- 导航族：GETATTRIBUTE（ns不支持*）/GETATTRIBUTES/GETCHILDNODES/GETCHILDRENBYTAGNAME/GETDOCUMENTELEMENT/GETFIRSTCHILD/GETLASTCHILD
- 示例基线（students导航、NOT NULL/IS NULL对比）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_170_oq_runtime` | APPENDCHILD挂载ATTR后HASCHILDNODES返回false的语义与A库差异影响、FREENODE后被释放节点被其他接口调用时的具体报错形态、CREATETEXTNODE在DOCTYPE场景输出there is nothing的条件需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_170_v1.yaml
generated/core_sql_reference_wave8_170_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_170.py
python scripts/build_core_sql_reference_wave8_170.py --check
python -m unittest tests.test_core_sql_reference_wave8_170 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作XML文档。
