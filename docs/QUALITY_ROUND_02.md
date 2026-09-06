# 第二轮：真实写入契约与 15 章依赖验证

范围：以本地冻结 PDF 为唯一产品依据；固定复核 8 包、20 条已有质量待办。
不连接数据库、不提交推送，不改 Factor Package V1 的七类文件模型或公共生成接口。

## 本轮改进

### 渲染结果对照真实 fixture，而非元数据自证

`core/finite_sql_contract.py` 从实际 `CREATE TABLE` 语句提取有限列定义，检查
UPDATE、INSERT、REPLACE 的部分写入形态。正向生成遇到**确定矛盾**会抛出
`GenerationValidationError`，不会静默丢弃该组合或改成负向。

| 结果 | 含义 |
| --- | --- |
| `checked` | 仅当前支持的写入形状检查通过；不是整条 SQL 正确或可执行 |
| `rejected` | 实际表列、有限表达式数量、重复插入列或有限分区范围存在明确矛盾 |
| `needs_review` | 未能证明；不算通过，也不直接推断产品不支持 |
| `not_applicable` | 不属于此写入检查器范围 |

本轮可确定的范围包括：简单目标列、有限整数/文本等类型族、赋值元组列数、
已知表的简单 SELECT 投影，以及无 INTERVAL/MAXVALUE 等扩展条件的有限 RANGE
分区键越界。分区键保持原值与写非分区列分开检查。`SELECT *` 只有来源已知时
才能展开，不能当作一个普通表达式直接判元组列数错误。

**不证明**：谓词、完整语法、查询基数、单行子查询唯一性、赋值求值顺序、数值溢出、
字符长度、隐式转换、任意函数/查询、UPDATE FROM 名称解析、运行时 DEFAULT、
分区路由和受影响行数。复杂/不识别的格式保留待审。未知值不被过滤，独立报告公开列出。

新脚本 `scripts/audit_rendered_sql_contracts.py` 对生成报告逐 case 审计，保存
case/manifest/factor 身份、具体检查/未知原因及实际 SQL/fixture 对应报告的哈希。
它是**旁路补充证据**，不冒充现有全因子审计器的静态闭环结论。

### 分区 UPDATE/DELETE 使用真实业务数据

保留第一轮两列表及键值恒等赋值候选，新增两种三列 fixture：

- RANGE 表：`col_1, col_2, payload`，仅 col_1 为分区键；
- RANGE-RANGE 表：两级键分别 col_1/col_2，payload 为非键业务列；
- seed 的 payload 为 100/200 等，赋值 42 或 payload+1 不再是无实际变化的占位动作；
- 四种目标：一级分区名称/FOR 值、二级分区名称/FOR 值；
- UPDATE 新增 12 条候选（24 个可行组合，126/126 pair，含固定维度）；DELETE 新增 8 条。

新 fixture 依赖链为：`BEGIN → CREATE SCHEMA fp_q2 → CREATE TABLE → seed`，
清理子表后最后 `ROLLBACK`。模式重名应停止并回滚，禁止先删除旧模式。
固定模式名不能支持并发共享会话；需要专用连接、无外层事务和事务 DDL 支持。
执行器必须在 setup/teardown 出错后仍尝试最外层回滚，本轮**没有执行证明**。

`inspect_lifecycle` 只报告事务语句形状及 DROP OWNED/角色/模式/CASCADE 风险。
`transaction_scoped` 不是所有权校验或共享业务库执行许可。

### 其他有限域扩展

- COPY：补单列子集、两列逆序；TEXT/CSV 分别组合。按 PDF 物理页 1385 核对：
  **BINARY 不支持 STDOUT/STDIN，且不允许 DELIMITER**，不塞入现有流 AST。
- REPLACE：补三行代表（前两行主键相同），实际表列形状检查覆盖 VALUES、VALUE、SELECT、SET。
- VALUES：补 `(1 + 2) * 3` 嵌套整数表达式；OFFSET+FETCH 的已有组合保持覆盖。
- SELECT INTO：补 `col_1 + 1 AS shifted, col_2 AS kept`，验证实际 AST 渲染。
- UPDATE：现有多项赋值、标量/元组子查询现在接受真实 fixture 列/投影形状检查；
  其余复杂表达式与查询行为仍未证明。

## 20 条待办的诚实处置

逐条原始 ID、来源 unit、改动位置、剩余条件见 `work/quality_round_02/plan.json`。
**11 条取得有限改进，9 条保留具体阻塞，原来的 20 条全域/目标证据缺口均未关闭。**

