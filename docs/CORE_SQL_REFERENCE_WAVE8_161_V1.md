# SQL Reference Wave 8-161 Extraction V1

## 目标

抽取 高级包第十七批切片：`3.12.2.19 DBE_SQL` 第二切片——GET_RESULT读取族/游标状态/绑定/数组族（页 2874–2889）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2874–2889） |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GET_RESULT族：ANYELEMENT通用 + CHAR（err固定-1）/INT/LONG（lgth/off_set/vl_length）/RAW（actual_length截断）/BYTEA/TEXT/UNKNOWN报错处理，各带重载
- DBE_SQL_GET_RESULT_*变体（返回整串/整列、LONG2替代建议）
- 游标状态：IS_ACTIVE（四态true/关闭false/未知报错）、LAST_ROW_COUNT累积计数、RUN_AND_NEXT等价RUN+NEXT_ROW
- 绑定族：SQL_BIND_VARIABLE（out_value_size A兼容条件）、SQL_BIND_ARRAY四原型（anyarray/anyindexbytable±下标、自定义table不支持）
- 数组族：SET_RESULT_TYPE_INTS/TEXTS/RAWS/BYTEAS/CHARS、SET_RESULTS_TYPE五重载（内置table类型）、GET_RESULTS_*五类+通用
- err参数未实现状态、数组访问语义（cnt/lower_bnd）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_161_oq_runtime` | GET_RESULT_RAW的actual_length截断在多字节场景的边界、SQL_BIND_VARIABLE绑定出参在非A兼容模式的行为、SET_RESULTS_TYPE五重载与GET_RESULTS_*/数组下标的对应关系需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_161_v1.yaml
generated/core_sql_reference_wave8_161_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_161.py
python scripts/build_core_sql_reference_wave8_161.py --check
python -m unittest tests.test_core_sql_reference_wave8_161 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行动态SQL。
