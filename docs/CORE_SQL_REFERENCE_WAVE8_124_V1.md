# SQL Reference Wave 8-124 Extraction V1

## 目标

抽取 M 兼容 `日期时间函数`（2.5.8，28 页大节单节成批，覆盖 40+ 个函数）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 28 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- ADDDATE/DATE_ADD/DATE_SUB时间间隔运算（unit全集、负值间隔）
- DATE_FORMAT表2-49格式化字符串全集（%a~%x约30个格式符）
- WEEK表2-50 mode八种取值（周起始日/返回范围/第一周定义）
- FROM_UNIXTIME（1970-01-01 08:00:00 UTC基准）、UNIX_TIMESTAMP（DECIMAL/BIGINT分界）
- NOW vs SYSDATE取值时刻差异、LOCALTIME/LOCALTIMESTAMP别名
- 日期拆解（DAY/DAYOFWEEK/DAYOFYEAR/HOUR/MINUTE/SECOND/MICROSECOND/QUARTER/EXTRACT）
- 组装（MAKEDATE/MAKETIME/SEC_TO_TIME/TIMESTAMPADD）、差值（DATEDIFF/TIMEDIFF/TIMESTAMPDIFF/PERIOD_DIFF）
- GET_FORMAT五地区格式、CONVERT_TZ、TO_DAYS/TO_SECONDS
- 示例基线（ADDDATE/FROM_UNIXTIME/NOW(6)/UNIX_TIMESTAMP/WEEK）

## Open questions

| ID | 内容 |
|---|---|
| `m_dt_wave8_124_oq_runtime` | M兼容WEEK各mode在不同年份边界日期的周数计算、NOW与SYSDATE在长事务中的取值差异、CONVERT_TZ非法时区参数行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_124_v1.yaml
generated/core_sql_reference_wave8_124_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_124.py
python scripts/build_core_sql_reference_wave8_124.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_124.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容日期时间函数。
