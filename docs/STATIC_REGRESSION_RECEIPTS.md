# 静态回归：真实进程与输入身份收据

本入口只运行Python unittest，不执行生成SQL。它不连接包ready状态，不修改公共YAML模型，不替代525个manifest的生成对账、覆盖审计或GaussDB实机Oracle。

## 用法

完整回归：

```bash
python3 scripts/run_static_regression.py --output-dir work/validation/my_new_full_run
```

专项回归可显式选择仓库中存在的测试模块：

```bash
python3 scripts/run_static_regression.py --output-dir work/validation/my_new_targeted_run --module tests.test_static_regression_receipt --module tests.test_reconciliation_generation_evidence
```

每次使用**新的输出目录**。已存在目录会被拒绝，不能覆盖历史失败或成功记录。输出限定在本项目work目录内且不在work/doc2spec来源目录下。完整回归可能约20分钟，子进程上限30分钟；运行中冻结代码、测试和输入。

## 三份产物

| 文件 | 意义 |
| --- | --- |
| start.json | 真实开跑前时间、测试命令、Python版本、受核对输入清单与SHA |
| tests.log | 此子进程的完整stdout/stderr，不手写或覆盖测试结果 |
| receipt.json | 实际进程退出码、结束输入清单、增删改差异、日志SHA、测试汇总和判定 |

只有退出码0、非零完整unittest汇总为纯OK、输入起止一致时才是passed。测试失败、输入变化、零测试/无汇总、跳过或expected failures、中断/超时分别保留失败或不完整状态，命令退出非零。测试总数是tests_run，不把跳过算成已通过。

## 身份范围与限制

输入范围以start.json中的input_dirs/input_files/input_suffixes为准：核心、测试、脚本、Web代码/模板、当前与兼容规格、实际章节正文、PDF、生成基线和目录摘要等。检测选定范围文件新增/删除，不只对固定旧清单重算哈希；输入软链接需另行评审，不静默忽略或跨目录跟随。

动态reports、回归日志与字节码不加入输入，避免把测试输出当成输入变化。尚未指纹化所有安装库、外部环境或秘密。起止哈希相同也不能证明中间从未修改再恢复，因此仍要求运行中冻结。

子进程强制GAUSSDB_ENABLED=false；这是配置要求，**不是网络隔离沙箱**。测试代码仍须确认使用未连接或假连接路径。当前test_core中的enabled=True分支注入Recording/FailingConnection或在环境门禁处返回，不能把假连接结果写成实机记录。此入口不接受任意shell命令，只有全套发现或已有tests.test_*模块。

进程崩溃、机器终止等极端情况可能只留下start.json或部分日志；没有有效receipt的运行保持未完成，不得手工补exit-code=0。旧Batch07事后记录保留其“未采集开跑前测试哈希”限制，不用新入口为历史结果补造证明。

静态回归通过只能说明这些测试在记录环境和输入版本下通过；SQL全域覆盖、包静态闭环、目标错误、真实数据库行为必须各自使用对应证据。
