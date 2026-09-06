# 内部共享列契约：首轮实现

2026-09-06，承接用户批准的最小实施范围。实现位于 `core/shared_column_contract.py`，由 `core/finite_sql_contract.py` 调用；没有新增公共 YAML 字段、修改规格状态或连接数据库。

## 作用与边界

从当前用例真实、有序的 setup DDL 派生列事实，而不是从 `provides` 或名称猜测数据库对象。INSERT/UPDATE 共用这些事实，分别消费它们；SQL 文本不做 DEFAULT 替换。

| 共享证据 | 首轮范围 |
| --- | --- |
| 普通基表列 | 完整消费的有限 CREATE TABLE；整数、文本、布尔类型；顺序、名称、类型及有限长度、可空性 |
| 默认值 | 区分 absent、null、constant、dynamic、unparsed；仅前三种可进一步检查 |
| 默认值限制 | 整数范围、有限 ASCII 字符串长度、类型一致性；不能仅凭类型族相同就证明安全 |
| 视图列 | 单张普通基表的直接投影、显式列重命名和星号展开；列可追溯至基表列 |
| 证据身份 | 基表 DDL 哈希、列来源；视图 DDL 哈希；每次调用重新派生，不使用跨用例缓存 |

动态函数、域/生成列/identity、复杂或未消费的 DDL、表级约束等保持未知。首轮不证明普通表达式的全部范围、隐式类型转换或任意 NULL 写入。

### 语句消费不同

- INSERT：显式 DEFAULT、DEFAULT VALUES、显式列重排、无列名单时前 N 列映射，以及未提供的基表列。多行 VALUES 必须保持相同列宽。
- UPDATE：仅检查 SET 中明确赋值的列，不填充未赋值列，不把 INSERT 的省略逻辑用到 UPDATE。
- 视图 INSERT：检查投影列，并检查未写入的基表列是否有有限默认值/可空证据；视图 UPDATE 不把未更新的基表列当作遗漏输入。
- 视图 DEFAULT **尚未证明**，不直接继承基表默认值语义。REPLACE DEFAULT、INSERT ALL 默认值扩展也不在本轮范围。
- CHECK OPTION、READ ONLY、WHERE 过滤视图、计算列、连接/嵌套视图和触发器/RULE 不会被本轮提升为有限直接投影证明。

共享契约无法建立时，原有的有限形状检查仍可以检查它原本覆盖的事项，但不能因此新增默认值证明。`checks` 中的 `shared_constant_or_null_defaults`、`insert_omitted_base_columns`、`single_base_direct_view_columns` 标记新增检查范围，不表示运行成功。

## 失效与溯源

原检查器继续对 ALTER/DROP、事务终结和不透明执行撤销表证据。视图血缘使用创建时基表证据，后续 DDL/生命周期变更保守撤销视图证据；即使 DROP 后以完全相同 DDL 重建基表，也不能给旧视图重新绑定。明确 DROP 后重新 CREATE 的普通表可以重新建立证据。

视图的失效目前是保守范围：后续无关 DDL 也可能使其待审，尚不是最小受影响对象级重建。SET/RESET、触发器/RULE 上下文不新增共享证据。

产品依据沿用当前冻结 PDF 和既有事实：

- `insert::insert_fact_default`、`insert::insert_fact_column_mapping`。
- `update::update_fact_default`、`update::update_fact_view_subquery_restrictions`。
- `create_view::cv_fact_updatable_column_criteria`、`create_view::cv_fact_updatable_view_definition`。

本轮对账脚本核对上述事实存在且已确认，并将对应正文磁盘哈希与包内声明对账。运行记录同时绑定生成报告、包和工具链。`audit_rendered_sql_contracts.py` 现将主检查器及共享模块共同纳入 checker 哈希，避免只改共享模块而证据身份不变。

