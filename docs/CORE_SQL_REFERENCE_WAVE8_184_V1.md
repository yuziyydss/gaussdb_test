# SQL Reference Wave 8-184 Extraction V1

## 目标

抽取 Oracle兼容性说明第五切片：`4.3.11.2 其它函数`（聚合/分析函数）+ `4.3.12 系统视图`（约140个映射，页 3226–3235）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3226–3235） |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 聚合函数：AVG/CORR/COUNT/COVAR_*/CUME_DIST/DENSE_RANK/GROUPING/LISTAGG/MAX/MEDIAN/MIN/PERCENT_*/RANK/REGR_*/STDDEV*/SUM/VAR_*/VARIANCE/WM_CONCAT均支持；FIRST/LAST使用KEEP语法
- 分析函数：FIRST_VALUE/LAG/LAST_VALUE/LEAD/NTILE/ROW_NUMBER/RATIO_TO_REPORT支持；NTH_VALUE不支持FROM FIRST|LAST
- 不支持类别：对象引用/模型/OLAP/数据盒功能函数
- 系统视图映射：约140个Oracle视图到GaussDB视图的映射（ALL_→DB_、DBA_→ADM_、USER_→MY_、ROLE_保持、ILM→GS_ADM_/GS_MY_）
- 五类前缀完整清单：ALL_约40个/DBA_约70个/USER_约25个/ROLE_3个/特殊6个

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_184_oq_runtime` | NTH_VALUE不支持FROM FIRST|LAST的替代方案、Oracle分析函数在GaussDB中的性能差异、系统视图映射的完整兼容度（尤其ILM相关视图）需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_184_v1.yaml
generated/core_sql_reference_wave8_184_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_184.py
python scripts/build_core_sql_reference_wave8_184.py --check
python -m unittest tests.test_core_sql_reference_wave8_184 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
