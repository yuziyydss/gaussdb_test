# Stored Procedure Wave 8-4 Extraction V1

## 目标

抽取 `3.16 失效重编译`，补齐一次性入库、级联失效、重编译和失效函数能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `3.16` | 19 | 失效重编译 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 19 |
| 结构化 facts | 21 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 一次性入库、失效重编译与级联失效
- `enable_force_create_obj` / `ddl_invalid_mode`
- `pg_object.valid` 状态语义
- 复杂 `%TYPE` / `%ROWTYPE` 与跨库限制
- PACKAGE/FUNCTION 依赖记录边界
- `pkg_util.gs_compile_schema` 与 `ALTER COMPILE`
- `gs_set_object_invalid()` 失效函数
- 包头重建不删包体

## Open questions

| ID | 内容 |
|---|---|
| `sp_recompile_wave8_4_oq_runtime_matrix` | 一次性入库、级联失效、重编译和 `gs_set_object_invalid` 在真实 schema、跨库、重载与自治事务场景下的结果矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_stored_procedure_wave8_4_v1.yaml
generated/core_stored_procedure_wave8_4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_stored_procedure_wave8_4.py
python scripts/build_core_stored_procedure_wave8_4.py --check
python -m pytest -q tests/test_core_stored_procedure_wave8_4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行重编译或DDL。
