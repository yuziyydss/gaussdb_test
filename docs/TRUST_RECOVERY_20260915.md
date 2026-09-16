# 2026-09-15 可信性恢复

基线：8e78a3a。只修改本地代码/规格/静态产物；没有数据库执行或 Git 发布。

## 工作范围

1. 恢复 39 个文件中的 47 个测试入口；去除全包 continue 绕过；从旧提交找回被删掉的模式、fixture、负向 Oracle 断言。
2. 历史一次性 builder 不再要求覆盖新增 source units，但旧事实不得降级/删除，原有可执行资产仍比较。
   允许的演进只有新增 facts/scenarios、来源单元细拆、追加来源和已识别的文字批次标签。
   添加独立 mutation tests，确保这些例外不能掩盖 SQL、维度、规则、Oracle 或来源覆盖变化。
3. 发现 154 处旧事实类型被降成 example，恢复已溯源的类型；修复 12 条改写后丢失/混入分支的语法摘要。
   第二批 18 个包的通用语法摘要改成来源区间内的直接片段，并明确不代表完整生产式。
   保留新增文档事实、场景和所有 source completion 工作，不运行旧 builder 覆盖整个包。
4. 新增参考事实对账脚本：67 YAML / 885 records / 885 qualified IDs / 877 bare IDs；8组裸ID冲突不静默覆盖。
   修复一条漏写 id 的记录。882 confirmed 与3 needs_verification 都属于文档层状态，不是实机证据。
5. 修复 auto_validate 的假PASS、前置失败继续执行、固定schema清理和清理错误不报的问题。
   结果集按有限文本单元精确匹配，影响行数精确匹配；负向匹配 target 阶段的目标SQLSTATE。
   空结果/空字符串及带分隔符单元仍需结构化传输合同，当前拒绝将歧义输出判为PASS。
6. 接入有限 ASCII 字符串长度合同，参见 STRING_LENGTH_CONTRACT_V1.md。

## 验证证据位置

- `work/trust_recovery_20260915/compat_fact_inventory.json`：可重算的参考记录账本。
- `work/trust_recovery_20260915/baseline_generation_report.json`：修改前5273候选基线。
- `work/trust_recovery_20260915/regenerated/`：隔离重生成预览。
- 后续静态收据必须匹配最终冻结输入；中途修改的诊断运行不得标作当前全量通过。

## 剩余范围

参考事实的模式、阶段、函数身份和实际消费者仍需按合同逐批复核；不一次精修885条。
数据库执行、目标Oracle校准、复杂字符串转换和其它共享合同不由本次静态检查推导完成。

## 最终验收结果

采用先复现失败、再修复、最后冻结输入的验证方式。中途诊断失败日志不作为最终版本收据。

| 检查 | 最终结果 |
| --- | --- |
| 全量测试模块 | 262个，四片覆盖集合与当前模块集合完全相同，无漏分/重复分配 |
| 静态回归 | 1938/1938，四片分别443、443、555、497条，退出码均为0，无skip/expected-failure |
| 输入一致性 | 四片均验证9634个输入文件；前后端点及最终工作区一致 |
| 恢复的测试 | 47/47在最终日志中找到实际通过记录 |
| SQL生成 | 841个manifest，5273个唯一case_id |
| 产物保护 | 完整generation_report.json与修复前逐字节一致，含SQL、参数、预期、fixture与覆盖缺口 |
| 新长度检查实际消费者 | 95条：INSERT 55、UPDATE 40；DEFAULT与seed复用相同有限字面量检查 |
| 渲染写合同审计 | 314 checked、20 needs_review、26 rejected、4913不适用；正向rejected为0 |
| 数据库执行 / Git发布 | 均未进行 |

最终机器收据：`work/trust_recovery_20260915/full/result.json`。
各片完整日志、原始收据与输入清单位于同目录的 `shard_1` 至 `shard_4`。
SQL报告SHA-256：`37e49c5f3ea67f0a5e699b27ebf20c9d9f69e86635fa91cfc5aa13ef556b45d9`。

补充来源复核：`work/trust_recovery_20260915/duplicate_source_review.json` 记录8组裸ID重名的
模式、阶段、条件和实际PDF物理页；其中有页码偏移及范围需要收窄，未静默合并或删除记录。
对core/specs的字面ID引用扫描为0；885条参考记录仍不能宣称全部已接入生成器。

下一批建议限定为：修正这8组记录的来源元数据，并在明确M模式/编码/列声明条件后，
推进一个字符串与DEFAULT合同；不扩展至全量885条，也不自动开始数据库执行。
