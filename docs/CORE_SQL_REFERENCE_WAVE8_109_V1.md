# SQL Reference Wave 8-109 Extraction V1

## 目标

抽取 M 兼容 CREATE 族第一批：`CREATE EXTENSION`、`CREATE FUNCTION`、`CREATE GROUP` 与 `CREATE INDEX`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- CREATE EXTENSION：不支持用户使用、enable_extension前置、@extschema@特殊字符约束、control文件机制、FROM old_version升级
- CREATE FUNCTION：函数名/参数63字节、argmode规则（仅OUT后VARIADIC、OUT/INOUT禁RETURNS TABLE）、重载四禁、PUBLIC默认执行权与收回、AUTHID默认值、proc_outparam_override行为与out限制（SQL禁调/SELECT INTO禁/嵌套禁/SETOF失效/表达式场景）、复合类型返回跨schema规则、GUC变更行为残留风险、默认参数错位填充
- CREATE GROUP：CREATE ROLE别名、option全集、ADD/DROP USER/RENAME示例
- CREATE INDEX：建索引四原则、immutable强制、LOCAL/GLOBAL默认规则（UNIQUE含全部分区键→LOCAL）、GLOBAL禁表达式索引、32/31列上限、8k页面限制、BTREE/UBTREE自动转换、前缀键（2676上限、二进制字节/字符数）、varchar_pattern_ops、LOCAL分区数=表分区数基线

## Open questions

| ID | 内容 |
|---|---|
| `m_create_wave8_109_oq_runtime` | M兼容函数重载在混合类型入参下的解析规则、表达式索引immutable校验边界、LOCAL/GLOBAL索引在分区维护操作后的实际查询路径需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_109_v1.yaml
generated/core_sql_reference_wave8_109_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_109.py
python scripts/build_core_sql_reference_wave8_109.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_109.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容CREATE语句。
