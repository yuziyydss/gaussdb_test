# 工具命令为什么不能作为普通SQL冒烟

来源：本地V2.0-10.0.0集中式PDF的一般命令及M章节。
这里描述后续集成所需的条件，不启动备份、恢复、升级或节点操作。

## 备份恢复不是目录字符串替换

| 路线 | 顺序和前置 | 本轮仍缺 |
| --- | --- | --- |
| DATABASE | EXPDP DATABASE产生真实物理文件；IMPDP DATABASE CREATE是准备阶段，IMPDP DATABASE RECOVER是执行阶段 | 工具/auxdb身份、备份清单和完整性、来源库与目标库、LOCAL/新集群身份、阶段回执及恢复控制 |
| TABLE | EXPDP TABLE包含表及相关索引、sequence、分区、toast等文件；IMPDP TABLE PREPARE准备，IMPDP TABLE执行 | 附属对象清单、同一备份来源、AS目标命名、属主及部分失败恢复 |
| PDB | 导出文件后，IMPDP PLUGGABLE DATABASE CREATE执行导入；配置资源计划、打开PDB并连接它后，RECOVER修复 | 导出成功及文件身份、真实资源规格、父连接与PDB连接切换、异常重启恢复 |

不同章节的“CREATE”角色不同：DATABASE CREATE是准备，PDB CREATE是执行。
不能因为名字相同就共享同一个阶段编号。PDB CREATE原文明示禁止普通用户直接
调用，可能引发异常重启；示例中有管理员SQL不取消这条注意事项。

EXPDP章节给出普通调用的auxdb错误；IMPDP其他章节有“可能目录不存在等报错”
的描述。前者不能被扩大为所有IMPDP都有同一个SQLSTATE，后者也不能作为
“任何错误算负向通过”的依据。

本次PDB名可选性的open_question同时引用主语法L15和参数L21–22，仍未决定
省略是否可用。未给这些命令添加普通manifest，未操作任何备份目录。

## 升级合同不能由手工SET代替

一般章节的命令是`GENERATED UPDATE SYSTEM OBJECT`，M章节是
`GENERATED UPDATE SYSTEM`。两者都要求真实OM升级/回滚上下文、初始用户，
不能通过普通连接手工设置upgrade_mode/application_name冒充。

M包的`fixture_m_generated_update_system_om_upgrade`存在，但
`execution.status=not_implemented`，setup/teardown为空是显式阻塞。
已有回归会拒绝把它编译成就绪空生命周期，review产物也只输出注释。
因此“有fixture文件”和“前置资产可用”必须分别统计。

REFRESH SYSTEM OBJECT的本地文档指从507.0之前版本升级时调用，并修改系统
版本目录。这里的507.0是当前PDF描述的升级来源条件，不是把历史507测试结果
当当前产品依据。执行、目录变化和回滚均需要权威升级工具合同。

## 节点与数据库不是同一个隔离范围

SHUTDOWN关闭当前连接的数据库节点。FAST会回滚活跃事务并断开客户端，
IMMEDIATE会在下一次启动触发故障恢复。只创建新数据库或Schema不能隔离
其他连接的影响；至少需要另行授权的独占可销毁节点及带外重启控制。
连接断开不能单独作为关机成功Oracle。

## 本轮产物的准确含义

- planned场景明确工具/文件/阶段/恢复要求，尚不是运行时能力gate。
- 缺口账本保存正文和锚点hash，不把示例目录、角色或资源数值当真实资产。
- 普通候选数量没有因此增加；全库生成保全与相关静态测试另有收据。
- 后续只在获得工具集成合同和执行授权之后推进真实生命周期，不以生成
  `SELECT 1`、删除不存在对象或吞掉异常替代。
