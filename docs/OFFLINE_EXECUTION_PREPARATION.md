# 从静态候选到受控执行：离线准备批次

这一步不是数据库执行器，也不是“可直接运行”的认证。它把真实生成候选与真实场景逐步对齐，提前暴露名字、seed、步骤预期和清理归属之间的不一致。数据库执行仍须单独授权。

## 如何使用

在项目根目录运行（路径需要是一个尚不存在的新文件）：

```sh
GAUSSDB_ENABLED=false /usr/bin/python3 scripts/prepare_execution_batch.py --output work/execution_review/batch_01.json
```

脚本只读取规格并离线生成；没有 execute 参数，不导入数据库执行器、不连接或创建数据库。输出已存在时拒绝覆盖。所有规格和核心输入的 SHA256 写入产物，编译期间输入变化则拒绝发布；不能拿旧准备报告替代后续改动后的重验。

输入指纹包括fixture `assets/`下实际文件的字节（如TSV/CSV/二进制资产），不只记录YAML里的文件名。
资产新增、删除或内容变化都会使旧准备包过期；不跟随输入符号链接。静态回归收据采用相同资产边界，
避免测试期间只修改seed文件却仍报告输入未变。纯复核笔记不属于离线执行输入；此指纹也不证明
内网原始PDF已同步、库模式已核实或文件内容已上传到数据库机器。

默认`baseline`仍为5包、8份manifest、14个候选、9条场景序列：一般INSERT、CREATE INDEX，以及M SELECT、INSERT、UPDATE。不是全库认证，不新增虚构用例凑数量。

新增`semantic_contracts`离线审查批次：3包、4份manifest、7个真实候选、6条场景序列，包括部分唯一表达式索引的三个INSERT结果、外表ALTER负向、普通元组写入和M生成列写入。候选按manifest去重，场景各自初始化fixture；不是把三种INSERT结果连起来执行。

```sh
GAUSSDB_ENABLED=false /usr/bin/python3 scripts/prepare_execution_batch.py --profile semantic_contracts --output work/execution_review/semantic_01.json
```

未知profile拒绝，不自动退回默认。外表候选已可识别有限log_fdw服务器、schema及单TEXT列外表的双依赖与清理顺序；物理模式仍未选定，目标错误仍需校准，因此继续列为blocked。负向步骤显式声明`expected: error`，不能继承成功默认值。各profile的实时状态以新生成的summary和逐单元阻断为准。

`foreign_options`为ALTER FOREIGN TABLE的4份manifest、4个候选和4个独立单步骤场景：省略ADD、ADD、SET、DROP latest_files。前两者初始化无该选项的外表，后两者先ADD值2，再分别执行SET值5或DROP。四个场景绝不共用上一个目标的运行状态；Oracle仍是待校准目录断言，物理模式未定，不能据此直接执行。

```sh
GAUSSDB_ENABLED=false /usr/bin/python3 scripts/prepare_execution_batch.py --profile foreign_options --output work/execution_review/foreign_options_01.json
```

## 对齐了什么

每个场景采用自己的真实 fixture 依赖顺序，保留 setup、seed、teardown 和完整原始候选字段。字面 SQL 步骤必须唯一对应同包、同 SQL token、同 setup 签名和同 teardown 的候选，不能只凭看起来相似的 SQL 关联。

自动命名的候选使用声明式绑定，不另写一份 SQL。例如：

```yaml
steps:
- id: visible
  candidate:
    manifest_ref: manifest_create_index_visibility_a_fresh
    params: {visibility_clause: ci_visibility_visible_a_fresh}
```

这表示“从该 manifest 中选出可见性维度取此值的唯一真实候选”。加载时检查字段形状、同包 manifest 和取值所属 bindings；编译时重新生成该 manifest，核对完整候选字段、唯一性和相同生命周期。候选 SQL 原样进入 resolved_sql，不能同时给 candidate 和手写 sql，也不凭 case_id 前缀或手工替换字符串判断身份。零个/多个匹配都阻断；声明绑定不会使缺失 fixture 或未知 Oracle 自动通过。

Token 身份比较只忽略非引号内的大小写和空白；字符串、引号标识符和实际对象名称不改变。它不是 SQL 解析器，也不证明语法、类型或执行安全。

一个场景序列只初始化一次 fixture，步骤间共享状态；不同场景必须重新隔离。例如 INSERT 元组冲突场景的第二步期望同时包含第一步已更新的行和第二步新增的行。这个期望不能移植给“重新建表、只跑第二个候选”的独立测试。