| 保留项 | 不能伪造的前提 |
| --- | --- |
| CREATE SEQUENCE 系统列相关 3 条 | 专用系统列身份及目标错误未校准；普通同名列/缺列错误不能替代 |
| ALTER SEQUENCE 空修改、跨模式拒绝 2 条 | 空修改实际结果未定；跨模式需同用户两模式、正向控制和窄错误 Oracle |
| COPY 格式与协议 2 条 | BINARY 需独立文件能力；TEXT/CSV 需消费/发送完整 COPY 流与数据断言 |
| DELETE B 模式单目标 USING 1 条 | 原值仍 conditional；V1 正向加载器不接受，不能改成 valid 来绕过 |
| VALUES LIMIT/FETCH 共存 1 条 | 原文没有解释组合优先级，OFFSET+FETCH 的已有覆盖不能替代此问题 |

新增 3 个聚焦的 planned scenario：COPY 流、ALTER SEQUENCE 两项校准、DELETE B
模式自连接；同时加强已有 CREATE SEQUENCE 系统列场景的正向控制、目录身份、
错误隔离和非目标错误排除。这些是**待实现契约，不是新增行为覆盖**。

因此全库关联待办从 2385 变成 **2388**，增加的是 3 个公开未执行场景；不是隐藏错误，
也不是 2388 个独立特性。11 个有限改进不能被记作 11 个全域问题已解决。

## 当前生成证据

严格 lint：224 包、2268 文件。重新生成：523 个 manifest、3818 个唯一 case ID，
3790 条不同 SQL 文本，28 个跨因子同文组；比第一轮净增 36 条候选。有限写入检查：76 checked、126 needs_review、3616 不适用；
确定矛盾的正向候选为 0。生命周期形状：219 transaction_scoped、3599 needs_review。
上面均不是数据库通过率。

15 因子依赖试点保留精确图比较，新增四组 payload profile 闭包，总计 10 组 fixture
闭包。首轮真实执行发现 CREATE SCHEMA 的补充正文漏带，任务信封正确失败；
修复为收集全部已声明的 PDF 补充来源，并补入既有非 SQL 补充 catalog。
重新抽取的是 **17 章正文**：15 个因子主章节，加 DROP SCHEMA 和
“模式级字符集和字符序”。后两者只是本批证据输入，不凭空扩大为已执行因子任务。

验证正文哈希、Fact 引用、拓扑顺序、生成结果及 5 个已有 Fact/Fixture 提供者的
包/主正文变更后定向 stale。**失效注入不是所有补充正文的自动失效证明**；正文依赖
完整带入、任务信封重新校验，与任意正文变更的最小自动传播是不同能力。
历史 12 章/第一轮结果、此次两次失败报告均保留，不覆盖。

主回归 **405/405 通过，1125.853 秒**。之后补充正文闭包的 4 个新测试 **4/4 通过**，
与已有依赖测试合并再跑 **8/8 通过**；这些套件有重叠，不相加为新通过率。
主回归期间发现的试点正文遗漏由新增测试及完整重跑验证，不用旧的试点结果替代。

完整试点最终通过：15 个因子、17 章正文、1439 个唯一 case，聚合生成与全库基线
1439/1439 完全一致；20 条 Fact 引用、2 条直接 Fixture 引用、10 组 Fixture
闭包及 6 个非法引用/循环探针通过。5 个提供者的包/主正文变更共 **10 次注入均通过**。
15 个真实队列任务仍是 needs_review，静态完成状态只在临时副本的失效单测里模拟。

最终证据：`work/quality_round_02/result.json`、`tests_full.log`、
`tests_dependency_targeted.log`，以及
`work/quality_round_02/dependency_pilot_retry_02/dependency_report.json`。

## 重跑入口

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 scripts/audit_rendered_sql_contracts.py --output work/quality_round_02/rendered_after.json
python3 -m unittest tests.test_finite_sql_contract tests.test_quality_round_02 -v
python3 -m unittest discover -s tests -v
python3 scripts/verify_cross_chapter_dependencies.py \
  --output-dir work/quality_round_02/dependency_pilot --pdf-python <安装了pypdf的Python>
python3 scripts/build_quality_backlog.py --output work/quality_round_02/backlog_after.json \
  --review-factor update --review-factor delete --review-factor replace --review-factor copy \
  --review-factor create_sequence --review-factor alter_sequence --review-factor values --review-factor select_into
```

下一阶段优先：对静态报告中的可识别未知形态按根因补契约；评审 conditional 值的
显式环境消费方式；实现执行前对象所有权/专用连接及失败清理门禁。数据库验证需要
另行授权，COPY 协议与负向 Oracle 不用“任意错误成功”代替。
