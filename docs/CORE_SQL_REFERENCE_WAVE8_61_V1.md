# SQL Reference Wave 8-61 Extraction V1

## 目标

合并抽取 `MARK BUCKETS`、`MERGE INTO` 与 `MOVE`，完成扩容通知边界、多表匹配合并更新插入和游标重定位闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.16.1` | 1 | MARK BUCKETS |
| `1.13.16.2` | 4 | MERGE INTO |
| `1.13.16.3` | 3 | MOVE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- MARK BUCKETS扩容通知用途与当前形态不支持
- MERGE INTO匹配UPDATE/不匹配INSERT语义
- UPDATE+INSERT+SELECT权限矩阵；仅行级触发器
- 语法：USING表/视图/子查询、ON关联条件、WHEN子句、DEFAULT VALUES
- plan_hint首个注释块生效
- 分区/二级分区MERGE与value不一致异常
- ON关联字段不可更新；WHEN MATCHED禁更新系统表/系统列
- WHEN NOT MATCHED禁多VALUES；子句顺序/缺省/重复规则
- DEFAULT缺省值语义；WHERE条件、系统列排除、数值隐式转bool风险
- products/newproducts behavior oracle（MERGE 4结果矩阵）
- MOVE重定位游标、direction全参数、与FETCH参数一致、MOVE count标签
- MOVE behavior oracle（MOVE 5后FETCH 6/7）

## Open questions

| ID | 内容 |
|---|---|
| `mark_buckets_wave8_61_oq_runtime` | MARK BUCKETS在扩容工具与内核联动的真实环境中的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_61_v1.yaml
generated/core_sql_reference_wave8_61_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_61.py
python scripts/build_core_sql_reference_wave8_61.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_61.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行MERGE/MOVE语句。
