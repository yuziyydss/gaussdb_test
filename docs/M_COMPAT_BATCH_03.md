# M 第三批进展：18 个有限包已通过离线验收

18 章正文已拆分，18 个命令完成有限生成与离线验收。这里只表示已选有限域达到门禁，不表示全章抽取、行为 Oracle 或数据库执行已完成。

## 实际增量

| 命令 | SQL case | 关键建模 |
|---|---:|---|
| CREATE SEQUENCE | 15 | 显式小整数范围、正负步长、起点、缓存、循环与 OWNED BY |
| ALTER SEQUENCE | 16 | 15 正向＋CACHE=0 目标负向；不复制 CREATE 的不支持属性 |
| DROP SEQUENCE | 6 | 单/多序列、IF EXISTS、无依赖对象的 CASCADE/RESTRICT |
| PREPARE | 4 | M FROM 字符串；SELECT/INSERT/UPDATE/DELETE 有真实表列 |
| EXECUTE | 2 | 同会话中已创建的读/写预备语句 |
| DEALLOCATE | 2 | DEALLOCATE/DROP PREPARE 别名；成功后不重复释放 |
| DROP PREPARE | 2 | 独立文档包、同语法别名；关闭独占会话清理失败残留 |
| CREATE INDEX | 18 | 17 正向＋fillfactor=9 负向；普通表键列表、排序、行内 COMMENT |
| ALTER INDEX | 13 | 12 正向＋fillfactor=9 负向；RENAME/UNUSABLE/SET/RESET |
| DROP INDEX | 21 | 普通、ON table、在线三种形式；两项单独的在线非法组合 |
| CREATE TABLE SELECT | 12 | 11 直接列正向＋列存负向；真实 DEFAULT/NOT NULL 源表 |
| COMMENT | 15 | 表、表列、视图、索引、序列；文本与 NULL 删除注释 |
| EXPLAIN | 21 | 查询的括号/顺序形式；DML 只生成 ANALYZE FALSE 计划 |
| REPLACE | 18 | VALUES/VALUE、SELECT、SET；真实主键冲突、DEFAULT 和赋值依赖 |
| SET | 9 | 时区三种值 × 缺省/SESSION/LOCAL；事务回滚及独占连接 |
| RESET | 2 | ALL 正向、单参数目标负向；回滚清理不依赖被重置的模式搜索路径 |
| SET TRANSACTION | 12 | LOCAL/SESSION × 六种独立特性；禁止混入 GLOBAL/无修饰 s2 |
| SHOW | 31 | 参数、表/视图列、定义、索引、表列表；各类绑定真实前置状态 |

本批累计增量 219 条（47＋64＋54＋54），累计 M 42/93 个命令有有限模型、450 条 SQL。固定剩余 69 队列已验收 18 项，尚余 51；通用 224 包、528 SQL 快照保持不变。全库当前 266 包、4371 条生成 SQL。未连接或执行数据库。

## 关键判断与保留项

