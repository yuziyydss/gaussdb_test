# 按包收敛真实缺口：首批

2026-09-06。范围为本地冻结 PDF 对应的 224 个包，不沿用历史 226 包或其他数据库环境的通过率。本批只做静态工作；没有数据库执行、Git 提交或推送。

本文保留首批历史口径。后续结果见[同日晚间阶段进展](PACKAGE_CLOSURE_EVENING_2026_09_06.md)，不要把首批3830条与晚间新增候选混算。

## 先看什么

- [全部包的分类表](../work/package_closure_2026_09_06/after_backlog.md)：168 个有候选包的分类缺口数量，以及 56 个无普通清单包的资产路线。
- [逐条缺口账本](../work/package_closure_2026_09_06/after_backlog.json)：每条有稳定 ID、包、实体文件、原始诊断、事实引用、来源行、下一步和验收条件。
- [本批前后对账](../work/package_closure_2026_09_06/reconciliation.json)：既有完整用例、SQL 快照、来源哈希和未关闭缺口的保留证据。

这些是问题清单，不是覆盖率。多条信号可能描述同一问题；planned 场景也会进入待办。源文件存在、能生成、静态覆盖和实机验证继续分开。

## 168 个有候选包的实际缺口

| 信号 | 条目数 | 涉及包数 | 如何理解 |
| --- | ---: | ---: | --- |
| 待确认事实 | 530 | 165 | 包括原文歧义和运行时条件，不是 530 条已确认错误 |
| 取值覆盖缺口 | 128 | 11 | 含未选择条件值、有效值缺正向等，不能一律自动补正向 |
| 规则证据缺口 | 1 | 1 | CREATE SEQUENCE 系统列规则缺目标负向证据，不代表只剩一条产品规则 |
| 特性覆盖缺口 | 801 | 153 | 已登记但尚缺完整生成表达的分支 |
| 待实施场景 | 445 | 168 | 本批新增的 INSERT 具体行结果计划也计入待办 |
| 缺场景的事实 | 7 | 7 | 与上一行可能重叠，不叠加计算场景覆盖率 |
| 待校准错误 Oracle | 98 | 42 | 这是清单信号；不能以 setup 错误满足目标错误 |
| 生成异常 / 缺 pair / 重复 ID 或同包 SQL | 0 | 0 | 仅限当前已选有限域，不代表产品语义全覆盖 |

当前仍为 525 个普通清单、3830 条完整候选、3802 种 SQL 文本。168 包有候选、56 包无普通清单；有候选且达到既定静态审计标准的仍为 abort、deallocate、rollback 三包。运行证据未接入，不据此给实机通过率。

按实际实体再次细分 128 个取值信号：69 个声明为 conditional、9 个声明为 invalid、50 个声明为 valid（其中 GRANT 占 49 个，ALTER TABLE 占 1 个）。这只是当前规格的标签，不重新证明产品合法性。三类分别需要条件证据、目标负向 Oracle、正向选择及兼容前置条件，不能交给同一个“补 bindings”脚本。

| 包 | valid 缺口 | conditional 缺口 | invalid 缺口 |
| --- | ---: | ---: | ---: |
| alter_package | 0 | 4 | 0 |
| alter_resource_pool | 0 | 1 | 0 |
| alter_table | 1 | 12 | 1 |
| create_database | 0 | 37 | 5 |
| create_index | 0 | 6 | 2 |
| create_resource_pool | 0 | 1 | 0 |
| create_sequence | 0 | 1 | 1 |
| delete | 0 | 2 | 0 |
| grant | 49 | 0 | 0 |
| insert | 0 | 4 | 0 |
| update | 0 | 1 | 0 |

## 本批做了什么

### 1. 修正缺口清单本身的漏项与定位

修改已有 `scripts/build_quality_backlog.py`，没有新增一套审计引擎：

- 补入未消费、消费者类型不符、未记账事实及缺失来源行等静态阻断信号。
- 修复规则诊断带后缀时丢失实体定位的问题，例如 `规则ID: not targeted by a negative manifest` 现在仍能追到真正规则、事实及原文行。
- 按包输出事实、取值、规则、特性、场景、Oracle、生成、资产八类缺口。
- 对 56 包的路线校验成员完整性与唯一性，路线统一标为 `not_assessed`，不自动推导支持性或就绪状态。

### 2. INSERT：把笼统计划细化为三个行结果契约

新增 [PG 冲突行结果场景](../specs/dml/insert/scenarios/conflict_pg_rows.scenario.yaml)，复用原有真实主键表及 id=101 的既有行：

| 分支 | 目标 | 预期查询结果 |
| --- | --- | --- |
| 指定冲突列 | `ON CONFLICT (id) DO NOTHING` | `(101, 'existing', NULL)` |
| 不指定冲突列 | `ON CONFLICT DO NOTHING` | `(101, 'existing', NULL)` |
| 更新非键列 | `ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note` | `(101, 'alpha', NULL)` |

每个分支要单独建立 fixture，核验 PG 模式、权限和专用空 Schema；已有 fixture 含 `DROP ... CASCADE`，不得在共享 Schema 运行。Oracle 必须验证确切结果行，不只看 SQL 是否成功。

