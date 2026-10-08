# SQL Reference Wave 8-75 Extraction V1

## 目标

抽取 `EXECUTE` 预备语句执行、`EXPDP` 细粒度备份导出族与 `FETCH` 游标抓取。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.11.1` | 2 | EXECUTE |
| `1.13.11.2` | 2 | EXPDP DATABASE |
| `1.13.11.3` | 1 | EXPDP PLUGGABLE DATABASE |
| `1.13.11.4` | 1 | EXPDP TABLE |
| `1.13.12.1` | 4 | FETCH |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- EXECUTE预备语句执行、参数兼容与静默忽略、表结构变更缓存不匹配
- 语法与ROWNUM参数排除
- PREPARE+EXECUTE行为基线
- EXPDP DATABASE/PLUGGABLE/TABLE导出范围与语法
- Only auxdb报错阻拦、PDB导出行为基线
- FETCH游标关联位置语义、NO SCROLL限制
- 单行/FORWARD/BACKWARD形式、count越界定位
- RELATIVE 0/FORWARD 0/BACKWARD 0重抓当前行
- 全direction取值语义（ABSOLUTE/RELATIVE性能与正负0）
- cursor_name FROM/IN
- FETCH FORWARD 3行为基线

## Open questions

| ID | 内容 |
|---|---|
| `fetch_wave8_75_oq_runtime` | EXECUTE参数绑定与表结构变更场景、EXPDP族备份恢复工具联动和FETCH各direction在真实游标并发路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_75_v1.yaml
generated/core_sql_reference_wave8_75_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_75.py
python scripts/build_core_sql_reference_wave8_75.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_75.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行预备语句/导出/游标语句。