- ALTER SEQUENCE 正文限制可修改属性，故最大值和 CACHE 作为互斥 action 值，不拼成文档未支持的参数组合；MAXVALUE 用例显式要求顶层 autocommit 上下文。
- MAXVALUE 参数要求大于 last_value，但示例设置为相等，保留 open_question；不把相等边界硬改成正向或负向。
- 物理页 2029 的铁路语法图含 LARGE，而文本产生式未含；已回看 PDF 图并保留冲突，不直接创建 LARGE 序列。
- 普通序列 CACHE 范围明确从 1 开始，0 生成独立负向。fixture 先创建有效序列，负向只违反 CACHE 规则；SQLSTATE 不猜，oracle_status 保持 needs_verification。
- OWNED BY 建立对象依赖，不是 DEFAULT 自增赋值；另有 planned 场景验证 NULL 不自动变为 nextval。
- PREPARE 在回滚后仍存活，EXECUTE 必须使用同会话对象；增加 isolated_connection 门禁，不能跨连接重用 fixture。
- 释放命令成功后不会 teardown 二次 DEALLOCATE。失败路径要求关闭该 case 独占会话，当前 M Legacy 执行仍被阻止，不能认为运行时已校准。
- PREPARE 的其他 DDL/DCL 主体、EXECUTE 参数说明歧义、所有权切换、多会话序列缓存、LARGE 隐式对象等未覆盖内容仍显示缺口。Source 原子性与 planned 场景未关闭。
- M CREATE INDEX 正文明确允许行内 COMMENT，不能套用通用模式历史失败修复；键列表采用 repeat AST，排序/NULLS 作用于最后一个键，其余键保持默认。只绑定普通整数表，不复制 GIN/GiST/INCLUDE 等通用模式候选。
- M BTREE 随基表存储类型自动转换；本轮使用默认存储表，不宣称已覆盖 ASTORE/USTORE 双引擎。分区索引产生式缺键列表及中间分号已回看物理页 2102，保留 open_question。
- DROP INDEX 的普通/ON table 形式用独立 AST 分支，后者不错误插入 IF EXISTS/CONCURRENTLY；在线正向限定单索引、非 CASCADE、顶层 autocommit。两种非法组合分别形成目标负向，错误码不猜。
- 索引 fixture 按 CREATE TABLE→CREATE INDEX 依赖展开；重命名后的索引最终随本 case 独占基表删除，不扩大清理范围。首轮无 setup 的 explicit fixture 被严格加载拦截，已改为已有 auto 依赖组合，不添加占位语句、不改 core。
- CTAS 查询使用命名子语法与可重复直接投影，真实源表提供 INTEGER、NOT NULL、DEFAULT 7/9 与含 NULL 的种子数据。专项测试核对渲染投影顺序/类型和源列合同；自定义独有列排序、覆盖同名列与 DEFAULT 继承有 planned Oracle。尚无通用 CTAS 最终合并列的类型推导器，不把有限样例当作该能力已完成。
- CTAS 表达式/常量/UNION 的精度开关、CTE、临时/非日志表与内联索引不进入本轮正向；CTAS 与 CREATE INDEX 对 USTORE/BTREE 的文字差异另记 open_question。
- COMMENT 根据目标分别依赖真实表、视图、索引或序列，NULL 是删除注释而不是字符串 'NULL'；共享数据库/角色对象不进入默认候选，所有者能力通过门禁表达。
- EXPLAIN 的 BUFFERS TRUE 约束要求 ANALYZE TRUE；默认 DML 计划清单固定 ANALYZE FALSE。DML ANALYZE 及回滚行为保留 planned，不能视为只读 EXPLAIN。集中式禁用节点选项、PLAN 排他、OPTEVAL 白名单及 PERFORMANCE 文本歧义分别记录。
- REPLACE 复用输入列数/类型结构检查，SET 分支不拼目标列列表。fixture 提供非延迟主键、DEFAULT 2/9 与冲突行；SET id=id+1,qty=id 从默认 id=2 推导的 [3,3] 是待执行 Oracle，不是更新旧行。多唯一键、分区和延迟约束保留缺口。
- 本轮首次失败是 REPLACE 查询 profile 缺 items。第一次补丁因重复 YAML 的短上下文匹配到了别的 profile；构建器改用完整文件上下文，测试逐文件对比构建结果并检查真正的值列表。没有放宽加载规则，也没有改生成后的 SQL。
- SET LOCAL 只持续到事务结束；SET TRANSACTION LOCAL 却等价 SESSION，不能共用相同的作用域断言。SESSION 事务特性的连接状态还需关闭独占连接收尾，不承诺仅回滚就恢复一切。
- RESET 当前只支持 ALL；TimeZone 单参数是单独负向，目标错误身份待校准。ALL 可能重置 search_path，fixture 清理只用 ROLLBACK，不访问未限定表。引用 M SET 的已导出会话事实，不复制跨章规则。
- SET TRANSACTION 在首个数据语句前设置；SERIALIZABLE 是等价 REPEATABLE READ 的语法候选，不标为语法错误。GLOBAL 和 s2 next-transaction 分支需要不同上下文，保留 planned。
- SHOW 表、视图、索引分别依赖真实对象，参数分支仅用真实事务/时区前置而不用占位表。版本相关 SHOW CREATE 结果格式、临时 Schema、权限裁剪、完整系统目录映射等仍未形成执行 Oracle。

## 复核证据

```bash
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_sequence tests.test_m_compat_prepared -v
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_index tests.test_m_compat_ctas -v
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_comment_explain_replace -v
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_session_show -v
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_remaining.py
```

首 7 包 8 项专项测试通过；INDEX/CTAS 10 项通过（22.666 秒）；COMMENT/EXPLAIN/REPLACE 7 项通过（12.207 秒）；SESSION/SHOW 8 项通过（11.893 秒），最后四包首次专项检查即通过。累计审计器对当前全部 42 个 M 包重做严格加载、来源/行账本、确定性生成、ID/包内 SQL 唯一、有限域可行值和 pair 复核、fixture SQL 基础检查、环境计划引用、静态消费者审计与通用快照哈希对照：非恒定维度的可行 pair 为 1362/1362、无缺失。独立枚举超过 100000 个候选时会明确失败，不静默采样。

最新全 M 口径在 `generated/m_compat_remaining/progress.json`；旧 batch 01/02 报告是历史范围，不再拿旧批次硬编码计数充当当前总进度。累计审计还锁定启动时的 69 个命令集合，防止换分母。

测试与失败根因证据分别保存在 `generated/m_compat_batch_03/index_ctas_test_evidence.json`、`comment_explain_replace_test_evidence.json` 和 `session_show_test_evidence.json`。下一块：第四批模式/视图修改、函数、角色和权限相关 20 章；固定队列仍余 51 项，循环保持启用。
