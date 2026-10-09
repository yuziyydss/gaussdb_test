# SQL Reference Wave 8-192 Extraction V1

## 目标

抽取 MySQL兼容M模式SQL概述/关键字/标识符：`4.4.2.7.1 SQL兼容性概述` + `4.4.2.7.2 关键字` + `4.4.2.7.3 标识符`（表4-162，页 3403–3410）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整节合并） |
| 物理页 | 7 |
| 结构化 facts | 12 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- SQL兼容性概述（4.4.2.7.1）：受限标识符列表（表4-162：COLLATION/COMPACT/BIT/BOOLEAN/.../ANY/ARRAY/...）；优化器差异WARNING计数（cast调用次数差异）
- 关键字（4.4.2.7.2）：6种关键字类型组合的约束差异规则；不能作列别名的关键字列表（BETWEEN/BIGINT/BLOB/.../WITHOUT，其中SIGNED/WITHOUT在MySQL可作列别名）
- 标识符（4.4.2.7.3）：$开头标识符差异；大小写敏感差异；U+0080~U+00FF vs U+0080~U+FFFF扩展字符；数字开头含e/E标识符差异；纯数字/科学计算法列名引号使用；空反引号/空双引号别名差异；分区名大小写差异；标识符长度63字节 vs 64字符；可执行注释不支持

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_192_oq_runtime` | 优化器差异WARNING计数/标识符截断/空反引号别名CREATE VIEW后续使用报错等差异的完整影响范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_192_v1.yaml
generated/core_sql_reference_wave8_192_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_192.py
python scripts/build_core_sql_reference_wave8_192.py --check
python -m unittest tests.test_core_sql_reference_wave8_192 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
