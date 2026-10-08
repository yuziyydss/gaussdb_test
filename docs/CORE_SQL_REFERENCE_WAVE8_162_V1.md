# SQL Reference Wave 8-162 Extraction V1

## 目标

抽取 高级包第十八批切片：`3.12.2.19 DBE_SQL` 第三切片——描述/绑定/C兼容/OUT参数族与示例（页 2890–2907），DBE_SQL 收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2890–2907） |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GET_RESULTS五重载（内置table类型、自定义table不支持）与数组NULL填充差异说明
- 描述接口对：SQL_DESCRIBE_COLUMNS（INOUT）/DESCRIBE_COLUMNS（OUT，兼容接口），仅SELECT游标
- C兼容族不建议使用（BIND_VARIABLE/SQL_SET_RESULTS_TYPE_C/SQL_GET_VALUES_C/TABLEOF对）
- OUT参数读取族：GET_VARIABLE_RESULT五变体（CHAR/RAW/TEXT/INT等）与GET_ARRAY_RESULT四变体（pos为绑定参数名）
- 五组示例基线：基础查询三行遍历、DESCRIBE十二字段输出、C兼容SQL_GET_VALUES_C循环、四OUT参数读取（v_raw=0B）、数组OUT参数（需关闭proc_outparam_override）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_162_oq_runtime` | GET_RESULTS数组NULL填充与A库长度差异对结果遍历的影响、示例12数组OUT参数在proc_outparam_override开启下的不支持范围、DESC_REC中col_charsetid/col_charsetform的实际取值含义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_162_v1.yaml
generated/core_sql_reference_wave8_162_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_162.py
python scripts/build_core_sql_reference_wave8_162.py --check
python -m unittest tests.test_core_sql_reference_wave8_162 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行动态SQL。
