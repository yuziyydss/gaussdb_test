# DELETE独立有限静态检查

`core/finite_delete_contract.py`复用已有有序DDL和共享列证据，检查有限单目标DELETE。它不是GaussDB解析器、执行器或行数Oracle，不改变公共YAML模型。

## 范围

- 普通表，可选FROM、ONLY、星号、有限别名；ONLY/星号只记录目标修饰语法，不证明继承对象集合。
- 单基表直接用户列的视图/派生目标，使用真实setup的血缘，不伪造CREATE VIEW或对象名。
- 无WHERE，或一个直接目标列与同类型字面量的等式。
- 一个直接目标列的ORDER BY，可选ASC/DESC；可选正int32字面量LIMIT。只检查列引用与有限形状，不证明排序稳定性或实际删除哪些行。int32是本检查器的保守边界，不是产品限制。
- 单个完整USING普通关系：目标/源都须有实际普通列证据，关系身份明确、alias不冲突；有限未限定目标列与源同名时保持待审。目标重复、视图/CTE源、联接和多源不在该范围；未证明实际关联行数或可见性。
- 可选RETURNING直接目标列、AS输出名或星号；不明/重复输出名保持待审。
- 主句的CTE复用已建立的有限输出/内部写入证据，不新增其谓词、基数、物化或可见性证明。

DELETE不向行写值，因此不会套用INSERT省略列/DEFAULT逻辑。若CTE内部确实是INSERT，则其内部仍需要该校验，报告使用`dml_cte:`前缀区分主句与内层。

复杂USING、复杂排序（表达式、多键、自定义操作符等）、非有限LIMIT、分区、多目标、游标、复杂谓词或计算RETURNING等当前保持needs_review，**不代表产品不支持**。不会删掉这些子句再把简化SQL算作原SQL通过。USING→WHERE→ORDER BY→LIMIT→RETURNING必须按序完整消费，乱序或重复不能忽略。READ ONLY、CHECK OPTION、连接保留键、系统视图和触发器也没有被提升成可删除证明。

## 独立分母

现有write_contract仍保持原来的INSERT/UPDATE/INSERT ALL/REPLACE范围，inspect_write对DELETE的行为不变。新报告单独选取全部DELETE因子候选，明确：

| 统计项 | 当前基线 |
| --- | ---: |
| 全部生成用例 | 3830 |
| 本报告选择的DELETE用例 | 71 |
| 有限形状checked | 35 |
| needs_review | 36 |
| 本报告范围外 | 3759 |

不能把35直接加到原写入审计的checked计数，或改成包级静态闭环/数据库通过率。36条不是数据库失败，负向multi-view的目标错误Oracle仍未验证。其中16条分区用例已有真实分区DDL，fixture_unknown表示未建立普通列契约，不能误报为没有建表。

## 运行

```bash
python3 scripts/audit_delete_contracts.py --generation-report generated/factor_packages/generation_report.json --output work/validation/delete_audit_new.json
python3 -m unittest tests.test_delete_main_contract tests.test_delete_contract_audit -v
```

输出使用新文件，已有报告不覆盖。报告包含完整case哈希、SQL、expected、原生命周期风险、检查器哈希与生成报告哈希；全局重复case ID会报错，发现正向静态矛盾时CLI非零退出。运行版本和输入身份需结合静态回归收据核对。

原14条证据保留于`work/autonomous_2026_09_06/batch13_delete_reconciliation.json`；Batch15的`batch15_delete_reconciliation.json`绑定原14条不撤回、新增仅已逐条审阅的16条，及原3830写入审计完全不变。182项专项收据通过；全套验收需看最新运行收据，不能沿用改造前624项结论。来源为本地冻结PDF的DELETE物理1650–1657页及SELECT排序/LIMIT物理1832–1834页，相关视图/CTE事实沿用既有依赖与共享契约，不将外部产品版本或历史运行结果混入。

Batch17的`batch17_delete_reconciliation.json`保留原30并绑定新增5条USING证据；`batch17_reconciliation.json`纳入185专项+15 API共200项、224包/525快照/3830完整case身份一致。Batch16的626项全套是USING修改前版本，当前全套看`batch18_full_receipt/receipt.json`实际结果；没有收据时不能宣称完成。

最终版本另包含共享模块的DEFAULT诊断澄清，DELETE的71条记录完全不变。`batch20_final_full_receipt/receipt.json`实际633项通过；`final_evidence.json`绑定该完整收据、最新专项/API与当前7503个受测输入、原始用例及来源身份。所有文件位于`work/autonomous_2026_09_06/`。这仍是静态验收，不是数据库执行。

无WHERE可能删除所有行；checked从不构成执行授权。当前未运行数据库，也未修改SQL、fixture、expected、包ready或Oracle状态。
