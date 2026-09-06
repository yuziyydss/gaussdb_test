# 条件值准入评审：环境前置与来源冲突必须分开

2026-09-06，P1 补充评审，状态 **proposed / 未实现**。此文不改变 V1 的 positive 加载规则，不新增 YAML 字段，不升级任何 conditional 值。

## 三章给出的不是同一种条件

| 包 / 值 | 实际证据 | 缺少什么 | 当前处置 |
| --- | --- | --- | --- |
| INSERT ON CONFLICT | 主章 L357–368：PG 模式、UPDATE 权限、普通对象形态、不含子查询/子链接、单条语句无重复冲突键等 | 能表达这些条件的明确准入契约；真实执行前的环境/权限核验 | 保持 conditional；已准备三条有具体行结果的 planned 场景 |
| CREATE RESOURCE POOL MAX_DOP | DDL L16及46–48允许参数并列出范围；PG_RESOURCE_POOL L24–25、64称仅扩容且不适用于集中式 | 两章支持性冲突的消歧证据，不只是缺 sysadmin 权限 | 保持 conditional/open_question；不能通过声明 sysadmin、多租关闭或 dop=1 消除冲突 |
| ALTER RESOURCE POOL MAX_DOP | DDL L15及45–47与同一系统表章节发生冲突 | 同上；另需真实已有资源池 | 保持未生成；不要推导为所有版本/形态都不支持 |

来源身份：

- INSERT：`general/dml/insert.txt`，SHA256 `5383f2eca79ecbe64ce3e880c8e3a2a39178a6bd93ca328401740bf36c16fae5`。
- CREATE RESOURCE POOL：`general/ddl/create_resource_pool.txt`，SHA256 `aeec58e8dae717da2720eb558b95e0db7004b75db8ccc5b1169848b183da38fe`。
- ALTER RESOURCE POOL：`general/ddl/alter_resource_pool.txt`，SHA256 `98141c86e63338f7338bc62354bee0171972c72bbe207c2883ae0840949f67b9`。
- PG_RESOURCE_POOL：`work/doc2spec/batches/batch_09/corpus/general/utility/pg_resource_pool.txt`，物理5005–5006页，64行，SHA256 `133a39247c1157282ff3a3fbbc1d04395bb63465590844075aba820d5a5c0302`。

主章文件根目录为 `work/doc2spec/full_general_corpus/`。跨章冲突沿用已登记 open_question，本次不是重新发现或关闭这两个问题。

## 建议的证明责任

1. **文档依据先闭合。** 明确条件值所依赖的事实及原文范围。来源歧义、冲突或未核实支持性优先阻断，不允许环境 profile 把它覆盖掉。
2. **本地结构与运行环境分开。** 表列类型、唯一约束、输入行、SQL 子查询形状可由有限静态检查提供证据；PG 模式、操作者权限、真实服务器能力在执行前仍需核验。环境键出现在 manifest 中，只是要求，不是观察值。
3. **证明适用于当前选择。** 门禁必须对应当前分支、fixture、输入及值。不能把别的分支的成功、具名但未被选用的 fixture、任意同名字段当证据。
4. **保留原值身份与条件性。** 未来若允许生成受条件保护的候选，应保留原 value ID、conditional 属性、每项条件的状态与证据。不得把原值全局改成 valid；生成准入也不等于实机通过。
5. **阻断可解释。** 将“条件不满足”“缺条件证据”“文档冲突”“需运行核验”区分。不把 unknown 静默从可行域删掉以制造100%覆盖。
6. **负向 Oracle 独立。** 不满足环境条件不自动意味着目标 SQL 应报某个错误。只有文档及校准支持具体负向意图时才生成目标负向；setup 失败不是目标错误。

## 最小范围与迁移约束

- 本阶段不实施公共准入语义。P1 获得单独评审后，先限定 INSERT 的三个普通唯一键冲突分支，资源池冲突作为必须继续阻断的反例。
- 初版不接管实际数据库环境探测、角色权限管理、无限表达式或任意能力矩阵，也不增加通用 `allow_conditional` 开关。
- 没有新证明声明的旧 V1 包继续采用当前严格规则；旧 negative/positive 意图不变，原3830个完整case必须逐条对账。
- 对新受条件保护的有限域单列生成、阻断、待运行核验的数量。维度选择覆盖不能替代权限、对象能力或行为覆盖。
- 条件引用的主章、补充正文、fixture 或证明算法变化，要使相应准入证据 stale；不能只比较主因子文件是否变化。

## 实现前必须写出的反例测试

