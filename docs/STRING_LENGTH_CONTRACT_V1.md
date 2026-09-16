# 有限字符串存储长度合同 V1

## 解决的真实问题

此前同一 `VARCHAR(2)` 目标列：`DEFAULT 'long'` 会进入复核，
但 `INSERT ... VALUES ('long')`、`UPDATE ... SET note='long'` 仅凭 text 类型家族就被标记 checked。
现在三条路径复用 `core/shared_column_contract.py::validate_ascii_string_literal`。
直接投影视图的别名列使用已解析的基表列长度，不另造一套规则。

这是静态列合同，不是数据库行为 Oracle，也不等于整条 SQL 可以执行。

## 原文与范围

唯一产品版本：本项目 `gaussdb-rf-cent.pdf`，V2.0-10.0.0 集中式参考，2026-04-30。
PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

| 来源 | 原文事实 | 本次消费方式 |
| --- | --- | --- |
| 1.3.4 表1-8，物理100–101页 | VARCHAR 长度单位受兼容模式影响；存储空间与字符数不是同一个概念；部分模式超长有报错/截断条件 | 只对已有普通列合同内、可直接解码的 ASCII 字符串做长度检查；超长/非ASCII转入复核 |
| 1.9.4，物理1139页，正文L9–15 | 类型匹配之后还有 typmod 长度转换，显式/隐式转换可能不同 | 不再以 text 家族匹配代替存储长度检查，不自行模拟截断 |

正文文件位于 `work/pdf_foundations_2026_09_07/corpus/general/utility/`：

- `section_1_3_4.txt` SHA-256 `1c9f061dcb9ebbfc7f65d25cde82e23feb2c99cde57f076e34a48fa077f0ed2e`。
- `section_1_9_4.txt` SHA-256 `93883538f465c79e914c90abeb956be314c286661e08956d7845c91b889ea9aa`。

本次复用了已有 PDF 基础正文，不将新收集的 885 条兼容参考事实宣称为全部接入。
M 特有类型、B 严格模式、A BYTE/CHAR、多字节编码必须各自保留条件，不能互相借用证据。

## 接口和结果

- 消费者：`finite_sql_contract.check_types`，DEFAULT / omitted-column resolver，已有字面量 seed 校验。
- 生成器入口：已有 rendered-contract 检查和 fixture seed 检查调用上述接口；未满足完整结构合同的语句仍留作复核。
- 显式 ASCII 字面量通过时增加 `shared_ascii_string_literal_lengths` 检查标签。
- 显式超长/未知编码返回 `needs_review / string_length_unknown`。
- DEFAULT 保留原有 `default_length_unknown` 接口，避免破坏旧问题追踪。
- SQL 引号 `''` 按一个引号字符计数；反斜杠、NUL、非ASCII不猜测编码/转义配置。
- 不扩展函数表达式、隐式转换、CHAR补空格、空串转NULL、无typmod最大行存储、复杂视图、真实SQLSTATE。
- `checked` 的范围仍然是 `finite_write_shape_only`，只证明报告列出的有限检查，不授予实机 verified。

## 验收

`tests/test_string_length_contract.py` 包含真实失败回归：INSERT/UPDATE 超长、DEFAULT一致性、
引号解码、多字节/转义边界、视图列别名、未覆盖表达式不伪造长度证明。
重生成必须逐条对比 case_id、SQL、预期、参数、setup/teardown 和既有覆盖缺口，不能手改生成 SQL。

## M 模式的独立增量

后续增加了显式 M/UTF8 条件下的字符数与字节存储检查，详见
[M 字符串存储合同与复核记录](M_STRING_STORAGE_20260915.md)。
它不扩大本文一般模式的 ASCII 证明范围，也尚未形成新的正式 manifest 覆盖。
