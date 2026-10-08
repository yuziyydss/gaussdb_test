# SQL Reference Wave 8-140 Extraction V1

## 目标

抽取 PL/SQL 基础批：`3.6 基本语句`（定义变量/赋值/调用）与 `3.7 动态语句`（动态查询/非查询/动态调用存储过程与匿名块）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 基本语句总则与密码泄露防护提示
- 变量声明、%TYPE/%ROWTYPE全用法（列/record成员/cursor/PACKAGE省略）与九条限制（allow_procedure_compile_check差异）
- 变量作用域三规则与覆盖示例
- 赋值语句/嵌套赋值（下标INT约束）、proc_outparam_override字段引用限制、INTO第一层列赋值限制
- INTO/BULK COLLECT INTO语法与STRICT、select_into_return_null、4层Record嵌套、数组下标识别、A兼容等全部限制；四组示例基线
- 调用语句与RETURN（proc_staffs/proc_return聚合示例）
- 动态查询：EXECUTE IMMEDIATE与OPEN FOR双方式、into/out互斥、占位符与bind_argument规则、dynamic_sql_compat、||拼接建议；示例基线
- 动态非查询语句：占位符替换、重复占位符、DDL拼接、insert/alter示例
- 动态调用存储过程：匿名块包裹、CALL占位符、USING修饰符一致、不支持=>；proc_add基线
- 动态调用匿名块：占位符个数/顺序一致、八条绑定限制（表达式/cursor/复合出参/PERFORM/refcursor隔离/dynamic_sql_check）；三条示例基线（含dynamic_sql_check同名占位符报错）

## Open questions

| ID | 内容 |
|---|---|
| `sp_basic_wave8_140_oq_runtime` | STRICT与select_into_return_null组合下NO_DATA_FOUND/TOO_MANY_ROWS/QUERY_RETURNED_NO_ROWS的完整判定、dynamic_sql_compat与dynamic_sql_check在重复/同名占位符场景的叠加行为、refcursor绑定入参的隔离边界需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_140_v1.yaml
generated/core_sql_reference_wave8_140_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_140.py
python scripts/build_core_sql_reference_wave8_140.py --check
python -m unittest tests.test_core_sql_reference_wave8_140 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行动态语句或存储过程调用场景。
