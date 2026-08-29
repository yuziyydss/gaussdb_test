# 架构演进记录

状态：历史决策记录。当前架构以 [ARCHITECTURE.md](ARCHITECTURE.md) 和 [Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md) 为准。

## 1. 起点：单文件因子

最早的 `factors/*.yaml` 在一个文件里同时维护SQL模板、等价类、预期结果、约束和setup。它适合快速原型，但存在三个问题：复杂SQL结构难以表达、规则与前置对象混在一起、不同因子重复维护相同事实。

当前处理：保留Legacy V0兼容读取，新抽取不再写入。

## 2. V0三文件规格

随后引入 `grammars/`、`matrices/`、`manifests/`，把语法、共享能力和测试选择分开，并增加CSP、AST、符号表和场景引擎。

这一阶段验证了职责拆分的方向，但产生了新的问题：

- grammar的values与manifest bindings重复；
- factor和manifest同时维护约束；
- high priority等字段曾出现“模型接受但生成器不消费”；
- 文档原文没有逐单元覆盖账本；
- fixture和scenario仍与测试选择耦合；
- 同一事实可能在四个目录漂移。

当前处理：保留运行时兼容，不再作为新规格的权威来源。

## 3. 生成器正确性加固

已完成：

- Pairwise改为约束感知的可行域覆盖；
- 生成后验证理论可行Pair、实际覆盖Pair和缺失列表；
- 约束解析失败阻止加载；
- 全局case ID与SQL重复检查；
- Schema未知字段禁止；
- negative manifest保存目标规则和目标错误Oracle；
- SELECT/INSERT/CREATE INDEX增加表达式、列数和类型结构契约。

这些能力解决“生成了SQL但无法证明覆盖正确”的问题，但仍不能代替真实数据库执行。

## 4. Factor Package V1

V1把一条SQL语句相关的规格收进一个目录：

```text
specs/<category>/<statement>/
  *.source.yaml
  *.factor.yaml
  *.syntax.yaml
  manifests/
  matrices/
  fixtures/
  scenarios/
```

核心变化：

- factor是产品事实和值域的唯一事实源；
- source ledger记录原文每一行和原子主张的处置；
- syntax只保留SQL结构；
- manifest只选择值、策略和预期；
- matrix保存复杂能力Profile；
- fixture保存对象契约；
- scenario保存状态变化和行为断言；
- 所有文件使用稳定全局ID引用。

## 5. 内网批量抽取

由于完整产品文档不能离开公司内网，项目没有绑定外部AI API，而是使用本地任务队列和Markdown任务信封：

- 语料按章节存放，正文不进入Git；
- inventory记录SHA-256、行数、variant和目标目录；
- worker一次认领一个任务；
- 任意内网AI按同一模板输出V1 package；
- verify核对任务信封并执行三道静态门禁；
- 只有程序可以写入 `static_complete`。

## 6. 尚未完成的演进

- 现有五个示例仍有部分静态审计缺口；
- V1 fixture/scenario尚未接入真实执行器；
- 多会话、权限、生命周期和元数据Oracle未形成执行闭环；
- NoREC、跨引擎差分和自动最小化不是当前已验证能力；
- GUC、函数、操作符、系统目录需要独立建模；
- 5800页文档尚未建立全量语料和任务目录。

后续顺序见 [ROADMAP.md](ROADMAP.md)。
