# 按包缺口收敛：晚间阶段进展

最终更新于2026-09-06 21:00（北京时间）。本晚运行窗口已结束，定时续跑已暂停。
20:59完成终点总对账，649项静态回归对应输入及生成证据未漂移；最后阶段保持代码冻结。
范围为本地冻结PDF的224包，未连接或执行数据库，未进行Git操作。

## 分层进度

| 口径 | 当前结果 | 不代表什么 |
| --- | --- | --- |
| 包及来源 | 224包，224份正文哈希对账一致 | 不代表正文语义全部提取 |
| 普通候选 | 168包有候选，56包仍无普通清单 | 未将受资产限制的包批量标成不支持 |
| 生成规模 | 528清单、3921条完整case；本晚新增91条GRANT | 不代表SQL已在服务器执行 |
| 已有候选保留 | 原3830条case未改；三个新增清单独立记录 | 不用删除旧case或改变预期提高通过率 |
| 静态包标准 | 有候选且满足既定标准仍为abort/deallocate/rollback三包 | 新增取值覆盖不直接升级整个包 |
| 实机验证 | 本晚未执行 | 不复用其他环境的历史通过率 |

## 具体产出

1. **GRANT有限分支**：角色成员关系5条、ANY授权84条、SYSADMIN拼写2条。
   按本章不同产生式约束接收方、选项与权限前置；配套全新非登录角色fixture及planned场景。
   GRANT取值缺口49→9；剩余DBLINK、公共同义词授予权限依据继续保留，不猜测。
2. **模型输入契约**：训练及预测分别明确投影顺序、类型和15行输入校验计划。
   复用真实训练表fixture，没有创建模型或假定模型已存在；两个包仍无普通清单。
3. **表空间结构**：CREATE补独立MAXSIZE位置，CREATE/ALTER/DROP必填槽位声明修正。
   不造服务端路径，不把不可回滚生命周期套进普通ROLLBACK。三包仍需真实资产。
4. **条件值评审**：INSERT条件准入与资源池跨章冲突分开；CREATE DATABASE的37个条件编码
   分解为服务器支持、模板/区域、客户端及生命周期要求。公共准入模型仍是提案，未绕过V1门禁。
5. **修正两个条件归因**：ALTER TABLE多列MODIFY不再借用B扩展语法的条件；
   无ON(EXPR)的ILM取值不再引用表达式函数白名单。两项仍conditional，保留独立
   未验证契约；原19个open question保留，增加2个精确问题，不提升状态。

有候选的168包中，69项conditional取值缺口已建立评审索引；其余56包还有112项，
在索引中明确单列为本范围未审。**全224包是181项，不是69项。** 这些都是缺口信号，
不是独立缺陷数量；评审索引没有放行值、关闭缺口或证明原文全覆盖。

## 验证状态与发现的问题

- 分批lint、相关测试和完整case/来源对账已有各批回执。
- 第一轮统一静态回归选择68模块，排除涉及API配置/执行路由的`tests.test_api`。
  646项测试中出现1个错误：新增GRANT快照只写入分批目录，固定快照目录缺文件。
  已保留失败日志，没有跳过该测试。
- 已用现有生成器补3份新快照；原525份SQL字节和原报告哈希未变。
  第二轮同一组回归**646项通过**，unittest耗时919.078秒，回执壁钟922.599秒，
  退出0、受管输入前后无变化；结束后再次核对当前指纹也无差异。
- 表空间前后3921完整case、528份快照及2355缺口ID均一致，只有三包结构哈希改变。
  生成对账与回归回执分别保留，不把两者合并成数据库通过。
- 后续ALTER TABLE两处条件修正后，第三轮649项中1项失败：旧测试快照仍写19个
  open question。已改成精确断言原19个加新增2个ID，而不是放宽范围；目标审计及
  三项专项测试4/4通过。第四轮同一69模块统一回归**649项全部通过**，unittest
  964.409秒，回执壁钟967.958秒，退出0；输入前后及结束后的指纹核对均无差异。
- 最新ALTER TABLE对账仍保留3921完整case/528快照/224正文与全部旧缺口，只有
  该包结构哈希变化，新增2个unresolved_fact信号。没有新增SQL或改写预期。

固定目录`generated/factor_packages/generation_report.json`仍是3830条原始对照；
不能把它与新增快照数量混用。当前完整报告位于下面的晚间生成目录。

新增组合还有独立于生成器的有限域见证检查，每个pair可追到具体case ID：

| 新清单 | 全组合数 | 选取case | 变化轴pair |
| --- | ---: | ---: | --- |
| 角色成员关系 | 8 | 5 | 12/12 |
| ANY权限 | 168 | 84 | 146/146 |
| SYSADMIN拼写 | 2 | 2 | 不适用，只有一个变化轴，两值全枚举 |

不把固定默认轴算作功能组合，不承诺最少case数，也不把pair覆盖解释为SQL可执行。

## 证据入口

- [晚间总对账](../work/evening_2026_09_06/total_reconciliation.json)
- [当前完整生成报告](../work/evening_2026_09_06/alter_condition_batch/generated/generation_report.json)
- [当前逐条缺口账本](../work/evening_2026_09_06/alter_condition_batch/backlog.json)
- [69项条件评审索引及112项范围外记录](../work/evening_2026_09_06/conditional_review_index.json)
- [ALTER TABLE条件修正对账](../work/evening_2026_09_06/alter_condition_batch/reconciliation.json)
- [表空间前后对账](../work/evening_2026_09_06/tablespace_batch/reconciliation.json)
- [首轮失败回执](../work/evening_2026_09_06/unified_regression/receipt.json)
- [快照追加记录](../work/evening_2026_09_06/snapshot_append_receipt.json)
- [第二轮通过回执](../work/evening_2026_09_06/unified_regression_r2/receipt.json)
- [第三轮失败回执](../work/evening_2026_09_06/unified_regression_r3/receipt.json)
- [当前版本第四轮通过回执](../work/evening_2026_09_06/unified_regression_r4/receipt.json)
- [新增GRANT的pair→case见证](../work/evening_2026_09_06/new_grant_pair_witnesses.json)
- [模型边界](MODEL_INPUT_CLOSURE.md)、[表空间资产条件](TABLESPACE_ASSET_REVIEW.md)、[条件准入提案](CONDITIONAL_ADMISSION_REVIEW.md)

## 交接后优先事项（未执行）

1. **先评审P1条件准入提案**：以INSERT普通冲突分支为正例，以资源池跨章冲突、
   ALTER TABLE不相关条件复用为反例。公共V1语义仍未修改，不能加通用放行开关。
2. **GRANT剩余9项**：补DBLINK、公共同义词授予权限的真实文档依据；不要求为了
   静态授权语法创建远端连接，不用已有ANY权限证据替代本分支依据。
3. **无候选包按真实资产推进**：模型需要身份/签名与训练预算，表空间需要服务端
   路径/所有权/恢复能力，TDE需要独立授权的密钥服务。已有输入SQL不等于这些资产就绪。
4. **数据库单独授权**：明确实例、版本、模式、角色、隔离、创建对象范围、恢复与Oracle
   后才执行代表性场景；不直接跑3921条，更不把SYSADMIN授权场景混入普通Smoke。

本晚后段代码保持冻结。若后续代码/规格变化，此回执只证明原输入版本，必须重新
生成并验证；保留首轮和第三轮失败证据，不累加不同轮次测试数量。21:00结束本窗口。
