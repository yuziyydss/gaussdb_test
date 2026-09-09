# DEFAULT 合同下一轮：先补冲突更新的实际消费者

## 现状与选择

基础表省略列、显式 DEFAULT、显式 NULL、生成列禁止直接赋值及视图 DEFAULT 不继承的检查已经存在。本轮不另建列模型，也没有开始重放任意 ALTER TABLE 状态。

实际发现：`inspect_write` 检查 INSERT 的输入行，但未将冲突更新的赋值送入共享列合同。对 `qty INT NOT NULL DEFAULT NULL`，`INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=DEFAULT` 和简单 `ON CONFLICT(id) DO UPDATE SET qty=DEFAULT` 都会被错误标为有限检查通过；更新不存在列为 DEFAULT 和动态默认值也被跳过。

## 有限修复

`check_conflict_defaults` 定位真实顶层冲突子句，在含非字符串 DEFAULT 标记时复用现有 `check_assignments` 和目标列默认值检查。简单赋值、元组、目标别名与多输入行复用同一逻辑；复杂冲突目标、动态 DEFAULT、视图 DEFAULT 和未支持表达式保持待审。

没有改变语法规格、SQL 渲染、case ID 或错误 Oracle。该检查不证明唯一键仲裁、兼容模式、WHERE/RETURNING 的完整语义、实际更新行数或数据库成功。没有 DEFAULT 的其他冲突更新表达式也不因本补丁获得新的覆盖结论。

## 实际验证

- 初始6项回归：6个失败断言（含两个模式子测试），1个既有正常路径保留；真实失败记录 `c060ec`。
- 首次新旧合同38项通过，随后加入元组、别名、查询源、视图和字符串边界，8个相关模块74项通过，耗时81.019秒，退出0。
- 对提交 `ad8cd38` 的检查器做只读对照：一般/M INSERT、UPDATE共240条候选，仅2条原checked改为needs_review。两条均为 `VALUES(note)` 与 `aux=DEFAULT` 混合更新，未支持的表达式不再被输入行验证掩盖。
- 重新生成四包48个manifest、240条候选，逐条case ID、SQL、params、expected、setup和teardown完全一致。未覆盖写入新SQL快照，无数据库执行。
- 历史1166项全模块回归属于上一个已提交基线，不冒充本补丁的全量回归；本补丁目前为上述74项专项和240条再生成验证。

## 后续

下一步评审冲突更新中 `VALUES(column)`/`EXCLUDED.column` 的输出列身份与类型来源，再决定是否扩大合同。ALTER修改默认值后的状态传递另立有界任务，先保留当前失效保护；动态默认、视图可更新性、唯一键及运行时错误均不得靠字符串替换推导。
