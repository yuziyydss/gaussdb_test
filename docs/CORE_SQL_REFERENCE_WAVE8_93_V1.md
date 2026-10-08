# SQL Reference Wave 8-93 Extraction V1

## 目标

抽取 C 族收官批：`CREATE TYPE`、`CREATE WEAK PASSWORD DICTIONARY` 与 `CURSOR`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.57` | 9 | CREATE TYPE |
| `1.13.9.61` | 2 | CREATE WEAK PASSWORD DICTIONARY |
| `1.13.9.62` | 3 | CURSOR |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 14 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CREATE TYPE五种类型定位（复合/基本/shell/枚举/集合）与USAGE特权要求
- 模式归属、重名限制、所有者、CREATE ANY TYPE、仅行存表、关联函数风险
- 复合类型%RowType/%Type间接引用与pg_collation排序规则
- 复合类型构造器=>赋值仅A模式且必须连续到结尾、非连续报错基线
- 基本类型完整参数清单与I/O必选规则
- input/output/receive/send/typmod/analyze函数签名与STRICT/BYTEA/CSTRING约束
- shell type三步定义流程、INTERNAL系统函数一致性约束
- INTERNALLENGTH/PASSEDBYVALUE/ALIGNMENT/STORAGE四种存储策略语义
- 枚举63字节标签、集合TABLE OF、自动关联数组类型（下划线前缀）
- compfoo/bugstatus全生命周期行为基线
- 弱口令字典语法、gs_global_config存储、三类管理员权限、重复保留一条、清空基线
- CURSOR语法（BINARY/NO SCROLL/WITH HOLD）、事务块限制、文本/二进制格式差异
- NO SCROLL并发执行建议、cmdsql不支持SCROLL、WITH HOLD跨事务行为基线
- 静态游标参数默认值不能引用包外变量、查询对象依赖关系不支持

## Open questions

| ID | 内容 |
|---|---|
| `create_type_wpd_cursor_wave8_93_oq_runtime` | 自定义基本类型I/O/二进制函数组合在真实数据下的行为、复合类型构造器=>赋值边界、弱口令字典与口令复杂度策略联动、二进制游标与WITH HOLD跨事务语义在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_93_v1.yaml
generated/core_sql_reference_wave8_93_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_93.py
python scripts/build_core_sql_reference_wave8_93.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_93.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行类型/弱口令字典/游标语句。
