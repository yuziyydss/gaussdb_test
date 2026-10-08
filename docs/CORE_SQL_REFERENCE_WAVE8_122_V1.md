# SQL Reference Wave 8-122 Extraction V1

## 目标

抽取 M 兼容 `比较函数和比较操作符` 与 `数字操作函数和算术操作符`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 比较操作符索引支持限制（btree/ubtree、<>/<=>禁索引扫描、<=>禁hash/合并连接/行比较）
- 行表达式与NULL比较及<=>行比较报错基线
- 六种基础比较、<=>NULL安全等于、BETWEEN AND、IS/IS NOT TRUE/FALSE/UNKNOWN、IS NULL/IS NOT NULL
- SOUNDS LIKE（SOUNDEX语音比较，英文限定）
- COALESCE类型推导、GREATEST
- 算术七操作符与示例、除法精度div_precision_increment=4规则、无符号运算与NO_UNSIGNED_SUBTRACTION
- 操作数提升与结果类型表2-42~2-47
- 三角/反三角/对数/指数/幂/随机/舍入/符号/截断等31个函数语义与返回类型
- 生成列精度差异基线（enable_precision_decimal开关对照）

## Open questions

| ID | 内容 |
|---|---|
| `m_cmp_num_wave8_122_oq_runtime` | M兼容<=>与行表达式组合的报错边界、算术结果类型表在UNSIGNED混算下的溢出行为、ROUND受m_format_behavior_compat_options影响的具体规则需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_122_v1.yaml
generated/core_sql_reference_wave8_122_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_122.py
python scripts/build_core_sql_reference_wave8_122.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_122.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容比较/算术语句。