**没有新增普通 INSERT manifest。** 试配清单时，加载器明确拒绝正向绑定 conditional 值；当前 V1 也只接受 positive/negative 两种 suite。试配文件已撤回，没有修改这两项门禁。三个分支目前只是 planned 场景蓝图，不算生成候选，INSERT 的四个取值缺口全部保留。

这暴露的是共性的“条件合法性如何被证明”问题，不能通过改成 valid、冒用负向或临时添加 suite 类型绕过。

### 3. CREATE MODEL：先准备真实输入，不冒充模型存在

新增 [训练输入 fixture](../specs/ddl/create_model/fixtures/training_input.fixture.yaml) 与 [输入核验场景](../specs/ddl/create_model/scenarios/training_input.scenario.yaml)：

- 按本章正文 L202–L230 保留八列及十五行，只更换为专用测试表名。
- 字段类型、空值声明与 DDL 一致；样例 seed 有独立归一化哈希及本地原文逐行对照测试。
- 生命周期为独立连接的 BEGIN → CREATE TABLE → INSERT → ROLLBACK，不预先删除同名对象。
- 精确十五行、列契约和回滚清理都是待执行断言；不训练、不预测、不关闭超时、不清理模型。

fixture 的 `execution.status: ready` 只表示已有生命周期 SQL；fixture 本身仍 `needs_review`，场景仍 `planned`，CREATE MODEL 仍无普通清单。模型训练预算、算法冲突、成功创建记录和跨 CREATE/PREDICT/DROP 身份传递没有因此完成。

## 56 个包的推进路线

| 类别 | 包数 | 本阶段要求 |
| --- | ---: | --- |
| 当前 PDF 明确限制当前形态 | 6 | 保留来源与包分母，不扩展成所有版本不支持 |
| 内部或工具接口 | 15 | 需要真实工具身份、调用协议及恢复资产 |
| 外部资产或驱动 | 15 | 需要驱动、模式、文件、密钥或端点；不造空资产 |
| 隔离管理生命周期 | 14 | 先落实专用目标、所有权、恢复和执行授权 |
| 模型与计划语义 | 6 | 分开准备输入、模型身份、预测形状和清理契约 |

完整成员、来源依据和验收要求见 [路线表](NO_MANIFEST_REVIEW_ROUTES.json)。本批推进的是最后一类的训练输入子资产，不把六包或全部 56 包批量升级。

## 保留的具体阻断与下一步

1. **优先评审条件值准入共性契约。** 明确每个 conditional 值需要的条件、条件依据、manifest 门禁与 fixture 能力分别证明什么。环境键碰巧相同、仅有 PG 字样或任意 fixture 引用都不是充分证明。未满足时继续阻断正向；invalid 不得被环境门禁洗成合法；无实机证据不得升级执行状态。先用 INSERT 和资源池 MAX_DOP 三包检查重复性，确认可兼容现有 V1 后再实现，不直接加通用绕过开关。
2. **CREATE SEQUENCE 系统列。** 普通 id 或自行创建的 rowid 列不能证明真实系统列；需要正确表形和专用目标 Oracle。规则缺口仍为 1。
3. **ALTER PACKAGE 编译。** 本章注意事项称当前只支持 OWNER，但语法/示例出现 COMPILE；保留来源冲突，不只凭语法补四个成功值。
4. **CREATE/PREDICT/DROP 模型输入对接。** 已有表和 seed 后，下一步是有限 FEATURES/TARGET 输入形状与模型签名设计；训练成功记录及清理权仍独立，不能把固定名字当资产。
5. **数据库验证另开阶段。** 先选上述场景中的代表分支，明确数据库版本、兼容模式、权限、隔离与清理，再请求执行授权；不全量执行 3830 条。

同时可安排 GRANT 的 49 个 valid 信号进行同类权限/对象前置条件复核。这是另一个集中度高的包级目标；先核对缺正向的实际原因及所有者/被授权者/对象类型契约，不因标为 valid 就批量生成或执行授权语句。

## 如何复跑

```bash
GAUSSDB_ENABLED=false python3 scripts/build_quality_backlog.py \
  --output work/package_closure_next/backlog.json \
  --markdown work/package_closure_next/backlog.md \
  --asset-routes docs/NO_MANIFEST_REVIEW_ROUTES.json

GAUSSDB_ENABLED=false python3 scripts/lint_factor_packages_v1.py
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py \
  --output-dir work/package_closure_next/generated
```

首批保留原规范快照，重生成写入独立目录。对账确认 525 份 SQL 快照、3830 条完整 case（含 setup、teardown、expected、环境条件）均未改变；224 份正文哈希均与包声明相符。只改动 INSERT、CREATE MODEL 两个包，没有移除任何原缺口，新增两个 planned 待办。

本批选取八个相关测试模块，**86/86 通过**，耗时约 575 秒，7507 个受指纹管理的输入在测试前后没有变化。实际命令、日志、输入指纹和状态见 [本批回执](../work/package_closure_2026_09_06/regression/receipt.json)。这是相关静态回归，不是全库测试或数据库执行；不借用上一轮 633 测试结果。
