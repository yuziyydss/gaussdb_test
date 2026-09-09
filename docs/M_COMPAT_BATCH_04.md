# M 第四批：20 包有限静态验收（含 4 个受限接口）

以本地 PDF 第二章为准。本批 20 章正文共 2174 行，以下 20 包通过有限模型验收；没有执行数据库，也不代表全章或行为覆盖完成。CREATE FUNCTION、DROP FUNCTION、DO 为内部接口；DROP GROUP 为管理工具接口，不能解读为普通用户支持。

| 命令 | SQL 数 | 本轮范围 |
|---|---:|---|
| ALTER DATABASE | 27 | M 命名空间字符集/字符序，含 1 条字符集错配负向 |
| ALTER SCHEMA | 27 | 引用同一字符集匹配事实；独立主章、命名空间和 SQL |
| ALTER SESSION | 11 | 时区、参数 DEFAULT/FROM CURRENT、单项事务特性 |
| ALTER VIEW | 18 | DEFAULT、重命名、移动模式、改定义、对有效视图 COMPILE |
| CREATE ROLE | 11 | WITH、密码 DISABLE 拼法、真实父角色成员关系、连接上限及目标负向 |
| ALTER ROLE | 22 | 普通权限选项、锁定、密码 DISABLE、改名、会话参数、连接上限负向 |
| DROP ROLE | 4 | IF EXISTS、单角色/双角色列表，真实已建角色和定向清理 |
| CREATE GROUP | 8 | CREATE ROLE 别名、继承/连接范围、禁用密码与真实父角色 |
| ALTER GROUP | 5 | ADD/DROP 成员及改名，初始成员状态分别建模 |
| DROP GROUP | 4 | 管理工具受限候选；单组/双组与 IF EXISTS |
| CREATE USER | 8 | 显式 NOLOGIN、禁用密码、隐式同名 Schema 生命周期 |
| ALTER USER | 21 | 普通角色属性、ACCOUNT、SET/RESET、连接范围负向 |
| DROP USER | 4 | 先清理空 Schema，再缺省/RESTRICT；不生成 CASCADE |
| SET ROLE | 1 | 仅 SET ROLE = DEFAULT，不含需要密码的切换 |
| SET SESSION AUTHORIZATION | 4 | 仅 DEFAULT 重置的四种拼法，同连接事务隔离 |
| GRANT | 16 | 表/列 SELECT、UPDATE，对专用角色授予、带/不带再授权 |
| REVOKE | 20 | 真实对应初始授权；表/列分开，区分仅回收再授权 |
| CREATE FUNCTION | 14 | 内部限定；INTEGER、IN、参数默认值、STRICT/COST/波动性 |
| DROP FUNCTION | 8 | 内部限定；唯一函数签名、IF EXISTS、RESTRICT 关联约束 |
| DO | 2 | 内部限定；真实源表 UPDATE/INSERT 匿名块 |

本批累计新增 235 条 SQL。累计 M 为 62/93 包、685 条 SQL；固定剩余 69 队列已验收 38 项，余 31 项。全库 286 包、4606 条 SQL；通用 224 包、528 份 SQL 快照未变。

## 实际改进

- M DATABASE/SCHEMA 是命名空间同义词；fixture 创建和清理本 case 专用 Schema，不修改物理库属性或系统 Schema。模式解释事实已连接到 M 环境门禁。
- 两个 ALTER 主章的字符集/字符分类术语混用被保留为 open question。补取同一 PDF 的 M 2.3 与 2.3.2，依据表 2-2/2-3 和库级匹配规则，仅建模 utf8/utf8mb4/gbk 的代表子域，未套用 B 模式规则。
- 字符集匹配事实从 ALTER DATABASE 显式导出，ALTER SCHEMA 通过限定引用消费，不复制维护第二套匹配规则。组合不匹配进入独立目标负向，SQLSTATE 尚未校准。
- source ledger 使用已有 supplemental_sources 记录正文定位和哈希。累计审计现在检查这些补充章节的正文哈希、父 PDF 与 catalog，并将其加入输入指纹。内存注入正文哈希变化的回归证明审计确实拒绝漂移，没有修改真实正文。
- M ALTER VIEW 的 SET/DROP DEFAULT 在原文中“暂无实际意义”；当前 scope 为 syntax_only，不宣称插入时 DEFAULT 生效。移动/重命名后的对象有定向清理，源表按依赖逆序清理，不用 DROP OWNED/CASCADE 兜底。
- ALTER SESSION 使用真实事务和独占连接；CURRENT_SCHEMA 的 TO 关键字与正文不一致、事务语法多余花括号都保留问题。身份切换/密码与复杂组合不混入本轮清单。

