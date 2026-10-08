# SQL Reference Wave 8-71 Extraction V1

## 目标

抽取 `SNAPSHOT` 数据快照全生命周期与 `START TRANSACTION/BEGIN` 事务启动，完成 S 段（1.13.19）收尾。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.13` | 3 | SNAPSHOT |
| `1.13.19.14` | 3 | START TRANSACTION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- SNAPSHOT版本控制用途、db4ai_snapshot_mode（MSS/CSS）
- 增量存储依赖顺序删除
- 三权分立不支持、AI训练需发布
- CREATE SNAPSHOT AS / FROM USING迭代语法
- PURGE/SAMPLE（STRATIFY BY AT RATIO）/PUBLISH/ARCHIVE/DB4AISHOT查询
- qualified_name/version/ident/sconst/comment/alias/attr_list/label/num参数
- behavior oracle：s1@1.0创建、s1@2.0迭代（6行）、采样与依赖顺序删除
- START TRANSACTION/BEGIN启动事务与SET TRANSACTION类比
- 自动提交禁用边界
- 两种格式语法、WORK|TRANSACTION无实际作用
- 隔离级别设置时机、四种级别语义（SERIALIZABLE等价RR）
- 行为基线（默认启动、READ COMMITTED READ WRITE）

## Open questions

| ID | 内容 |
|---|---|
| `snapshot_wave8_71_oq_runtime` | SNAPSHOT创建/迭代/采样/发布/存档全生命周期与START TRANSACTION事务特性在真实MSS/CSS模式、三权分立和并发路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_71_v1.yaml
generated/core_sql_reference_wave8_71_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_71.py
python scripts/build_core_sql_reference_wave8_71.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_71.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行快照/事务语句。