| 输入 | 预期 |
| --- | --- |
| 无证明的现有 conditional 值加入 positive | 仍拒绝，旧行为不变 |
| 只声明 PG，却引用不存在的表/列或缺唯一约束 | 不得因 PG 条件而放行 |
| 用普通表证明替换视图、查询源或其他受限对象 | 当前选择的证明不匹配，阻断 |
| PG 三个普通冲突分支具有完整静态结构证据 | 仅产生附执行门禁的新候选，不变成运行成功 |
| 删除 UPDATE 权限要求，或当前环境未知 | 明确缺条件/待核验，不猜测权限 |
| 资源池 MAX_DOP 有管理员权限、值在范围内 | 仍因跨章支持性冲突阻断 |
| 把 invalid 值塞入已证明的环境 | 不得改成合法值 |
| 依赖章节、fixture或证据算法变动 | 原准入证据失效且须重验 |
| 原3830用例重新生成 | case身份、SQL、setup/teardown、expected与原基线完全保留，新增单列 |

这些是设计验收条件，不是已经运行的测试结果。当前可继续实施、不依赖 P1 的工作，是各包中有确定语法依据及可控前置对象的 valid 子域，例如 GRANT 普通新角色成员关系。

## 追加复核：CREATE DATABASE 的37个条件编码值

2026-09-06晚，统一回归冻结期间只读复核完整 CREATE DATABASE 正文。
章节 SHA256：`23b7b10e871e92137fb9dc584499a68eb18723c019b42cb5d7f005df542f5c39`。
本节没有更改值的 validity、清单或生成器，不代表69项条件缺口全部完成审查。

这37个值都是本章表1-376声明服务器端支持、但尚未进入正向有限清单的编码：

- EUC_CN、EUC_JP、EUC_JIS_2004、EUC_KR、EUC_TW。
- GB18030、GB18030_2022、GBK、ZHS16GBK。
- ISO_8859_5、ISO_8859_6、ISO_8859_7、ISO_8859_8。
- KOI8R、KOI8U；LATIN2、LATIN3、LATIN4、LATIN5、LATIN6、LATIN7、LATIN8、LATIN9、LATIN10。
- MULE_INTERNAL、SQL_ASCII；WIN866、WIN874、WIN1250、WIN1251、WIN1252、WIN1253、WIN1254、WIN1255、WIN1256、WIN1257、WIN1258。

不能因它们没有生成就标成“不支持”。同一表里服务器列为“否”的 BIG5、JOHAB、
SJIS、SHIFT_JIS_2004、UHC 是另外五个 invalid 缺口，不混入上述37，也不能因客户端
或别名支持而转为可创建数据库的服务器编码。

| 证明层 | 必须核对的内容 |
| --- | --- |
| 源表支持性 | 每个编码服务器端支持列；ICU支持是另一列，ICU=false不等于服务器不支持 |
| 实际创建条件 | CREATEDB权限、非事务执行、模板不在升级/更新、全新目标数据库及专用清理权限 |
| 编码与区域 | LC_COLLATE/LC_CTYPE必须与编码和模板兼容；C/POSIX例外、SQL_ASCII管理员例外分别处理；不能只验证编码名称在列表内 |
| 模板及模式 | template0/templatea的编码与区域例外；其他模板继承关系及M模式默认UTF8/区域参数不生效分别建条件，不能跨模式套用 |
| 客户端条件 | 编码转换能力由实际支持的转换核对，不以开发机Python编解码器支持性替代服务器 |
| 数据与行为Oracle | 编码目录值、实际字符往返、标识符/排序/分类行为分开；一次CREATE成功不证明这些行为 |

特殊条件仍需独立记录：

- GB18030_2022：客户端操作系统字符集版本及历史数据迁移条件；不能只匹配“GB18030”名称。
- GBK/ZHS16GBK：部分多字节字符与SQL符号重叠，标识符引用及客户端编码需配套；
  ZHS16GBK的欧元输入是独立行为，不从编码创建推导。
- SQL_ASCII：非ASCII字节不做同等转换/校验，不作为普通Unicode往返成功用例。
- MULE_INTERNAL及其他编码：表中“服务器端支持”仅是文档事实，不保证当前客户端API支持；
  无转换/区域/输入资产证据时继续保持条件未满足。

这些是可复用的条件族，不是37条“都满足了”的评审结论。本次没有调用服务器
`locale -a`、创建数据库或改会话编码；真实环境值仍未知。下一步P1证明模型须能
区分支持性、模板、区域、客户端、对象生命周期与行为，不能把它们压成一个`encoding_supported=true`。

## 追加复核：UPDATE/DELETE三个条件值不是同类门禁

2026-09-06 19:21，完整读取两章冻结正文，未修改受测规格。
UPDATE SHA256 `91336a8f0ba512576379ccc807be7ca0acf94a015ae07e14537f832d7ff61d25`；
DELETE SHA256 `8aa143969533fe7a75f798df8eabbc518fbdd6e0ecc39231849dede7ac499fe4`。

