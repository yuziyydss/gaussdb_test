# SQL Reference Wave 8-175 Extraction V1

## 目标

抽取 高级包收官批切片：`3.12.2.27 RESOURCE_MANAGER`（多租资源计划10接口）与 `3.12.3 内部接口`（DBE_DESCRIBE/DBE_ALERT/DBE_UTILITY 内部接口，页 3077–3085）。**本波完成后 3.12 高级包整章收官。**

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3077–3085，两个完整小节） |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- RESOURCE_MANAGER：CDB内执行限制、待决区概念（pending/active、实例唯一、会话互斥）、四待决区接口（CREATE/VALIDATE五条校验/CLEAR/SUBMIT）、资源计划三接口、指令三接口（min_cpu/动态内存/共享内存/连接数/io_limits/io_priority全参数范围与90%约束、High/Medium/Low I/O限速语义）
- ALTER SYSTEM SET切换生效计划
- 3.12.3 内部接口：不建议直接调用；DBE_DESCRIBE（GET_PROCEDURE_NAME/IS_NUMBER_TYPE）、DBE_ALERT（WAITANY_FUNC/WAITONE_FUNC/INFO_FUNC）、DBE_UTILITY内部接口14个（EXPAND_SQL_TEXT/CANONICALIZE_RET/COMPILE_SCHEMA/NAME_*族/SEARCH_*族/PRIVILEGE_CHECK/USER_NAME等）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_175_oq_runtime` | VALIDATE_PENDING_AREA在并发DDL下的校验准确性、io_priority在I/O利用率50%阈值的实际生效时序、多租CDB/PDB场景下资源计划切换对运行中事务的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_175_v1.yaml
generated/core_sql_reference_wave8_175_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_175.py
python scripts/build_core_sql_reference_wave8_175.py --check
python -m unittest tests.test_core_sql_reference_wave8_175 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改资源计划。
