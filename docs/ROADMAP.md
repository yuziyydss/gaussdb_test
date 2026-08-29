# 项目路线图

本路线图只记录已由代码和测试证明的能力，以及具有明确验收条件的下一阶段。数据库执行和5800页全量抽取未完成前，不使用“工业级闭环”描述。

## 当前阶段

```text
Legacy V0兼容
      │
      ├── 已完成：生成器正确性加固
      ├── 已完成：Factor Package V1静态架构
      ├── 已完成：5个代表性因子适配
      ├── 已完成：内网离线任务队列
      ▼
当前：关闭基线缺口 + 内网10章节试点
      ▼
下一步：一个完整SQL子目录
      ▼
后续：V1真实执行与非SQL参考Schema
```

## 已完成并有自动化证据

- [x] 约束解析失败即报错，不再静默放行。
- [x] 约束感知Pairwise生成和100%可行Pair后置验证。
- [x] case ID和跨manifest SQL重复检测。
- [x] Pydantic严格模式、重复ID和引用闭合校验。
- [x] Factor Package V1单一写入目录和七类文件职责。
- [x] 递归AST、重复结构和嵌套查询。
- [x] SELECT、INSERT和CREATE INDEX结构契约。
- [x] Fixture setup/provides/teardown静态模型。
- [x] 负向用例目标错误类别、SQLSTATE集合和错误正则。
- [x] Source Unit逐行账本和原子性审计器。
- [x] CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT、INSERT五个V1示例。
- [x] 56个manifest生成865个唯一case。
- [x] 69项自动化测试通过。
- [x] AI厂商无关的内网任务队列、SHA-256对账和断点恢复。

## 阶段A：关闭当前基线缺口

目标：让现有五个示例成为内网AI可以可靠模仿的基线。

验收：

- CREATE VIEW和SELECT的source unit全部完成原子性复核；
- matrix中 `needs_profile` feature有明确处理结果；
- 每个confirmed非example fact都有下游消费者；
- `audit_factor_coverage_v1.py --fail-on-gaps` 对目标factor返回0；
- 不通过删除事实或降低门禁制造“绿色”。

## 阶段B：内网10章节试点

建议选择 UPDATE、DELETE、MERGE、CREATE TABLE、CREATE SEQUENCE、DROP TABLE、TRUNCATE、GRANT 和一到两个复杂权限/事务章节。

验收：

- 每个章节对应一个稳定任务和一个Factor Package；
- 任务信封SHA-256、行数与package一致；
- 统计首轮门禁通过率、重试次数、open question和人工抽检错误率；
- 发现的模型缺口先集中评审，不让单个AI私自修改Schema；
- 10个任务完成后再决定是否扩大批量。

## 阶段C：完整SQL子目录

优先选择DML或DDL中的一个完整目录，不同时展开全部文档类型。

验收：

- 文档总目录与语料任务清单可以取差集；
- 相同命令的general、M/B兼容模式彼此隔离；
- 全库严格加载和全局ID检查持续通过；
- 失败原因可以归类为原文问题、抽取问题、模型缺口或生成器缺陷；
- 人工抽检达到团队设定的质量阈值后才扩容。

## 阶段D：V1数据库执行

范围：把V1 fixture、manifest Oracle和scenario接入执行器。

验收：

- fixture setup失败不能满足目标负向用例；
- teardown在成功和失败路径都可恢复；
- 负向用例匹配目标SQLSTATE/错误类别，而非任意错误；
- planned scenario能记录真实执行状态；
- 权限、多会话和生命周期场景使用隔离环境；
- 静态闭环与行为闭环仍分开报告。

## 阶段E：非SQL命令参考

数据类型、函数、操作符、GUC和系统目录不应强行套用单条SQL命令Factor。先分别确定输入、事实类型和Oracle，再建立专用Schema或共享能力包。

在此之前，相关内容只能登记为任务库存或未来需求，不能计入SQL Factor覆盖率。
