# SQL Reference Wave 8-62 Extraction V1

## 目标

合并抽取 `LOAD DATA`、`LOCK` 与 `LOCK BUCKETS`，完成文件导入、表级锁模式矩阵和bucket锁边界闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.15.1` | 5 | LOAD DATA |
| `1.13.15.2` | 5 | LOCK |
| `1.13.15.3` | 1 | LOCK BUCKETS |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- LOAD DATA用途、B/M兼容模式与5.7 s2参数门槛
- INSERT/DELETE权限、与COPY FROM权限GUC一致性
- 仅表可用、类型转换失败导入失败
- 与SELECT … INTO OUTFILE配合：子句匹配、空字符串/重复特殊字符风险
- LOCAL路径规则（数据目录/$GAUSSHOME/bin）
- REPLACE/IGNORE/缺省三种冲突与字段数不足行为矩阵
- PARTITION指定分区与范围不一致报错；CHARACTER SET缺省客户端编码
- FIELDS/LINES分隔符、引号符、转义符规则与new_escape_string开关
- IGNORE number行、字段列表/用户变量（enable_set_variables）、SET表达式限制
- behavior oracle：SET列值、IGNORE冲突跳过、分区导入、ENCLOSED BY引号处理
- LOCK TABLE用途与SHARE模式场景
- 事务块边界、无UNLOCK、缺省ACCESS EXCLUSIVE、权限、xc_maintenance_mode
- 语法/ONLY/DATABASE LINK/上锁顺序/ROW歧义说明
- 八种锁模式冲突与自动请求矩阵
- NOWAIT行为
- behavior oracle：SHARE ROW EXCLUSIVE/ROW EXCLUSIVE/ACCESS EXCLUSIVE阻塞示例
- LOCK BUCKETS用途与当前形态不支持

## Open questions

| ID | 内容 |
|---|---|
| `load_data_wave8_62_oq_runtime` | LOAD DATA与LOCK在真实B/M兼容模式、GUC参数组合、权限、并发冲突和错误路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_62_v1.yaml
generated/core_sql_reference_wave8_62_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_62.py
python scripts/build_core_sql_reference_wave8_62.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_62.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行LOAD/LOCK语句。
