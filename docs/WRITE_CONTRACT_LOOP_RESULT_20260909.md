# 写入共享合同循环：本批验收结果

本次目标是将文档有据的 M INSERT 入口、M REPLACE 有限新行默认值接入已有共享合同，并核对真实候选。**本批验收完成，不代表整个因子库或28条剩余待审已经完成。** 没有数据库执行，没有提交或推送，也没有恢复过期夜间窗口。

## 实际修改

1. M INSERT 可选 INTO 入口接入现有输入行检查；一般章节范围不变。VALUE 本来就已识别，没有重复建设。
2. M INSERT SET 按新行检查目标列、显式/省略 DEFAULT、非空和生成列保护；不使用 UPDATE 的旧行语义。
3. M REPLACE 值/SET/查询输入复用有限默认值与省略列合同。只解析常量/NULL默认值，不求值函数；SET 自引用和赋值顺序保持待审。
4. M REPLACE 的 NOT NULL 缺省值涉及文档中的默认零值/模式差异，不直接套普通 NULL 结论。新增专门待审边界，也没有将用户输入的 NULL 擅自改写成零值。
5. 生成器目标 SQL、启用 fixture_write_contract 的 seed 和独立审计器继续传递一般/M 来源范围。没有新增 YAML 模型、变更包状态、删除候选或修改 expected。

按 systematic-debugging 与最小修改工作方式，三处均先复现失败再接入共享检查。M REPLACE 正文 SHA 为 `e60dcc69ca5e6e04dfd0988fe0a49011b66cb35dfc7a051e0216205fe5c192a8`，与 source.yaml 相符；L21–27、L61–76 明确其自引用/零值/顺序规则，L83–88、L102–106、L118–123、L137 对应有限新行输入和 DEFAULT。其余来源与逐条根因见[入口阶段记录](M_INSERT_ENTRY_CONTRACT_20260909.md)。

## 验证

| 检查 | 最终结果 | 说明 |
| --- | --- | --- |
| 16个写入/共享合同相关模块 | 182项通过，144.406秒 | 包含所有本批新入口与默认值回归 |
| 3个REPLACE关联模块 | 19项通过，42.440秒 | 唯一键、种子、Oracle声明、既有生成资产等回归 |
| 合计 | **201项相关回归通过** | 两组不重叠，不冒充全项目或实机测试 |
| 受影响消费者再生成 | 6包、54个manifest、272条用例 | 完整序列化字段逐条不变 |
| SQL快照 | 54份与重新渲染的UTF-8字节完全一致 | 不覆盖全库报告 |
| 覆盖和ID | 每个重生成manifest的Pairwise完整，ID无重复 | 没有缩减可行取值域 |

六包为 insert、m_insert、update、m_update、m_replace、m_create_table_select。逐条比较包括 SQL、case_id、参数、预期、Oracle声明、环境条件、setup/teardown 等字段。重新生成后原 generation_report.json 字节不变，SHA-256 仍为 `fee7f40f74d39366991c1058e0016761f72591d6a5a502b5a895826155073415`。

## 进度口径：不隐藏新发现

初始40条待审完整保留：14条获得有限检查证据，26条继续待审。同时发现2条原先被错误标成checked的M REPLACE顺序赋值，将它们恢复为待审。因此当前是 **26 + 2 = 28条待审**，不是通过删除失败项将40条清零。

14条获得证据：8条普通M INSERT输入/冲突更新、2条视图直接投影输入形状、4条M REPLACE常量DEFAULT。视图形状检查不等于可写性验证；REPLACE输入检查不等于验证真实删除和插入。

新增暴露的2条：

- `manifest_m_replace_set_8841f7257e25`
- `manifest_m_replace_set_d385ddb74a7d`

二者包含 `SET id=id+1, qty=id`。文档要求从默认值构造输入行并按顺序赋值，不能把现有表列类型当成已求值结果。保留原SQL、success预期和planned Oracle，未将其改成负向用例。

全库5060条快照的最终写入审计为：4774条不适用、252条checked、28条needs_review、6条rejected；正向rejected为0。6条静态矛盾不自动证明负向Oracle命中。生命周期仍有4730条needs_review、330条transaction_scoped，后者不是执行授权或共享数据库安全保证。

## 保留的28条真实缺口

| 类别 | 数量 | 下一阶段所需证据 |
| --- | ---: | --- |
| 视图/派生目标DEFAULT | 16 | 视图自身默认值身份、可写性及应用规则，不能仅凭基表血缘 |
| 生成列DEFAULT/省略结果 | 4 | 生成表达式输出合同与结果Oracle |
| 视图冲突更新负向规则 | 3 | 将已知文档限制接入目标检查，与实际错误身份分开 |
| IGNORE环境及视图目标 | 2 | 错误降级、模式与目标限制的联合检查 |
| VALUES-IN表达式位置 | 1 | 表达式结构中的上下文判断，不用字符串contains冒充解析 |
| M REPLACE自引用/顺序 | 2 | 有限新行环境、默认零值/模式、从左至右赋值结果 |

这些没有批量标成unsupported，也没有升级为实机verified。后续建议先评审一个有限的“REPLACE新行赋值顺序”合同，或选择视图DEFAULT规则做来源评审；数据库执行仍须单独授权。

## 证据与循环结束策略

本地 `work/write_contract_loop_20260909/` 保留：

- `initial_review_inventory.json`：原40条候选冻结；
- `review_roots.json`：入口阶段逐条正文来源、根因和消费者；
- `final_review_roots.json`：原40条最终结果及独立新增的2条缺口；
- `replace_audit.json`：当前全库只读审计，绑定检查器/入口哈希；
- `final_batch_verification.json`：54个manifest、272条完整字段和SQL字节对照；
- `state.md`：执行轮次、工具证据、剩余工作和调度状态。

work及原文不随代码发布。按创建循环时说明的“本批目标验收后停止”，收齐A1–A4后暂停本次heartbeat；不把“仍有全项目工作”当作无限扩张当前批次的授权。
