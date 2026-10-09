# SQL Reference Wave 8-179 Extraction V1

## 目标

抽取 SQL参考章：`1.2 关键字`（932个关键字三标准对比表，页 51–85）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 35 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 关键字分类体系：保留/非保留/非保留（不能是函数或类型）/保留（可以是函数或类型）四类
- 约932个关键字条目（198保留/734非保留），按GaussDB/SQL:1999/SQL-92三标准对比
- 非保留关键字限制：列别名/表名/列名/函数名/变量名/表别名的具体受限清单（BEGIN/BY/CLOSE/SET/RAW等）
- SYS_REFCURSOR双引号行为、CURRENT_TIMESTAMP函数名限制
- 模式特定关键字（B/M兼容模式：CONVERT/TIMESTAMPADD等；B模式：JSON_OBJECT等）
- 标识符命名规范（字母/数字/下划线/美元符号、双引号规避）
- 建表禁止列名（CTID/XMIN/CMIN/XMAX/CMAX/TABLEOID等系统保留字段）
- 跨标准差异示例（ADD/ADMIN/ASSERTION/BETWEEN/CALL在不同标准中的分类差异）
- 数据类型名关键字、XML函数关键字、GaussDB特有关键字

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_179_oq_runtime` | 非保留关键字作为列别名/表别名/函数名的完整受限清单在不同GUC参数组合下的行为差异、SYS_REFCURSOR不带双引号自动去除SYS_前缀的机制、模式特定关键字在CREATE TABLE等DDL中的实际拦截行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_179_v1.yaml
generated/core_sql_reference_wave8_179_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_179.py
python scripts/build_core_sql_reference_wave8_179.py --check
python -m unittest tests.test_core_sql_reference_wave8_179 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不创建或删除对象。
