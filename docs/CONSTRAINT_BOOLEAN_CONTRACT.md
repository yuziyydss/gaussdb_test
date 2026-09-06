# 约束求解器的布尔与未知值契约

约束DSL采用Python风格的比较和布尔写法，但不是任意Python解释器。and/or/not在这里组合布尔真值，不提供Python用and/or返回原操作数的值选择功能。函数调用、算术和未列出的比较操作符不因此开放。

## 三类真值

- 已知truthy：非空字符串、非零数字、非空集合、True等。
- 已知falsey：空字符串、0、None、空集合、False等。
- UNKNOWN：部分组合尚未给变量赋值；内部使用单独标记，不能经bool转换误当True。

and只要有确定falsey即False；or只要有确定truthy即True。否则仍有未知操作数时保留UNKNOWN，全部已知才给出最终真值。完整赋值缺少所需变量仍报错，不静默放行。

完整规则求值、部分赋值的可行性剪枝、蕴含前提是否触发，使用一致的已知值真值规则。部分求值只能排除已经确定不满足的分支，不能把缺失值误判为不满足。规则覆盖里的“前提触发”也不能仅认True单例而漏掉已知truthy前提。

## 本轮发现与验证范围

旧实现的and/or仅比较is False/is True，造成空字符串或0参与and时可能错误放行，非空字符串或1参与or时可能错误排除。四个构造反例已保存；当前224包的116条factor/local规则盘点没有发现使用该触发形态，因此不能由此断言现有3830条SQL全部失效。

`tests/test_constraint_boolean_semantics.py`使用独立Python布尔谓词验证已声明的布尔结果语义，覆盖9种已知值、完整/部分赋值、UNKNOWN、蕴含触发和非布尔操作数的独立可行pair。Pairwise参考集合由小型笛卡尔积与独立谓词建立，不调用生产solver来生成expected。

独立的200个比较/蕴含参数空间复核保留为单独证据；它只证明这些样本，不证明Pairwise生成用例数最少，也不证明任意SQL合法。所有修正仍需重新生成固定525manifest并核对3830完整用例/SQL/expected，不能改原基线来消除差异。

证据在`work/autonomous_2026_09_06/`：旧反例`constraint_boolean_probe.json`与新`batch11_boolean_probe.json`分别绑定求解器SHA，旧报告不覆盖；本轮测试/生成/对账以`batch11_reconciliation.json`及实际进程收据为准。修改前Batch10的607项全项目通过不能替代修改后的全套验证。
