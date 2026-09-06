# 第五批抽取与有限域生成结果（2026-09-05）

## 最终结论

20/20个新章节包已落盘，36个manifest生成192条候选（188正向 / 4目标负向）。
最新全量回归251/251通过（447.677秒），新增22项定向测试通过（5.031秒）。
20个新包的任务信封、lint、生成均返回0；全特性审计返回1并保持needs_review，原因是明确保留的能力/Oracle缺口。
单任务的36个manifest、192条case和完整审计结果均与统一生成快照逐项一致，来源哈希对账一致。
队列共30项（20新增+10已有提供者），全部needs_review；pending/failed/blocked/in_progress均为0。

本批以本地冻结PDF为唯一产品正文，不连接数据库、不执行SQL、不修改实例配置、不做Git提交或推送。
V1公共模型、生成接口和核心代码均未因这些章节发生变更。

## 指标与分母

| 指标 | 结果 |
|---|---:|
| 新主章 / 既有提供者 / 补充来源 | 20 / 10 / 4 |
| 本批主章原文行 | 2564 |
| source unit | 536 |
| confirmed fact | 496 |
| open question（包括待实现的能力profile） | 49 |
| manifest / 候选SQL | 36 / 192 |
| 正向 / 目标负向 | 188 / 4 |
| planned scenario | 37 |
| 明确needs_profile的文档特性条目 | 91 |
| 来源账本门禁 / 有限生成域门禁 | 20/20 / 20/20 |
| 严格全特性静态完成 / 数据库行为完成 | 0/20 / 0/20 |

“来源门禁”只表示行号、哈希、原子性和引用消费检查；**不是已经独立证明没有遗漏任何产品语义**。
Pairwise只覆盖已选入manifest的有限可行参数对，不等于所有笛卡尔积组合或任意多参数交互。
本批14个清单有适用的二元交互，其余清单按N/A记录，不虚报有Pairwise交互。

## 每个新包

| 包 | Manifest | SQL候选 | 正向 / 负向 |
|---|---:|---:|---:|
| alter_aggregate | 1 | 2 | 2 / 0 |
| alter_function | 4 | 39 | 39 / 0 |
| alter_materialized_view | 1 | 6 | 6 / 0 |
| alter_text_search_configuration | 2 | 12 | 12 / 0 |
| alter_text_search_dictionary | 1 | 5 | 5 / 0 |
| call | 1 | 4 | 4 / 0 |
| comment | 1 | 12 | 12 / 0 |
| create_aggregate | 2 | 12 | 12 / 0 |
| create_function | 2 | 20 | 20 / 0 |
| create_incremental_materialized_view | 3 | 10 | 8 / 2 |
| create_text_search_configuration | 2 | 12 | 12 / 0 |
| create_text_search_dictionary | 1 | 3 | 3 / 0 |
| do | 1 | 4 | 4 / 0 |
| drop_aggregate | 2 | 9 | 9 / 0 |
| drop_function | 3 | 11 | 11 / 0 |
| drop_text_search_configuration | 2 | 9 | 9 / 0 |
| drop_text_search_dictionary | 2 | 9 | 9 / 0 |
| explain_plan | 2 | 7 | 6 / 1 |
| refresh_incremental_materialized_view | 2 | 2 | 1 / 1 |
| rename_table | 1 | 4 | 4 / 0 |
| 合计 | 36 | 192 | 188 / 4 |

## 本轮关键校对

- 函数主体使用真实两个INTEGER输入和INTEGER返回，不输出参数名/函数体占位符。
  OR REPLACE现有目标的清单有真实已存在函数；新建清单保持目标不存在。
- CREATE/ALTER FUNCTION的COST边界和COMPILE签名差异分别留问题，不从相邻章节复制为同一规则。
- 聚集转换函数由CREATE FUNCTION包提供，Fixture拓扑确保先定义函数再创建聚集。
  BASETYPE与现代签名分支不同；不把原文注释SFUNC1/STYPE1当作语法参数。
- CALL有位置参数、:=和=>命名传参样例，参数名匹配真实前置函数；OUT/包/过程另列能力缺口。
- DO只生成无业务写入的plpgsql匿名块，不复制原文中的创建用户和批量授权示例。
- 文本搜索候选有内部功能测试门禁，词典创建及其依赖还要求SYSADMIN；
  不自动建立或删除角色，不写服务器字典文件，不把SYNONYM/SYNONYMS文档差异猜成同一个参数。
- ngram参数表已与PDF原页核对：gram_size为1～4，punctuation_ignore默认true，grapsymbol_ignore默认false。
  PARSER与COPY互斥，ngram参数不套用default解析器。
- ALTER映射替换具有真实原映射和新词典前置；重命名和迁移的对象有对应清理，不只改render文本。
- 增量物化视图用ASTORE、segment=off普通表；别名数匹配投影。
  别名错配、DISTINCT禁用、全量对象被增量刷新分别形成3条目标负向，不把fixture错误计入目标错误。
- COMMENT区分SQL NULL删除注释与文本内容，并测试中文和单引号转义。
  表/列以外的对象类型逐项列为needs_profile。
- 补读PLAN_TABLE正文确认会话生命周期、查询标签字段及SELECT/DELETE能力。
  EXPLAIN PLAN候选有fresh_dedicated会话门禁，ASCII 30/31字节边界含1条目标负向；
  非ASCII编码边界尚未生成，不能把Unicode字符数当通用字节数。
- RENAME TABLE/TABLES与单目标/双目标独立组合，用repeat渲染真实重命名对。
  B/5.7/s2特殊命名规则和临时/非临时混合另留场景。

## 验证证据

新增22项纯本地回归已通过，包含独立Pair投影、目标错误前置、真实Fact/Fixture依赖图、
SQL分号和无原始BNF、权限门禁、计划标签长度与快照结构。
最新全量测试251/251已通过，逐任务返回码和哈希保存在本地最终报告。
收尾对账检测到CREATE FUNCTION仍持有细化feature矩阵前的旧审计，已重新验证并与统一报告确认一致；
没有只核对case数量而遗漏审计快照差异。

- 目标测试：`work/doc2spec/batches/batch_05/tests_targeted.log`
- 全量测试：`work/doc2spec/batches/batch_05/tests_final_verified.log`
- 生成日志：`work/doc2spec/batches/batch_05/generation_final.log`
- 任务队列：`work/doc2spec/batches/batch_05/queue.json`
- 单任务对账：`work/doc2spec/batches/batch_05/verification/<factor>/`
- 最终机器汇总：`work/doc2spec/batches/batch_05/final_task_results.json`

首次可加载的全20包审计中，来源账本19/20通过，有限生成域20/20通过。
剩余1项为CREATE FUNCTION一组OUT规则被合在一个atomic unit，已拆成独立事实并登记grouped映射。
更早的编辑过程中出现过空Fixture setup、跨包Fact消费类型和Fixture引用错误，均由严格加载拦截；
没有降低lint/审计条件。没有完整记录所有编辑重试次数，故author_retry_count为null；
没有做独立盲审，独立盲审错误率也为null，而非0%。

## 全库与后续

本地全库目前75个包、1142个YAML、315个manifest，重新生成2845个唯一case_id、2818种SQL文本。
27个跨章BEGIN文本重叠保留来源，不删用例制造“SQL文本全唯一”。

规范化抽取与有限域候选交付可以继续扩批；内部功能、复杂函数、外部文件、
多会话和精确负向Oracle仍须独立能力/执行轨道处理。
不以91个未实现特性条目阻塞其他普通章节，也不把它们标成产品“不支持”。
