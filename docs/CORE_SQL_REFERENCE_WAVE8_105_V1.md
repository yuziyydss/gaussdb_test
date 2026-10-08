# SQL Reference Wave 8-105 Extraction V1

## 目标

抽取 M 兼容 `ALTER TABLE`（2.4.2.6.12，17页单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- ONLY/*保留语法不支持、ADD COLUMN默认值全表更新规避五条件（类型白名单/128字节/非易变函数/非NULL）
- FIRST|AFTER位置变更触发全表更新、无action仅校验
- action全集（含AUTO_INCREMENT 2^127上界、CONVERT TO CHARSET、TO GROUP/NODE扩容内部语法）
- REPLICA IDENTITY四级别与ustore特例（NOTHING无效等同FULL）
- column_clause九种子句（ADD/MODIFY/CHANGE/DROP/SET DEFAULT/生成列）
- MODIFY/CHANGE重建依赖对象规则、分区键禁改、统计信息清空
- DROP COLUMN非物理删除+VACUUM回收、CASCADE s1仅语法
- SET SCHEMA序列限制、批量action性能、CHECK/NOT NULL扫描、两倍磁盘空间
- 存储参数FILLFACTOR/INIT_TD/PARALLEL_WORKERS
- 字段字符集BINARY→BLOB映射、表默认继承
- CHECK禁子查询、DEFAULT嵌套括号扩展、update_expr精度一致
- ON UPDATE时间戳属性约束语义
- 约束命名优先级、ASTORE btree/USTORE ubtree默认
- 外键五种ON DELETE/UPDATE动作、foreign_key_checks开关
- RENAME/SET SCHEMA/OWNER/改列名/自增列/删列/删索引示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_alter_table_wave8_105_oq_runtime` | 新增列DEFAULT值全表更新规避条件在真实数据规模下的生效边界、CONVERT TO CHARSET大表转换耗时、REPLICA IDENTITY逻辑复制解码行为、ON UPDATE时间戳自动更新与业务事务组合需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_105_v1.yaml
generated/core_sql_reference_wave8_105_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_105.py
python scripts/build_core_sql_reference_wave8_105.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_105.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容ALTER TABLE语句。
