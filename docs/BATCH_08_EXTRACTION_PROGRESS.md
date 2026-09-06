# 第八批：数据库、多租与工具命令

本批25个PDF章节包完成来源处置、有限SQL生成与证据对账；不代表全域或实机验证。

| 项目 | 结果 |
| --- | ---: |
| 新包 | 25 |
| 有候选SQL的包 | 4 |
| 工具/运行时/环境契约待补，无普通清单 | 19 |
| 明确不支持的BUCKETS命令 | 2 |
| 原文行数 / Source unit | 1822 / 459 |
| Confirmed fact（含示例） | 595 |
| Open question / Planned scenario | 39 / 31 |
| Manifest / SQL | 16 / 56 |
| Pairwise适用清单 | 7 |
| needs_profile特性 | 37 |

4个有限生成包是ALTER SESSION、CREATE DATABASE、ALTER DATABASE、DROP DATABASE。
25包原文处置门禁通过；原文中的疑问已登记，不表示疑问已解决。
LOCK/MARK BUCKETS的结构性static=True只代表不支持事实已登记，不能算作SQL通过。

## 关键校对

- CREATE DATABASE字符集表逐行抽取44条，区分服务端能力、ICU、字节数和别名。BIG5、JOHAB、SJIS、SHIFT_JIS_2004、UHC不能直接作为正向服务端编码。
- PDF排版中的连接上限核对为2^31-1，即2147483647，不是平铺文本的231-1。
- 有限建库只选template0、C locale、PG、UTF8/LATIN1；其他模板/模式/时区和环境相关编码保留profile缺口。
- ALTER SESSION复用真实模式/事务fixture；更名用例同时清理新旧独占数据库名称。
- DROP DATABASE仅生成无连接、回收站关闭且具备权限的独占目标；不开启回收站或清理真实业务库。
- 终止会话必须运行时获取SID/SERIAL，不输出写死的业务会话ID。
- PDB导入直接调用可能异常重启；PDB、升级、停机、恢复、全局配置等没有伪造普通fixture或普通清单。
- PDB导入名称可选性、PDB选项重复性、ILM库名等原文差异保留open question。

## 验证

专项15/15通过；全量303/303通过，656.764秒，执行时146个包。
日志：`work/doc2spec/batches/batch_08/tests_full.log`。
[机器对账](../work/doc2spec/batches/batch_08/final_task_results.json)记录源、包、工具、报告与测试哈希。
4个生成包的逐任务case/report/audit与规范报告精确相同。
所有包仍为needs_review；未执行数据库。

本批结束累计146/224包，剩余78章；最新进度见[全本清单](PDF_GENERAL_EXTRACTION_BACKLOG.md)。
