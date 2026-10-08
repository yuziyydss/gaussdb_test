# SQL Reference Wave 8-37 Extraction V1

## 目标

抽取 `1.13.9.23 CREATE FUNCTION`，补齐函数创建语法、权限、OUT/INOUT、重载、语言和函数属性能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.23` | 12 | CREATE FUNCTION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- PostgreSQL/Oracle两种函数创建风格
- 精度检测、Schema/search_path和当前Schema恢复边界
- `proc_outparam_override`、OUT出参生效与表达式场景限制
- PUBLIC默认执行权限、`CREATE ANY FUNCTION`和安全模式
- 重载、同名冲突、PACKAGE与pg_proc解析规则
- OUT参数在SQL、SELECT INTO、嵌套调用和表达式中的限制
- 复合类型RETURN、跨Schema/跨DATABASE边界
- OUT参数长度传递和精度类型限制
- 参数默认值、`%TYPE`/`%ROWTYPE`、RETURNS/RETURNS TABLE
- LANGUAGE、WINDOW、internal函数
- IMMUTABLE/STABLE/VOLATILE、SHIPPABLE、PACKAGE
- LEAKPROOF、STRICT、SECURITY模式、COST/ROWS/SET和函数体边界

## Open questions

| ID | 内容 |
|---|---|
| `func_wave8_37_oq_runtime` | CREATE FUNCTION在真实Schema、权限、OUT/INOUT、重载、WINDOW和内部函数组合下的创建、调用与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_37_v1.yaml
generated/core_sql_reference_wave8_37_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_37.py
python scripts/build_core_sql_reference_wave8_37.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_37.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE FUNCTION或DDL。
