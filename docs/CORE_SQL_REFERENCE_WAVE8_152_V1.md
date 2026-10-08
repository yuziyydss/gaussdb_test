# SQL Reference Wave 8-152 Extraction V1

## 目标

抽取 高级包第十一批切片：`3.12.2.8 DBE_ILM_ADMIN`（ADO调度与限流参数）与 `3.12.2.9 DBE_LICENSE`（License激活/查看/注销）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2760–2768，两个完整小节） |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_ILM_ADMIN：CUSTOMIZE_ILM全27参数（EXECUTION_INTERVAL/RETENTION_TIME/ABS_JOBLIMIT/JOB_SIZELIMIT/WIND_DURATION/BLOCK_LIMITS/ENABLE_META_COMPRESSION/编码采样与优先级阈值/LZ4/INDEXJOB/索引压缩开关，各默认值与取值范围）、参数7不支持CUSTOMIZE修改、B/M兼容模式非数字VAL赋0、Resources busy重试
- DISABLE/ENABLE_ILM（enable_ilm前置）
- 库级压缩策略：CREATE/DELETE_ILM_DB_POLICY（存量覆盖/新表继承/HIGH·MEDIUM/仅高级压缩/不支持表达式/gs_dump导出条件/锁超时风险）+ 三条示例基线
- gs_adm_ilmparameters 20行输出基线
- DBE_LICENSE：ACTIVATE双原型（OnCloud令牌/OffCloud ESDP、token_file命名限制）、DEACTIVATE（idempotent语义、ESN重置、RevoTicket.txt）、GET_ESN、GET_LICENSE_INFO（13字段全语义：试用第90天到期、五状态、feature_list）
- GET_LICENSE_INFO示例基线（OnCloud/Activated/feature_list清单）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_152_oq_runtime` | CUSTOMIZE_ILM运行中修改参数对已排队ADO Job的生效时机、CREATE_ILM_DB_POLICY覆盖存量表的事务边界、License试用模式到期（第90天）后的行为转换需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_152_v1.yaml
generated/core_sql_reference_wave8_152_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_152.py
python scripts/build_core_sql_reference_wave8_152.py --check
python -m unittest tests.test_core_sql_reference_wave8_152 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改License或ILM参数。
