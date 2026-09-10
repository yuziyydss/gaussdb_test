# 从静态候选到受控执行：离线准备批次

这一步不是数据库执行器，也不是“可直接运行”的认证。它把真实生成候选与真实场景逐步对齐，提前暴露名字、seed、步骤预期和清理归属之间的不一致。数据库执行仍须单独授权。

## 如何使用

在项目根目录运行（路径需要是一个尚不存在的新文件）：

```sh
GAUSSDB_ENABLED=false /usr/bin/python3 scripts/prepare_execution_batch.py --output work/execution_review/batch_01.json
```

脚本只读取规格并离线生成；没有 execute 参数，不导入数据库执行器、不连接或创建数据库。输出已存在时拒绝覆盖。所有规格和核心输入的 SHA256 写入产物，编译期间输入变化则拒绝发布；不能拿旧准备报告替代后续改动后的重验。

当前范围固定为 5 包、8 份 manifest、14 个候选、9 条场景序列：一般 INSERT、CREATE INDEX，以及 M SELECT、INSERT、UPDATE。不是全库认证，不新增虚构用例凑数量。

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

当前 ownership_plan 只对有限 CREATE TABLE/SCHEMA 与 DROP 名称和顺序做静态核对，记录“需要成功回执”，不声称已拥有对象。拒绝预先盲 DROP、CASCADE、无对应创建的清理及仅 BEGIN/ROLLBACK 的生命周期。它不是通用 DDL 安全审计，未来执行器还必须验证真实归属、依赖和目标创建记录。

一般 PG/A/B 与 M 必须按物理模式分组；改变 search_path 不能改变数据库兼容模式。M 准备引用现有 generated/m_compat_environment/plan.json：获授权后才可在非 M 管理连接上可选创建新 M 数据库，随后物理重连、检查 datcompatibility，再创建独占 namespace。新建与获批复用路径不同，不生成物理库 DROP。旧执行器的 M 路径仍阻断，本模块不解除该限制。

## 下一步

内网执行前按报告逐项校准 Oracle，并对明确授权的运行器验证连接、归属回执、失败阶段和清理逻辑。不要手改生成 SQL、不扩大到全库执行，也不把准备计划里的 failure_policy 描述当成已实现的运行时状态机。其他静态缺口可继续独立推进，无须为等待数据库授权暂停全项目。
