# Core Boundary Page Closure Wave 7-11 Extraction V1

## 目标

补齐顶层抽取总账中因章节边界造成的缺失页，覆盖位串、UUID、ROWID、字符集/字符序、常量与函数概述、BPCHAR匹配、系统操作和SHUTDOWN。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 8 |
| Unique pages | 13 |
| 结构化 facts | 12 |
| Open questions | 1 |
| Source resolved | 8 / 8 |
| Facts bound to scope | 12 / 12 |

## 覆盖内容

- 位串类型的定长/变长边界与显式转换规则。
- UUID类型章节边界。
- ROWID与BPCHAR/VARCHAR/NVARCHAR2/TEXT的显式转换。
- 字符集、字符序、默认字符序、utf8mb4/utf8和binary/SQL_ASCII等同关系。
- B模式多级字符集/字符序支持，以及暂不支持混合使用的边界。
- client/server/character_set_results编码转换与非法编码报错。
- 字符序优先级、冲突处理和二进制比较退化规则。
- 字符串类型与ARRAY/XML/JSON/TSVECTOR的字符集边界。
- 系统操作总览与SHUTDOWN。

## Open questions

| ID | 内容 |
|---|---|
| `boundary_wave7_11_oq_cast_and_mode_matrix` | 位串/ROWID转换、B模式字符序和BPCHAR NOT LIKE在边界值、兼容模式与GUC开关下需授权环境验证 |

## 产物

```text
docs/compat_facts/core_boundary_wave7_11_v1.yaml
generated/core_boundary_wave7_11_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_boundary_wave7_11.py
python scripts/build_core_boundary_wave7_11.py --check
python -m pytest -q tests/test_core_boundary_wave7_11.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行转换、不修改字符集/字符序、不执行系统操作。
- 不宣称目标环境行为验证通过。
