# SQL Reference Wave 8-84 Extraction V1

## 目标

抽取 C 族第二批：`CLOSE` 游标关闭、`CLUSTER` 聚簇排序与 `COMMENT` 对象注释。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.4` | 2 | CLOSE |
| `1.13.9.5` | 4 | CLUSTER |
| `1.13.9.6` | 4 | COMMENT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CLOSE资源释放、尽早关闭、事务COMMIT/ROLLBACK隐含关闭规则（可保持/不可保持游标）、pg_cursors视图
- CLUSTER聚簇语义与一次性特性、重新聚簇与ALTER TABLE CLUSTER ON/SET WITHOUT CLUSTER、无参CLUSTER范围
- ACCESS EXCLUSIVE锁、行存B-Tree索引限制、性能场景、磁盘空间要求、周期维护与ANALYZE、事务禁止、系统表忽略、表达式索引权限
- 三种语法（表/分区/重新聚簇）与VERBOSE
- 行为基线：聚簇排序有序、缺USING报错、VERBOSE INFO、分区仅p2聚簇
- COMMENT单注释/NULL删除/对象删除自动删、无安全保护与共享对象全局可见警告
- 权限矩阵（所有者/COMMENT权限/ROLE特殊规则/PDB排除）
- 28类对象语法与参数明细
- 行为基线（表/列注释与\d+查看）

## Open questions

| ID | 内容 |
|---|---|
| `comment_wave8_84_oq_runtime` | CLOSE隐含关闭边界、CLUSTER各场景（分区/表达式索引/磁盘约束）和COMMENT权限矩阵在真实并发与对象依赖组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_84_v1.yaml
generated/core_sql_reference_wave8_84_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_84.py
python scripts/build_core_sql_reference_wave8_84.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_84.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CLOSE/CLUSTER/COMMENT语句。
