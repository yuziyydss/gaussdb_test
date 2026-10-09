# SQL Reference Wave 8-180 Extraction V1

## 目标

抽取 Oracle兼容性说明第一切片：`4.3.1-4.3.6`（概述/SQL基本元素/伪列/操作符/表达式/条件，页 3134–3155；4.3 共158页拆多波）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3134–3155） |
| 物理页 | 22 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- Oracle 19c兼容性概述
- 数据类型兼容：NUMBER/FLOAT/BINARY_FLOAT/BINARY_DOUBLE、DATE/TIMESTAMP/INTERVAL、CHAR/VARCHAR2/CLOB、RAW/ROWID、自定义类型/XMLTYPE/空间类型（约30种类型对比）
- 锁模式映射（Oracle RS/RX/S/SRX/X→GaussDB六种）
- 比较规则差异（字符值/对象值/Varrays）
- 字面量/格式模型（a_format_version依赖）/空值/注释/HINT差异
- 数据库对象兼容与不支持清单（schema对象约30种、非schema对象约12种）
- 唯一索引NULL行为差异、同义词搜索顺序差异
- 伪列（connect_by_iscycle/level/currval/nextval/rowid）兼容语义
- 操作符/表达式/条件概览

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_180_oq_runtime` | NUMBER标度负值在GaussDB中的替代方案、TIMESTAMP WITH LOCAL TIME ZONE的迁移策略、ROWID比较规则差异对索引扫描的影响、唯一索引NULL行为在enable_uniq_idx_a_compat开启后的完整兼容度需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_180_v1.yaml
generated/core_sql_reference_wave8_180_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_180.py
python scripts/build_core_sql_reference_wave8_180.py --check
python -m unittest tests.test_core_sql_reference_wave8_180 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
