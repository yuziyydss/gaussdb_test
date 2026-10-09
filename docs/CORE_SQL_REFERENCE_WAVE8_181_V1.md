# SQL Reference Wave 8-181 Extraction V1

## 目标

抽取 Oracle兼容性说明第二切片：`4.3.6 条件` + `4.3.7 JDBC驱动兼容`（Array/Struct，页 3155–3177）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3155–3177） |
| 物理页 | 23 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 条件兼容：比较条件（ANY/SOME/ALL差异）/逻辑/模式匹配/NULL/复合/BETWEEN/EXISTS/IN支持；浮点/模型/多集合/XML/IS OF TYPE不支持；SQL/JSON部分支持差异
- JDBC Array构造差异：createDescriptor vs getDescriptor、ARRAY vs GaussArray
- JDBC Array接口支持矩阵：6支持/6不支持
- getArray()返回类型逐类型对比（约20种元素类型）
- getBaseTypeName命名规则（package/schema/引号规则）
- Array元素入参类型差异（CHAR/TIMESTAMP/集合/RECORD等）
- 类型修饰符校验差异（GaussDB不做构造期校验）
- JDBC Struct：getAttributes()返回类型逐类型对比、getSQLTypeName差异、构造接口差异（CHAR补齐/NUMBER精度/BINARY_INTEGER截断/BOOLEAN类型映射）
- 精度丢失警告

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_181_oq_runtime` | JDBC Array在getResultSet不支持场景下的替代方案、GaussArray类型不一致时报错的具体错误码、getBaseTypeName大小写差异对已有应用的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_181_v1.yaml
generated/core_sql_reference_wave8_181_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_181.py
python scripts/build_core_sql_reference_wave8_181.py --check
python -m unittest tests.test_core_sql_reference_wave8_181 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