底层 `inspect_write(sql, setup)` 是无 Registry 的有限函数，不自行加载 PDF/Fact Registry。队列原有来源/依赖/工具链 freshness 门禁仍负责验证快照是否可沿用；脱离队列单独阅读旧 JSON，不能视作当前有效证据。

## 固定分母结果

在未修改 224 个包 YAML 的前提下重新生成全部 525 个 manifest：3830 条完整用例记录及 525 个 SQL 快照保持一致，报告差异仅为输出路径。包级来源/生成/静态覆盖结论不因这次内部检查器增强而改写。

| 有限写入审计状态 | 之前 | 本轮 |
| --- | ---: | ---: |
| checked | 134 | 175 |
| needs_review | 78 | 37 |
| rejected | 2 | 2 |
| not_applicable | 3616 | 3616 |

41 条 `needs_review → checked`：INSERT 31、UPDATE 10；按期望分为正向 39、负向 2。负向用例的写入形状可检查，**不代表目标错误 Oracle 已满足**。未新增正向矛盾，没有撤回原 checked 用例。

被解除的第一停止原因：DEFAULT 24、DEFAULT VALUES 输入 6、省略列 3、视图对象证据 8。它们不是全部特性的覆盖率；剩余 37 条包含视图 DEFAULT、子查询/递归 CTE、复杂目标及语法形式等。

## 重跑与证据

不执行数据库的入口：

```bash
python3 -m unittest tests.test_shared_column_contract -v
python3 scripts/generate_factor_package_sql.py --output-dir work/shared_column_2026_09_06/generated
python3 scripts/audit_rendered_sql_contracts.py --generation-report work/shared_column_2026_09_06/generated/generation_report.json --output work/shared_column_2026_09_06/rendered_final.json
python3 work/shared_column_2026_09_06/reconcile.py
```

该对账脚本固定本轮基线哈希；输入版本变化后应新建批次，不放宽断言、覆盖旧基线或借历史结果宣称当前通过。专项、API/回归及来源依赖测试日志位于 `work/shared_column_2026_09_06/`。本轮未重跑全项目全部测试；测试验收以本轮结果记录为准。

数据库执行仍需独立授权。本轮未升级 manifest、包 ready、Oracle 或 56 个无普通 manifest 包的状态。

## 六小时推进 Batch02 补充

原始首轮结果保留在上文；后续版本证据独立保存在 `work/autonomous_2026_09_06/`。

- 依据INSERT物理1737–1738页，普通基表的显式列名单可搭配DEFAULT VALUES；仍校验列名、重复列及所有未提供基表列的默认值/非空证据。视图DEFAULT仍待审。
- 基于完整普通基表和直接用户列投影的封闭依赖证据，有限无关普通CREATE/DROP TABLE可不再撤销视图；同名/schema歧义、基表/视图自身变化、未知DDL、动态默认依赖及不透明生命周期仍撤销。CASCADE只在该封闭依赖范围内判断，不作一般安全执行授权。
- 新版候选/用例不变；本批初次静态对账新增7条有限证据（6正向、1负向），175→182 checked、37→30待审。目标错误和数据库行为仍未验证。
- Batch01的543项全项目回归通过发生在上述补充之前，不能当作Batch02代码的全项目回归。Batch02验收以本批带哈希的专项/API日志与reconciliation为准。

## 六小时推进 Batch03：直接投影派生目标

- 直接解析INSERT INTO/UPDATE目标中的真实SELECT，不合成CREATE VIEW、不重写SQL、不用虚构对象名替换目标。命名视图与派生目标共享直接列投影/重命名的血缘检查。
- 仅支持一个具有完整普通列契约的基表、直接用户列投影；列别名、投影重排与省略基表列沿用共同校验。INSERT省略基表必填列仍可发现矛盾，UPDATE未修改列不会误用INSERT省略逻辑。
- WHERE/连接/嵌套/CTE写入目标、派生目标UPDATE FROM、多目标派生关系、CHECK OPTION/READ ONLY仍需要单独契约；派生目标DEFAULT也不直接继承基表默认值证明。
- 防止悬空AS及查询子句关键词被当成有效目标别名；不完整目标保持needs_review。
- 检查范围增加`single_base_direct_derived_target_columns`。固定3830用例重新生成，224包和525快照不变；本批9条needs_review→checked（7正向、2负向），182→191 checked、30→21待审。该提升不代表完整SQL或目标错误Oracle通过。
- 当前本批专项102项通过；API结果与最终验收应以`work/autonomous_2026_09_06/batch03_reconciliation.json`收录的完整日志为准，不能沿用Batch01全项目通过宣称最新版全部回归通过。

