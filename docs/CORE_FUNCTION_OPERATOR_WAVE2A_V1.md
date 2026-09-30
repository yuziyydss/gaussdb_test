# Core Function & Operator Wave 2A Extraction V1

## 目标

继续补齐 `1.6` 剩余高价值函数与操作符。Wave 2A 覆盖 13 章 / 112 页，把几何、网络、全文检索、序列、安全、SRF、系统信息、Hash、XML/XMLTYPE、SQL工具和ROWID函数纳入结构化 facts。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.6.10` | 10 | 几何函数和操作符 |
| `1.6.11` | 5 | 网络地址函数和操作符 |
| `1.6.12` | 7 | 文本检索函数和操作符 |
| `1.6.15` | 3 | SEQUENCE函数 |
| `1.6.20` | 12 | 安全函数 |
| `1.6.23` | 2 | 返回集合的函数 |
| `1.6.24` | 4 | 重载查询函数 |
| `1.6.26` | 32 | 系统信息函数 |
| `1.6.31` | 3 | HashFunc函数 |
| `1.6.43` | 17 | XML类型函数 |
| `1.6.44` | 11 | XMLTYPE类型函数 |
| `1.6.50` | 5 | SQL工具函数 |
| `1.6.58` | 1 | ROWID类型函数 |
| 合计 | **112** | **13章** |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 13 |
| 物理页 | 112 |
| 结构化 facts | 45 |
| Open questions | 3 |
| source resolved | 13 / 13 |
| chapter has facts | 13 / 13 |

## 覆盖能力

- 几何操作符、测量函数、构造/转换函数
- 网络地址操作符和函数
- 全文检索操作符、查询/向量构造、rank/headline、debug/lexize/parse/stat
- SEQUENCE生命周期与B模式 `last_insert_id`
- 加密、解密、digest、密码期限、审计和脱敏函数
- SRF求值规则和 `generate_series`
- 重载查询函数
- 会话/身份、进程、权限、可见性、对象描述和内存诊断函数
- 类型哈希函数、`ora_hash`、bpchar hash GUC
- XML / XMLTYPE构建、查询、导出、Oracle兼容函数及限制
- DBE_SQL_UTIL SQL PATCH / SPM工具接口
- ROWID table oid / row no函数

## Open questions

| ID | 内容 |
|---|---|
| `wave2a_oq_sysinfo_full_signature` | `1.6.26`需继续展开每个函数签名、返回类型和权限矩阵 |
| `wave2a_oq_security_environment_matrix` | 安全函数受权限、GUC、字符集影响，需目标环境专项验证 |
| `wave2a_oq_xml_function_output_matrix` | XML/XMLTYPE输出、命名空间和转义行为需实机结果矩阵 |

## Candidate chain integration

Wave 2A 的 45 个 facts 已接入 `Core Expression Candidate Chain V1`。新增 geometry、network、text search、system info、hash、XML/XMLTYPE、SQL tool、sequence 和 ROWID 等 representative candidates；敏感、改状态或大导出函数使用 `metadata` 候选，不进入第一批 SQL probe。

## 产物

```text
docs/compat_facts/core_function_operator_wave2a_v1.yaml
generated/core_function_operator_wave2a_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_function_operator_wave2a.py
python scripts/build_core_function_operator_wave2a.py --check
python -m pytest -q tests/test_core_function_operator_wave2a.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- `1.6.27` / `1.6.29` / `1.6.60` 后续按函数族拆抽。