Oracle 必须定位到唯一目标步骤。多步骤场景的无 step_id 断言会阻断；单步骤可以唯一推断。空场景、缺 Oracle、缺 expected 不会默认通过。未知 SQLSTATE、未校准目录字段和手工断言保留待校准，不能把任意错误当成负向命中。

`affected_rows`现在可离线绑定到唯一、预期成功的INSERT/UPDATE/DELETE目标步骤，prepared Oracle标明`measurement_source: target_command_affected_rows`。expected必须是非负整数，布尔值、字符串、浮点数和缺值均不接受；不能附带另一条SQL把SELECT结果数当影响行数。WITH开头等未审核DML形态继续阻断。需要校准的合法断言仍pending，非法断言不能借pending绕过校验。

这是断言准备，不是已实现的运行时判定器。未来执行器必须先确认目标命令成功，再读取该命令的影响行数；驱动返回未知值（例如-1）、目标报错、读到了后续查询的rowcount都不能计作命中。INSERT DO NOTHING冲突场景的0来自模型预期，不证明驱动已经返回0，也不证明触发器/多语句等泛化场景的计数语义。

## 当前结果与真实缺口

初版只有 11/14 个候选绑定成功，3 个 CREATE INDEX 候选的自动名字与场景里的 observed 名字不同。补声明式绑定后，14/14 候选能够定位，可见性手工断言也分别绑定到实际步骤。生成 SQL、case_id、seed 和预期字段均不因此改写；初版失败证据仍保留。

9 条场景序列中，3 条离线绑定完整、6 条等待 Oracle 校准。后者包括索引注释/可见性元数据、M COUNT 返回类型和 M 生成列目标错误。这个数字不等于 3 条数据库验证成功，实机验证仍是 0。

M COUNT 的四个计数结果是 0、0、0、2；返回 BIGINT 的驱动/目录类型判断仍有 4 个手工校准点。M 生成列的 3 个负向步骤仍没有已核准 SQLSTATE。这些缺口必须保留在准备报告中。

## 执行前必须另行满足

| 环节 | 必要证据与失败处理 |
| --- | --- |
| 环境 | 明确授权、物理数据库模式、权限及能力门禁；失败不进入 setup，不记作目标负向成功 |
| 隔离 | 各模式使用独立且已核实的连接；每条场景拥有独占 namespace；固定名字必须预检不存在 |
| Setup/seed | 逐条记录成功创建的对象和失败阶段；部分 setup 失败跳过目标，保留已创建对象清单 |
| 目标 | 记录实际 SQL、返回结果/原始错误；目标 CREATE 也必须单独记入实际归属清单 |
| Oracle | 正向核对真实结果；负向只能匹配已校准目标错误；未校准为 pending，不是 pass |
| 清理 | 只清理本次成功创建且身份核实的对象；清理失败单独报告，不覆盖先前失败；最后检查残留 |

当前ownership_plan对有限CREATE TABLE/SCHEMA及普通B-tree CREATE INDEX做名称与依赖顺序核对。索引仅能依赖本fixture先创建的普通表；只识别普通列或`列+非负整数`键、可选`列>非负整数`谓词，其他方法、CONCURRENTLY、IF NOT EXISTS、任意函数等保留未审核阻断。索引未写schema时按已明确的所属表schema登记；不猜测search_path中外部对象的身份。

索引可显式先DROP INDEX再DROP TABLE，或随所属表DROP列为dependent_indexes。后者明确要求运行时核对依赖清单与各创建回执，不能将静态推断作为删除既有索引的授权；表已清理后再次DROP INDEX会阻断。所有runtime_ownership_proven仍为false。该功能不检查任意索引表达式的语义，也不把本次DDL名称识别当作数据库语法认证。

拒绝预先盲DROP、CASCADE、无对应创建的清理及仅BEGIN/ROLLBACK的生命周期。它不是通用DDL安全审计，未来执行器还必须验证真实归属、依赖和目标创建记录。

外表资产只接纳已审核的g_a3_测试命名空间、无额外OPTIONS的log_fdw服务器，以及`(col1 TEXT)`/`logtype 'gs_log'`的schema限定外表。服务器和schema必须已在同一fixture前序声明创建；外表同时依赖二者，所有依赖外表清理前不能DROP父资产。SERVER属于数据库级命名空间，独占schema不能替代服务器名预检。实际预存同名与运行创建失败无法离线检测，所有资产仍要求不存在预检与成功创建回执，runtime_ownership_proven始终false。尚未允许任意FDW、文件读取、任意列/选项；物理模式、权限和目标Oracle仍是独立门禁。