| 当前值 | 原文依据与证明责任 | 后续路线 |
| --- | --- | --- |
| `update_predicate_current_of` | UPDATE L203–222：仅存储过程、普通表、非B模式；游标单表SELECT FOR UPDATE，无LIMIT/OFFSET/子查询/子链接，且当前行与事务状态有效 | 完整存储过程与游标生命周期场景，不作为独立UPDATE语句只加环境标签放行 |
| `delete_predicate_current_of` | DELETE L169–171明确引用UPDATE限制；继承上述约束但缺失行行为须区分UPDATE/DELETE | 复用约束来源与生命周期结构，不直接复用UPDATE的错误Oracle |
| `delete_using_target_b` | DELETE L160–163：B模式或多目标删除时关联表可含目标表；这个值位于单目标分支，因此仍需B模式 | 条件准入设计中的有限单语句候选；关联别名、目标身份、读取权限和真实行结果另行核验 |

两个CURRENT OF值还受禁止组合约束：不能与其他WHERE条件、多表更新或WITH、
USING、ORDER BY、FROM组合。不能因为生成器恰好选了空字符串，就证明游标已声明、
已定位到行或锁仍有效。COMMIT/ROLLBACK后的FOR UPDATE游标失效，必须作为独立
时间顺序测试；不能用静态字段`cursor_exists=true`证明。

缺失行Oracle也不是统一“应失败”：UPDATE原文说明A模式下UPDATE报错，而DELETE
不报错，其他兼容模式下不报错。这里仅记录原文行为，不臆造SQLSTATE、是否影响
零行的驱动返回值，或把这些模式分支算成已经验证。

现有`update/scenarios/current_of.scenario.yaml`及`delete/scenarios/current_of.scenario.yaml`
已经登记这些planned场景，不重复新建场景消除缺口。它们尚未提供完整可执行存储
过程、游标定位、禁止组合隔离、缺失行操控和目标Oracle证据，继续保持待实施。

此外，两章均明确给出子查询/视图作为目标的语法与示例。不能沿用历史其他版本的
Smoke失败结论把当前PDF中的子查询目标一律标成“不支持”。单表直接投影的有限
列映射、连接保留键、CHECK OPTION、只读和触发器路线须分别审查；静态列形状
相容仍不等于数据库确认可更新/可删除。

## 追加复核：包编译、序列浮点步长与索引六项

### ALTER PACKAGE四种COMPILE

完整复核主章（SHA256 `606e9f7c4e803054b5f21c93e7db69c7b4280ba4755f377fe6cc882fbb885ba8`）。
`alter_package_operation_compile`、`_compile_package`、`_compile_body`、`_compile_spec`
共享L26–27语法，但L8–10注意事项称目前仅OWNER；末尾又有COMPILE示例。这是
来源支持性冲突，不是缺一个PACKAGE fixture或管理员环境标签。保留四个值，
不生成推定成功、不推定失败；需要本版本支持性消歧后再安排包体/依赖失效与编译Oracle。

### CREATE SEQUENCE浮点步长

完整复核主章（SHA256 `7602ebc802355cb0dc09b808a72d12f4a94d5d6117d9b9071e08d8a6a48db008`）。
`cs_increment_float_b`的`INCREMENT 1.5`依据L65–69仅B模式自动转整型。本文未说明
精确取整算法，不能用Python的`int`或`round`臆造步长是1还是2。准入应分开“允许
该输入的模式证据”和“结果步长/nextval序列的Oracle”；非B模式是另一负向意图，
需要目标错误证据。现有系统列OWNED BY缺口不因此关闭，也不能以用户自建rowid列代替。

### CREATE INDEX六个条件值

本次核对L235–275、L295–312、L419–477、L475–695及对应matrix/factor实体，
不是整章复审。主章SHA256 `7a8ce69c11e865868cb75fd990000d6a41ceb91ce200dd3e882dc41496863d0d`。

| 值 | 原文明确条件 | 仍需的证据 |
| --- | --- | --- |
| `ci_comment_basic` | L659–665行内COMMENT仅B模式，最大1024字符 | 有限B模式候选准入；真实注释元数据Oracle，不改成另一条COMMENT ON来冒充本语法覆盖 |
| `ci_visibility_visible` | L666–674仅A模式、visible未禁用、非升级未提交阶段 | 当前关键字可用性及环境状态；默认可见不等于显式VISIBLE语法已验证 |
| `ci_visibility_invisible` | L675–683同样要求A模式，独立检查invisible禁用项 | 元数据不可见属性与优化器行为分开；不从创建成功推导计划不使用索引 |
| `ci_active_pages_manual` | L547–550只对Ustore分区表LOCAL索引生效，不建议手工设，VACUUM/ANALYZE可改写 | 精确LOCAL属性、真实分区表、统计维护并发边界；不能只用partition=true证明生效，也不保证值持久不变 |
| `ci_enable_tde_on` | L563–594要求开启TDE、真实密钥服务配置、基表已加密，只支持B-Tree/UB-Tree | 独立批准的加密资产与外部配置；数据库生成/复制的密钥元数据不能手填伪造，不能读取或展示真实密钥 |
| `ci_table_subpartitioned` | L429–475二级分区索引映射及分类索引限制 | 真实两级分区DDL、每层分区身份、列与键值、索引分区对应关系；一个表名或普通一级分区fixture不够 |

