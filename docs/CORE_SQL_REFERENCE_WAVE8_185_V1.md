# SQL Reference Wave 8-185 Extraction V1

## 目标

抽取 Oracle兼容性说明收官切片：`4.3.13 高级包`（23个Oracle→GaussDB映射包+大量不支持包清单+逐包兼容性说明，页 3235–3291）。**本波完成后 4.3 Oracle 兼容性说明整章收官。**

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 57 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 23个Oracle包→GaussDB包映射总账（DBMS_*→DBE_*）
- 逐包兼容性说明：DBMS_LOB（APPEND/CLOSE/COMPARE/CONVERT/COPY/CREATETEMPORARY差异）、DBMS_SCHEDULER（核心调度接口）、DBMS_STATS（统计信息收集/删除/锁定）、DBMS_XMLDOM/DBMS_XMLPARSER、DBMS_SESSION/DBMS_UTILITY、UTL_MATCH/DBMS_APPLICATION_INFO、DBMS_RANDOM/DBMS_OUTPUT等
- 不支持包清单（100+个）功能域分类：ADDM/AQ/Crypto/Datapump/Debug/Flashback/Data Mining/DBFS/分布式/Cube等

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_185_oq_runtime` | DBMS_LOB→DBE_LOB映射的接口签名一致性、DBMS_STATS→DBE_STATS映射在统计信息锁定场景的行为差异、不支持包在迁移场景下的替代方案需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_185_v1.yaml
generated/core_sql_reference_wave8_185_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_185.py
python scripts/build_core_sql_reference_wave8_185.py --check
python -m unittest tests.test_core_sql_reference_wave8_185 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