选项seed仅接受在上述已登记外表上执行`ADD latest_files '2'`。有限CREATE没有latest_files，计划记录`required_before: null`（选项不存在）→`planned_after: '2'`，以及目标创建成功和该seed成功回执要求；重复ADD、先于CREATE、错对象、其他值、SET/DROP作为seed、任意ALTER都拒绝。该识别与生成器共享同一个有限seed检查。`setup_mutations`不证明实际状态已变化；运行时任何seed失败都应跳过目标并保留本次已创建对象的清理清单，不能把失败记作负向目标命中。

一般 PG/A/B 与 M 必须按物理模式分组；改变 search_path 不能改变数据库兼容模式。M 准备引用现有 generated/m_compat_environment/plan.json：获授权后才可在非 M 管理连接上可选创建新 M 数据库，随后物理重连、检查 datcompatibility，再创建独占 namespace。新建与获批复用路径不同，不生成物理库 DROP。旧执行器的 M 路径仍阻断，本模块不解除该限制。

## 下一步

### 文件输入的离线交付阶段

`prepare_unit` 对现有一般章 `load_data` 的 B 模式、非 LOCAL 服务器文件输入，
新增条件性的 `file_preparation_plan`。它只读取已绑定到步骤的候选，重新用场景
fixture 验证仓库 TSV 的字节/哈希/行列数及目标路径，并与候选 `file_assets` 全字段
对账。未绑定候选的文件不加入部署清单；缺失、伪造部署状态、路径不匹配或冲突
不能静默通过。相同资产被多个步骤使用时，保留每个步骤依赖。

该阶段位于环境核验之后、setup/目标之前。每个文件单独要求服务器/数据库身份、
无既存文件的独占路径、人工部署授权、服务端 SHA256、读取权限、safe_data_path
白名单、部署归属回执和清理残留检查。文件阶段失败必须阻止 setup 和目标，不能
算目标负向命中。只可清理本轮实际部署且身份/哈希复核一致的文件，不提供删除命令。
部署前置证据在 `required_receipts`，清理后置证据在 `cleanup_required_receipts`；
清理结果不作为目标执行前置，不能形成永远无法满足的循环依赖。

这些是**待取得的证据**，不是已完成部署：`deployment_authorized`、
`runtime_verified`、`runtime_ownership_proven` 均为 false。没有传输文件、读远端、
覆盖文件、数据库执行或自动清理。LOCAL 位置/协议、复杂 M 文件变体及输出文件尚未
复用此有限合同，遇到时保留 `file_location_contract_unreviewed` 阻断。
无文件依赖的既有离线批次保持原字段与行为；本次未修改候选 SQL 或扩大执行授权。

M 模式现仅接入 `scenario_m_load_data_plain_rows`：唯一绑定既有空表候选
`manifest_m_load_data_empty_005f904071c2`，不新增或改写SQL。该输入没有LOCAL、
REPLACE/IGNORE、SET和跳行，省略列列表对应原文“使用所有字段”，两列整数TSV
与实际建表列序对齐，预期三行 `(1,10)/(2,20)/(3,30)`。字段缺省TAB，SQL中行
终结符为真实LF；不能换成未经核验的反斜杠转义。准备器同时检查实际空表DDL、
文件哈希、清理身份与M/SYSADMIN/enable_copy_server_files声明，不根据包名放行。

M 来源为本地PDF第二章2.4.2.13.1：L8–20权限/路径、L61–73文件位置、L95默认TAB、
L125–127省略列列表。LOCAL是否来自客户端还取决于远程传输选项，本次不处理。
M 连接仍引用原M数据库准备方案，需明确授权并核实物理模式，不以search_path替代。
文件部署在setup前；目标表INSERT/DELETE权限在setup成功后、目标执行前检查，
记录于文件项的 `target_required_receipts`，不能要求新表创建前取得该表权限证据。
这些全部是离线待满足条件，场景仍planned，旧复杂场景与章节覆盖缺口保留。

内网执行前按报告逐项校准 Oracle，并对明确授权的运行器验证连接、归属回执、失败阶段和清理逻辑。不要手改生成 SQL、不扩大到全库执行，也不把准备计划里的 failure_policy 描述当成已实现的运行时状态机。其他静态缺口可继续独立推进，无须为等待数据库授权暂停全项目。
