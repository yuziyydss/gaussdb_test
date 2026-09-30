# Stored Procedure Wave 8-5 Extraction V1

## 目标

抽取 `3.17 存储过程的字节码执行框架` 与 `3.18 关键字`，补齐字节码执行能力、表达式覆盖和关键字边界。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `3.17` | 24 | 字节码执行框架 |
| `3.18` | 6 | 关键字 |
| 合计（去重） | **24** | **2章** |

> 页3127-3132由 `3.17` 收尾和 `3.18` 起始共享；manifest按章节切片记录，页级统计去重后为24页。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 24 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 字节码定义与执行路径
- `plsql_code_type` 与 `behavior_compat_options`
- 不支持的DFX、PACKAGE、匿名块、TRIGGER等
- 表达式类型、操作符、条件表达式、复合类型构造器
- `NULLIF`、布尔测试、数组/集合构造器、XML表达式
- 存储过程关键字分类
- 保留字、非保留字和SQL关键字边界

## Open questions

| ID | 内容 |
|---|---|
| `sp_bytecode_wave8_5_oq_runtime` | 字节码与传统AST框架在复杂表达式、异常、包和关键字边界场景下的执行结果矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_stored_procedure_wave8_5_v1.yaml
generated/core_stored_procedure_wave8_5_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_stored_procedure_wave8_5.py
python scripts/build_core_stored_procedure_wave8_5.py --check
python -m pytest -q tests/test_core_stored_procedure_wave8_5.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行字节码或关键字语句。
