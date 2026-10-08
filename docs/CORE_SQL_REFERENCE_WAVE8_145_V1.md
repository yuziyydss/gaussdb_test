# SQL Reference Wave 8-145 Extraction V1

## 目标

抽取 高级包第四批切片：`3.12.1.2 PKG_UTIL` 尾部族（EXCEPTION/APP/SESSION/UTILITY，页 2681–2691），PKG_UTIL 至此收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2681–2691） |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- EXCEPTION_REPORT_ERROR（code/log/flag）
- APP族六函数：CLIENT_INFO/MODULE/ACTION 读写对及示例基线（set module/set action回读）
- 基础版转换：LOB_CONVERTTOBLOB（→RAW）/LOB_CONVERTTOCLOB（→TEXT）/LOB_TEXTTORAW/LOB_RAWTOTEXT/RAW_CAST_TO_VARCHAR2（十六进制）/MATCH_EDIT_DISTANCE_SIMILARITY
- SESSION_CONTEXT三函数闭环（SET→SEARCH→CLEAR，client_identifier null语义）
- UTILITY族：GET_TIME（unix时间戳）、FORMAT_ERROR_BACKTRACE/STACK/CALL_STACK、COMPILE_SCHEMA与GS_COMPILE_SCHEMA（compile_all语义差异、retry_times）及重编译示例基线
- MODIFY_PACKAGE_STATE（flags=1释放会话缓存/清除包全局/关闭游标，其他位标志不支持）

## Open questions

| ID | 内容 |
|---|---|
| `pkgutil_wave8_145_oq_runtime` | MODIFY_PACKAGE_STATE(flags=1)释放会话缓存后包全局重新初始化的可见性边界、GS_COMPILE_SCHEMA的retry_times重试语义与编译失败上报、EXCEPTION_REPORT_ERROR的code取值域需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_145_v1.yaml
generated/core_sql_reference_wave8_145_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_145.py
python scripts/build_core_sql_reference_wave8_145.py --check
python -m unittest tests.test_core_sql_reference_wave8_145 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行重编译或会话状态修改。