GIN pending下界63、UGIN fastupdate=off在当前矩阵中是另外两个invalid缺口，
不能与上述六个条件值混算，更不能用环境标签变成合法值。

分类索引存在额外恢复风险：本章L450附近明确某些FOR分区值场景会通过自治事务
创建缺失分区，主事务回滚后分区仍可能存在。因此后续二级分区fixture即使使用
BEGIN/ROLLBACK，也不能据此承诺无残留；先限定已有分区，自动扩展另设资产与清理场景。
以上只细分证明责任，未新增索引候选、开启加密、修改统计值或删除分区。

## ALTER TABLE十二项：分支条件与资产条件分开

本次核对冻结正文L1–83、L115–218、L256–415、L1130–1185及factor/matrices实体。
章节SHA256 `ff15f5547fd4f2b5aa4888b0d8c67b74f0586098cf3c87d3b2628506562e786e`。
以下逐项复核不代表整章1636行重审完成。

| 值 | 当前证明责任 / 未满足项 |
| --- | --- |
| `at_statement_modify_multi` | 独立MODIFY (...)多列的原列定义、类型/约束、依赖与统计变更契约；L359–363未声明仅B模式，不借用后续扩展MODIFY的B限制 |
| `at_table_b_compat` | 同一普通表fixture只证明对象结构，不证明数据库兼容模式或行为参数已满足 |
| `at_table_external` | 真正外表类型、对应FDW与目标动作支持性；主章L20、370、400、1146等明确部分动作不支持外表，不能用普通表代替 |
| `at_table_tde` | 已启用TDE的真实基表和密钥服务资产，不只是名为t_at_tde的表 |
| `at_action_modify_b` | B模式扩展MODIFY：加密、分区键、规则、物化视图限制，以及依赖重建和生成列重算；重叠语法还涉及enable_modify_column行为参数 |
| `at_action_change_b` | B模式、目标新列名未占用、类型/排序与对象依赖；不能只证明旧列存在 |
| `at_action_first_b` | B模式、非加密列、无阻碍列位置变更的规则、非外表；同时存在全表更新成本，成功不代表在线无影响 |
| `at_action_auto_increment_b` | B模式、真实自增列和当前计数器；设置10只有大于当前值才生效，DDL成功不等于下一值变成10 |
| `at_action_tde_rotation` | 已开启TDE的加密表、KMS独立授权与密钥生命周期。正文说明申请新密钥、旧数据继续用旧密钥，不能删除旧密钥或认为ROLLBACK撤销KMS副作用 |
| `at_action_ilm` | 当前render无ON(EXPR)，不适用表达式函数白名单阻断；仍需目标能力、真实策略身份、元数据与生命周期契约。策略建立不等于30天后压缩行为已验证 |
| `at_action_colview` | 真实HTAP/IMCV能力与开发指南，主章L1169–1171指向外部说明；priority HIGH字符串不证明环境就绪或性能收益 |
| `at_action_set_rowid` | A模式、排除系统/临时/unlogged/外表、已有oid/gs_tuple_uid或同名用户列；压缩数据会被解压，真实系统列Oracle与普通同名列必须区分 |

本次实施仅纠正两个**不相关阻断理由**，并非提升准入：

- 多列形式改引用独立`at_open_modify_multi_contract`，保留conditional。
- 无表达式ILM改引用`at_open_ilm_policy_lifecycle`；原白名单问题继续用于表达式分支。
- 原B模式扩展动作仍引用B条件，原ILM白名单事实不删除，已有用例不缩域。
- 新增两个待验证问题是为了精确描述未完成内容，不代表新增产品事实已证实。

三个专项测试已从2失败1通过变为3通过，全库lint通过。全量对账保留3921完整case、
528快照与224正文哈希，新增2个待确认问题而没有删旧缺口。第三轮测试发现旧审计
断言仍固定19个问题，随后改成原19项加新增2项的精确ID集合；第四轮649项统一
静态测试通过，输入指纹不变。没有借用修正前的646通过，也没有数据库验证。
