# 第七批抽取与有限域生成结果

更新时间：2026-09-05。本批完成 26 个新章节包的抽取、有限域生成与逐包对账；不代表全语法或数据库行为闭环。

| 项目 | 结果 |
| --- | ---: |
| 新包 | 26 |
| 有候选 SQL 的包 | 21 |
| PDF 明确不支持的 LANGUAGE 包 | 3 |
| 内部回调/操作符类契约待完善，无清单 | 2 |
| 原文行数 | 2092 |
| Source unit | 585 |
| Confirmed fact（含 example） | 579 |
| Open question | 51 |
| Planned scenario | 26 |
| Manifest / 候选 SQL | 35 / 130 |
| Pairwise 适用清单 | 13 / 35 |
| 待建能力 profile | 94 |

原文处置门禁 26/26 通过，包括按规则登记的 open question；不表示疑问已解决。
21 个有 SQL 的包，生成与逐包证据中的 case、report、audit 精确一致。所有包保持 needs_review，本阶段未执行数据库。
3 个 LANGUAGE 包的审计器结构性 static=True 只表示“不支持”事实已登记，不计 SQL 可用包或行为通过。

## 本批校对

- CREATE TYPE 空复合属性列表、空枚举列表是可选的空结构。先记录失败测试，再通过 optional 节点控制 repeat，未放松生成器对空 repeat 的检查。
- ALTER EXTENSION DROP TABLE 成员用例的清理不再重复执行同一 DROP 成员动作；用事务回滚恢复。
- CREATE TYPE 的 63 字节/63 字符措辞差异保留疑问；有限值域只用 ASCII。基础类型 C/internal 回调及操作符类索引契约未伪装成可执行函数。
- SERVER 参数原文的 fdw_typle_cost 拼写经 PDF 页面核对，保留与其他段落的冲突，不私自推导统一规则。
- USER MAPPING 的 SET/DROP 选项有明确已有状态；不输出密码。目录、扩展、FDW 用例保留权限与环境门禁。
- 长 source unit 按 SQL 步骤、独立条件或表格字段重分；合法的单一枚举域另外写明原子性理由。

## 验证证据

- 专项最终测试：12/12，随后新增原文审计测试一项。
- 全量回归：288/288，574.192 秒；执行时有 121 个包。
- 日志：`work/doc2spec/batches/batch_07/tests_full.log`。
- 红绿测试及逐包证据：`work/doc2spec/batches/batch_07/`。
- [机器对账](../work/doc2spec/batches/batch_07/final_task_results.json)记录包/正文/工具链/比较报告/测试日志哈希。
- SQL：`generated/factor_packages/<factor>/manifest_*.sql`。

本批结束时累计 121/224 个 PDF 绑定包；后续累计进度以[全本剩余清单](PDF_GENERAL_EXTRACTION_BACKLOG.md)为准，不把历史批次数字当作最新全局状态。
