# B模式自增：先证明列与状态前置，再测分配结果

新增有限合同针对一般章的B模式，不借用M模式IDENTITY/自增规则。
当前包含ALTER设置与INSERT分配触发候选，**不是完整INSERT自增状态机**。

## 原文先澄清的三个区别

1. CREATE TABLE初值必须为正数，ALTER TABLE设置值可为非负数，只有大于当前
   自增计数器时才生效。两章的零值边界不同，不共享一个“数字合法”结论。
2. 本地PDF物理1539页/印刷1490页和物理1278页/印刷1229页图像均显示上界
   **2^127-1**，不是文本提取粘连后的2127-1。这个表级设置上界不代表INTEGER
   自增列能生成该数；列类型最大值另有约束，具体边界和错误Oracle仍待校准。
3. AUTO_INCREMENT列不允许声明普通DEFAULT，但INSERT省略该列或传0、NULL、
   DEFAULT会触发自增。它既不等于普通NOT NULL列的NULL赋值，也不等于IDENTITY。

依据：CREATE TABLE L383–389、L820–851；ALTER TABLE L290–293、L1272–1296。
PDF图像只用于排版澄清，未修改原PDF/正文；上界待决项仍保留列类型与运行时问题，
未因看清指数就把整个自增领域标完成。

## 这次实际接入

`fixture_alter_table_autoincrement_fresh`明确创建一个INTEGER PRIMARY KEY AUTO_INCREMENT
列和普通note列，显式初值1，没有历史写入。新增manifest通过原有ALTER AST生成：

```sql
ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 10;
ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 0;
```

两条是**各自重新创建前置的独立case**，不能顺序复用同一张表和计数器。
来源支持10大于声明初值、0不大于声明初值的区别；实际当前计数器、下一次分配值
仍没有读取或验证。场景仅绑定设置10的一条候选，0的行为对照另需独立资产。

生成器校验实际setup，而非相信provides：普通主键冒充自增列、DEFAULT/IDENTITY
替换、自增初值被改为100、附加历史INSERT、非B环境、缺合同标记、action取值与
渲染不一致都不能通过有限合同。现有普通列DEFAULT检查保持拒绝这些未建模状态。
未手工改SQL，未创建/删除任何数据库对象。

## INSERT已共享的有限边界

`check_fresh_autoincrement_source`现已由ALTER和INSERT共同调用，核真实DDL、初值、
模式、清理目标和无历史写入。INSERT新增三个独立fresh候选：

```sql
INSERT INTO g_b_insert_autoinc (id, note) VALUES (NULL, 1);
INSERT INTO g_b_insert_autoinc (id, note) VALUES (0, 1);
INSERT INTO g_b_insert_autoinc (id, note) VALUES (DEFAULT, 1);
```

每条重新建表，不共享计数器；DEFAULT和NULL输出类型标签没有伪装成INTEGER。
生成守卫核对实际输入与选定trigger，拒绝错列、额外语句、历史写入、去标记、M模式借用。
另一个独立manifest生成`INSERT INTO g_b_insert_autoinc (note) VALUES (1);`，
把省略自增列与note列显式赋值的映射分开证明。现有NULL和省略各有一个手工Oracle
待校准场景；不把两个场景当成四类分配行为已经验证。

有限写入审计器现在从候选显式传递环境要求及teardown，重新核实际DDL和目标输入，
而非根据表名猜B、根据普通DEFAULT常量解析或直接相信旧审计。返回独立的
`finite_b_auto_increment_allocation_input`检查和`auto_increment`证据，
其中`counter_value_proven`、`runtime_proven`、`cleanup_ownership_proven`仍为false。
缺门、重复门、M来源、错DDL、历史写入、其他输入保持needs_review，不猜数据库错误。
这份上下文不向CTE递归或fixture setup前缀传递；RETURNING精确结果也仍在有限范围外。
审计哈希覆盖共享自增模块，模块变化会使旧报告的代码指纹失效。

`checked`只说明本次列身份/映射/有限分配触发输入检查通过，不是完整SQL可执行性、
计数器实际状态、权限、目录身份或整个自增特性已验证。

在关联任何精确结果Oracle前，必须明确缓存、并发消费、
失败后计数器不回滚和实际对象身份；不能只根据一条INSERT失败断定计数器未改变。
本地临时表不创建自增序列，不能套本轮永久表的隐式依赖清理方式。

目前隐式序列/主键索引归属、成功建表回执、目录接口、实际B模式/权限均待验证。
仅在新鲜独占用户Schema且确认本case成功创建及拥有依赖后才允许按计划清理；
不允许直接DROP内部序列，事务ROLLBACK不能证明计数器或对象生命周期已经复原。
