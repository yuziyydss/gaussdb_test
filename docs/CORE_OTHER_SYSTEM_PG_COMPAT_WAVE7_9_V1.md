# Core Other System PostgreSQL-compatible List Wave 7-9 Extraction V1

## 目标

抽取 `1.6.60 其他系统函数` 第一阶段：兼容PostgreSQL的内建函数和操作符清单。页1076开始的实现内部功能函数留给下一批。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 1058–1075，共18页 |
| 结构化 facts | 13 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 13 / 13 |

## 覆盖内容

本批按函数族记录兼容PostgreSQL清单，包括：

- 目录与元数据辅助函数
- 几何和网络地址类型函数/操作符
- 数组函数与I/O
- bit和boolean类型函数
- 文本、字符、模式匹配和正则函数
- 数值类型运算、比较和排序支撑
- date/time/timestamp/interval类型函数
- JSON、XML、UUID相关函数
- 索引支撑、比较和哈希辅助函数

关键边界：

- 这些函数不推荐使用；如需使用请联系华为技术支持工程师。
- 详细行为可参考PostgreSQL官方文档。
- 升级模式下不支持调用变长参数的系统函数，如`concat`。
- 页1076开始的实现内部功能函数不在本批。

## Open questions

| ID | 内容 |
|---|---|
| `otherpg_wave7_9_oq_full_inventory_matrix` | 建立逐条机器可读函数索引，并按类型族核对遗漏与别名 |
| `otherpg_wave7_9_oq_pg_behavior_matrix` | 清单函数与PostgreSQL版本、兼容GUC、边界值、NULL和升级模式的行为差异 |

## 产物

```text
docs/compat_facts/core_other_system_pg_compat_wave7_9_v1.yaml
generated/core_other_system_pg_compat_wave7_9_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_other_system_pg_compat_wave7_9.py
python scripts/build_core_other_system_pg_compat_wave7_9.py --check
python -m pytest -q tests/test_core_other_system_pg_compat_wave7_9.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行兼容PostgreSQL函数、不验证PostgreSQL行为差异。
- 不宣称目标环境行为验证通过。
