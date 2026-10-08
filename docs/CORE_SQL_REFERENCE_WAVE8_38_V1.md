# SQL Reference Wave 8-38 Extraction V1

## 目标

抽取 `1.13.9.37 CREATE PROCEDURE`，补齐存储过程创建语法、权限、OUT/INOUT、重载、依赖对象和END名称边界。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.37` | 7 | CREATE PROCEDURE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE PROCEDURE主语法与函数属性
- 精度检测、Schema/search_path和锁行为
- OUT参数调用、变量约束和表达式失效场景
- PACKAGE重载、同名冲突、默认值与IN/OUT重载规则
- A/PG风格、未声明变量、RETURN集合与聚集嵌套限制
- 参数注释、IS/AS与函数体之间注释
- `CREATE ANY FUNCTION`和安全模式
- `proc_outparam_override`、PERFORM和DBE_SQL影响
- 依赖对象创建、REPLACE限制和三权分立重建
- OUT参数长度传递及集合元素长度开关
- 参数模式、默认值、`%TYPE`/`%ROWTYPE`
- `END;`与`END procedure_name;`约束

## Open questions

| ID | 内容 |
|---|---|
| `proc_wave8_38_oq_runtime` | CREATE PROCEDURE在真实Schema、权限、OUT/INOUT、重载、依赖对象和安全模式组合下的创建、调用与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_38_v1.yaml
generated/core_sql_reference_wave8_38_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_38.py
python scripts/build_core_sql_reference_wave8_38.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_38.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE PROCEDURE或DDL。