## 验证与限制

```bash
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_namespace_view_session -v
GAUSSDB_ENABLED=false python3 scripts/build_m_compat_batch_04.py --update
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_remaining.py
```

前四包专项 9/9 通过（23.548 秒）；后续各块验证见下方独立证据，构建器重跑无差异。首轮曾因两条 namespace confirmed fact 未被消费而严格加载失败，已在构建器补齐模式门禁引用，未降低校验规则。最终全库生成与累计审计均退出 0，当前全部 M 包 2178/2178 非恒定维度可行 pair 覆盖、无重复 ID/包内 SQL、528 通用快照哈希无变化。

证据：`generated/m_compat_batch_04/namespace_view_session_test_evidence.json`；当前累计事实源：`generated/m_compat_remaining/progress.json`。原子性、未建模域、权限行为、视图失效生命周期及目标 Oracle 仍独立报告。

## 下一块

第四批完成后启动第五批约 15～20 章，优先 ANALYZE/VACUUM/REINDEX/LOCK/SELECT INTO、COPY/LOAD DATA 和资源标签/审计策略等真实依赖簇。余下 31 个固定 ID 不改变；高风险执行和外部资产继续保留门禁，不能为完成计数删掉困难章节。

## 角色增量验收

新增 `tests/test_m_compat_roles.py`；与既有第四批测试一起 16/16 通过（34.251 秒）。回归先复现三处清理缺失：auto fixture 会忽略手写 teardown。修复在规格构建器，将新建目标/父角色与改名前后角色交由显式生命周期处理；自动 wrapper 只声明依赖。不修改生成器语义、不放宽 lint，也不使用 DROP OWNED/CASCADE。

CREATE ROLE 导出禁用密码权限、创建权限与连接范围事实，其他角色包限定引用。所有候选限 M 环境、管理员且三权分立关闭；只创建 NOLOGIN 普通角色，不生成提权或明文密码。负向 CONNECTION LIMIT -2 只反转目标规则，SQLSTATE 保持待验证。改名独立 fixture，避免清理未由该 case 预留的共享身份；固定名字需要隔离和执行前确认不存在。

全量生成与累计审计退出 0，所有累计输入指纹及 queue 证据重新对账。证据为 `generated/m_compat_batch_04/roles_test_evidence.json`，前四包证据保留为历史验证记录。成员关系、登录状态、下一会话配置、特殊管理属性及全章未建模内容不因此标成完成。

## 本轮其余增量与证据

- GROUP/USER：19/19 联合回归通过（35.129 秒，包含既有 ROLE 回归）。ADD/DROP 成员 fixture 不再共享错误初始状态；CREATE USER 同名 Schema 显式清理；ALTER USER 缺失密码产生式保留 open question。证据 `generated/m_compat_batch_04/groups_users_test_evidence.json`。
- 身份重置：3/3 通过（11.168 秒）。只实现 DEFAULT 重置，不保存假密码或实际凭证。指定身份切换、SESSION/LOCAL 权限效果仍 planned。证据 `generated/m_compat_batch_04/identity_reset_test_evidence.json`。
- 对象权限及内部函数：12/12 联合回归通过（23.569 秒）。GRANT/REVOKE 复用真实角色、Schema/USAGE 与列定义；REVOKE 初始授权按表/列分开，避免表权限掩盖列级行为。对象清理完成后才删除角色。证据 `generated/m_compat_batch_04/privileges_internal_test_evidence.json`。
- 内部函数：CREATE FUNCTION 使用调用者权限、普通 INTEGER 表达式与独立 Schema；DROP FUNCTION 明确签名与 RESTRICT 的语法关联；DO 只修改真实 seed 表。三个命令具有 `m_internal_tool_reviewed`、独占库等门禁，不是普通用户可用声明。
- 累计审计新增 `restricted_finite_package_ids` 及逐包 `restricted_applicability`，单列三个内部函数接口和 DROP GROUP。这个分类不改变 69 项分母，也不能代替未来适用性审阅或执行授权。

历史证据保留其当时输入哈希；最新累计输入指纹与当前队列统一指向 `generated/m_compat_remaining/progress.json`。未建模源码、原子性、行为 Oracle、密码绑定、OUT/重载以及跨库授权映射都保留真实缺口。
