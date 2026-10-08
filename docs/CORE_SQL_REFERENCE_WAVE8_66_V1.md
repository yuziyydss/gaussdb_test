# SQL Reference Wave 8-66 Extraction V1

## 目标

抽取 `REPLACE` 三种替换插入形式与 `RESET` 参数恢复，完成 R 段（1.13.18）收尾。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.18.8` | 6 | REPLACE |
| `1.13.18.9` | 2 | RESET |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- REPLACE冲突先删后插语义与三种形式
- DELETE+INSERT权限；REPLACE 0 X返回格式
- REPLACE...SELECT列数一致要求
- SET自引用默认值+1/NULL/NOT NULL有默认值类型清单
- 表1-385默认值矩阵与ENUM/SET/A模式空串/B模式零值/uint等模式说明
- SET列依赖顺序
- 行级触发器与INSERT/DELETE语句级触发器顺序
- DEFERRABLE排除、多唯一约束全删风险、多行冲突顺序执行
- col_name长度≤1限制
- 行访问控制/外表/密态表/内存表排除
- 三种语法与参数规则
- behavior oracle：值/查询/SET三种形式REPLACE 0 2结果
- RESET语义与SET TO DEFAULT等价、事务性、六类参数、时区恢复PRC行为基线

## Open questions

| ID | 内容 |
|---|---|
| `replace_wave8_66_oq_runtime` | REPLACE三种形式在真实主键/唯一约束、触发器、默认值与兼容模式组合以及RESET参数恢复路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_66_v1.yaml
generated/core_sql_reference_wave8_66_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_66.py
python scripts/build_core_sql_reference_wave8_66.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_66.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行REPLACE/RESET语句。
