# SQL Reference Wave 8-126 Extraction V1

## 目标

抽取 M 兼容 `JSON 函数和操作符`（2.5.12，18 页单节成批，覆盖 25 个 JSON 函数与 JSON 操作符）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- JSON_APPEND（ARRAY_APPEND别名）/ARRAY_APPEND/ARRAY_INSERT/INSERT/SET/REPLACE/REMOVE增删改语义与path不存在差异
- JSON_EXTRACT多path数组拼接、JSON_SEARCH/CONTAINS/CONTAINS_PATH查询校验
- JSON_MERGE/JSON_MERGE_PATCH(RFC 7396)/JSON_MERGE_PRESERVE三种合并语义差异
- JSON_DEPTH/LENGTH/KEYS/STORAGE_SIZE/TYPE/VALID元信息函数
- JSON_OBJECT/PRETTY/QUOTE/UNQUOTE构造与格式化
- JSON操作符->（带引号）与->>（不带引号）、::JSON与cast_as_new_json关联
- JSON比较操作符与类型排序规则（OPAQUE>...>NULL优先级链、标量/数组/对象比较细则）
- 深度100限制、null与格式错误按异常先后顺序处理等通用规则

## Open questions

| ID | 内容 |
|---|---|
| `m_json_wave8_126_oq_runtime` | M兼容JSON函数深度100限制的具体构成、->>操作符cast_as_new_json对::JSON转换类型的影响、JSON排序规则在嵌套数组与对象混合场景的实际排序需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_126_v1.yaml
generated/core_sql_reference_wave8_126_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_126.py
python scripts/build_core_sql_reference_wave8_126.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_126.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容JSON语句。