剩余视图/派生目标DEFAULT需继续保守：本地ALTER VIEW正文物理1349页SET/DROP DEFAULT注明“该参数暂无实际意义”，而INSERT/UPDATE只给出一般DEFAULT说明。当前没有足够的优先级/生效路径证据，不能因为目标列有基表血缘就推断视图DEFAULT继承行为；也不能把语义未知改成产品不支持。

## 六小时推进 Batch04：有限多目标关系绑定

UPDATE table_list正文与SELECT from_item共同确认了普通表ONLY/*和括号子查询alias的结构。多目标入口现在可完整消费普通首项及后续的单基表直接投影项，仍要求不同显式alias和有限字面量赋值，检查实际投影列而非只看基表列。

`finite_multi_target_relations`仅表示有限关系绑定，不证明赋值顺序、连接基数或跨目标引用语义。相同基表经两种alias/视图出现、限定名与非限定名的同basename歧义、未知FROM和FROM别名冲突保持待审；两个明确不同schema对象不因此混同。单个派生目标FROM、派生首项的多目标扩展、复杂关系和跨目标RHS不在本批新增范围。

两条实际正向用例由待审转为有限可检查：`manifest_update_multi_syntax_positive_07f6ce88a2fe`、`manifest_update_multi_syntax_positive_d9578a392d1f`。固定3830用例、525快照、224包不变，193checked/19needs_review/2rejected/3616不适用；未产生正向rejected。专项110项通过，API与哈希对账以本批`batch04_reconciliation.json`日志清单为准，静态结果不代表实机执行。

## 六小时推进 Batch05：有界递归CTE

有界递归输出现在可连接INSERT/UPDATE列契约。范围严格限定为一个CTE、完整且唯一的显式列名、一行字面量VALUES种子、UNION ALL、一次直接自身FROM、一个整数计数列正向递增与常量`<`/`<=`上界，其他列原位保持。

分别检查种子与递归项的列数和类型、计数列身份，以及种子/步长/边界/最后产出值的int32范围。闭式计算边界，不执行或展开递归；20亿步范围的单元输入也不会创建20亿行。`bounded_recursive_cte_columns`是这类有限数学形状的证据，不是通用递归SQL/物化计划/结果集/执行耗时的保证。

多CTE、多个种子行、额外UNION、连接、类型变换、缺少进展/上界、整数溢出、未知函数和DML CTE仍待审。即使主句未引用CTE，也检查其定义；CTE仍是只读输出，不能成为可写fixture。

固定基线三条递归正向用例由待审转为可检查，196checked/16needs_review/2rejected/3616不适用，未新增正向rejected。224包、3830完整case及525SQL快照不变；120项专项通过，API与最终对账仍以`batch05_reconciliation.json`实际日志清单为准。

## 六小时推进 Batch06：DML CTE写入与RETURNING

只为单个非递归、直接普通基表INSERT/UPDATE CTE新增有限检查：将内层真实SQL与本用例原始有序setup传给已有inspect_write，内层先通过后，再校验RETURNING直接列、AS输出名或星号展开。没有根据字典伪造CREATE TABLE，也没有改写为SELECT绕开写入检查。单元测试明确断言原setup对象传递及一次内部调用；入口限定非WITH DML，使该复用深度有界。

`finite_dml_cte_write_and_returning_columns`和`dml_cte:`前缀区分内层与主句检查。内层缺列、列宽、未知默认及真实setup失效按原错误code和阶段向外传播。缺RETURNING、重复输出名、计算输出、CTE被当可写目标、多CTE依赖、递归DML、DELETE CTE仍不能由此放行。

本批不验证内外语句的实际执行顺序、数据可见性、affected rows、返回结果或目标SQLSTATE。INSERT物理1739页特别区分附RETURNING的DML CTE回显计数，不能把有限输出列契约当计数Oracle。

三条正向用例迁移后，固定基线为199checked/13needs_review/2rejected/3616不适用，零正向rejected；224包、3830完整case、525SQL快照不变。130项专项通过，API和最终哈希对账见`batch06_reconciliation.json`；下一轮应冻结当前代码做全项目回归，不能继续沿用早期543项结果。

## 六小时推进 Batch07–08：完整回归与有限DELETE CTE

Batch07已对Batch06核心版本跑完整项目：587项 / 1195.028s / OK。结果与工具链、包、生成报告及来源哈希绑定于`batch07_full_reconciliation.json`。测试文件仅保存结束哈希，未单独采集开跑前哈希；该限制保留，不事后补造证据。下述Batch08修改后，587项不能当作新版本完整验收。

Batch08只扩展单个非递归DELETE CTE：直接普通基表，无WHERE或一个真实列与同类型字面量的等式；随后复用RETURNING直接列/AS/星号校验。实际有序setup失效、缺列、USING、复杂谓词、别名/分区/多目标、游标、额外尾部和计算返回值仍按矛盾或未知处理。主语句DELETE仍不在现有有限写入审计范围内，不批量改变其他因子的not_applicable状态。

`dml_cte:delete_base_target`、`dml_cte:delete_no_predicate`或`dml_cte:delete_finite_equality_predicate`明确本轮证据范围；无WHERE可检查不代表允许执行全表删除。行数、触发器、返回结果和并发可见性仍需独立Oracle与执行授权。

真实用例`manifest_update_cte_syntax_positive_2839d16e4e93`增加有限证据，lifecycle仍待审。最终200checked/12needs_review/2rejected/3616不适用；224包、3830完整case、525SQL快照保持一致，零正向rejected。Batch08专项138项加API/进度15项共153项通过，对账见`batch08_reconciliation.json`。旧失败日志保留，简单DELETE旧断言改为具体scope测试，同时保留复杂DELETE待审边界；没有改规格expected。

剩余10条视图/派生DEFAULT与2条IGNORE负向仍待审。IGNORE负向manifest已经有B/5.7/s1环境门禁、目标规则与needs_verification Oracle，不能把它们误报为缺失或再次生成同类文件凑进度。本轮只改善有限检查器，不升级包ready或数据库验证结论。

## 最后诊断澄清（Batch19）

视图/派生DEFAULT现在明确报告应用语义尚未建立，基表血缘本身不证明默认值继承。它与普通列没有完整默认值metadata分开，但仍是`default_unknown`和`needs_review`。普通动态/未知默认值保持原分支。没有替换SQL里的DEFAULT，也没有推断产品不支持。

`work/autonomous_2026_09_06/batch19_diagnostic_reconciliation.json`验证仅10条问题的detail改变，其余3820条完整写入审计记录和独立DELETE的71条记录不变；覆盖收益为0。`batch19_reconciliation.json`纳入189专项+15 API共204项，224包/525快照/3830完整生成用例保持一致。最终完整回归以`batch20_final_full_receipt/receipt.json`实际结果为准；旧629项是此文案修改前版本，不当作最新版完成证据。

最终收据已完成：633项/1255.291秒/OK，实际进程退出0。`final_evidence.json`核对完整/专项/API三份起止输入和当前7503文件清单一致，原224包/3830完整case/525快照不变。诊断修改未升级12条待审或任何包/Oracle状态；最终总结见同工作目录的`final_report.md`。
