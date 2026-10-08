# SQL Reference Wave 8-53 Extraction V1

## 目标

合并抽取 `ALTER SYNONYM` 与 `DROP SYNONYM`，完成同义词所有者变更、PUBLIC同义词删除和依赖处理闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.33` | 2 | ALTER SYNONYM |
| `1.13.10.40` | 2 | DROP SYNONYM |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 4 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- ALTER SYNONYM仅支持修改所有者
- 系统管理员权限与三权分立边界
- 新所有者模式CREATE权限
- PUBLIC同义词不支持ALTER
- `OWNER TO`语法与示例
- DROP SYNONYM权限、`PUBLIC`、`IF EXISTS`
- 多同义词删除、`CASCADE/RESTRICT`
- 同义词生命周期与权限差异

## Open questions

| ID | 内容 |
|---|---|
| `syn_wave8_53_oq_runtime` | ALTER/DROP SYNONYM在真实权限、PUBLIC同义词、依赖对象和锁定状态组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_53_v1.yaml
generated/core_sql_reference_wave8_53_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_53.py
python scripts/build_core_sql_reference_wave8_53.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_53.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER/DROP SYNONYM。
