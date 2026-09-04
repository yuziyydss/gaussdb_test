# 12 章跨因子依赖验证

本轮复用已有 PDF 因子包做跨章集成验证，没有新增 12 个因子包。
验证范围是已审核的事实引用、依赖调度、Fixture 编排和失效传播；未连接数据库。

## 输入与范围

- 文档：GaussDB V2.0-10.0.0 集中式版参考，文档版本 01。
- PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。
- 12 章：SELECT、CREATE TABLE、CREATE VIEW、CREATE INDEX、CREATE SEQUENCE、
  ALTER TABLE、DROP TABLE、INSERT、UPDATE、DELETE、MERGE INTO、TRUNCATE。
- 从原 PDF 重新拆章，12/12 章节哈希一致，共 8969 行。
- 全书 general SQL 目录仍为 224 章；本次 12 章是验证批次分母，不是新增抽取数。
- 选择及逐条引用理由：`tests/data/cross_chapter_batch.json`。

每条事实引用保存消费者本章事实、提供者导出事实、两端 source unit、行号和
原文文本。19 条 Fact 引用与 2 条跨包 Fixture 引用合并为 17 条包级依赖边。
这些是实际被消费的依赖，不等于穷尽 12 章出现的所有交叉引用。

## 依赖内容

下表箭头含义为“消费者依赖提供者”。

| 消费者 | 提供者 | 本批引用的用途 |
|---|---|---|
| CREATE VIEW | SELECT | AS query 的输出列形式 |
| INSERT | SELECT、CREATE VIEW、CREATE TABLE | 输入投影、保留键/只读规则、视图基表 Fixture |
| UPDATE | SELECT、CREATE VIEW | FROM 来源、保留键/只读规则 |
| DELETE | SELECT、CREATE VIEW | 子查询 FROM、保留键/只读规则 |
| MERGE INTO | SELECT、CREATE TABLE | USING 子查询、目标列默认值 |
| CREATE INDEX | CREATE TABLE | 基表默认存储引擎 |
| CREATE SEQUENCE | CREATE TABLE | OWNED BY 与显式列默认值的区别 |
| ALTER TABLE | CREATE TABLE | NOT NULL、PRIMARY KEY 定义 |
| DROP TABLE | CREATE VIEW、CREATE TABLE | 依赖视图示例、视图基表 Fixture |
| TRUNCATE | CREATE SEQUENCE、CREATE INDEX | 带序列默认值的前置条件、GLOBAL/LOCAL 范围 |

SELECT 和 CREATE TABLE 是这组已声明依赖的根节点。没有为了让所有节点都有
入边而添加虚构引用，也没有把 SELECT 文档支持的全部查询分支直接当作 DML
目标或可更新视图的合法域。

## 验证结果

| 检查 | 结果 |
|---|---:|
| 原 PDF 重新抽取并匹配章节哈希 | 12/12 |
| Fact 引用、显式导出、类型和两端 source unit | 19/19 |
| 包级 DAG、传递闭包及认领顺序 | 12 章通过 |
| 无效引用/类型/循环故障注入 | 6/6 被拒绝 |
| 跨包 Fixture 链 | 2/2 |
| 实际生成 SQL 中的 Fixture 顺序 | 34/34 条用例 |
| 本批 manifest | 114 |
| 本批唯一 SQL case | 1337 |
| 本批已建模可行 Pair | 14606/14606 |
| 章节/包变更传播实验 | 10/10 |
| 变更实验中的逐任务失效集合核对 | 120/120 |
| 自动化回归 | 134/134 |
| 真实任务队列 `needs_review` | 12 |
| 真实任务队列 `static_complete` | 0 |
| 数据库执行 | 未进行 |

两个实际 Fixture 已拆分为：

1. `fixture_create_table_insert_view_base` → `fixture_insert_view_target`，26 个消费用例；
2. `fixture_create_table_drop_view_base` → `fixture_drop_table_dependent_view`，8 个消费用例。

验证对每条用例检查：基表只创建一次且先于视图，视图只创建一次；teardown 先
删除视图再删除基表。视图和基表各自声明真实列契约，消费者使用展开后的依赖。
本轮没有扩大 SQL 值域；批次脚本还对照原 canonical 报告逐条核对目标 SQL 和
case ID，Fixture 的 setup/teardown 允许因职责拆分而调整。

## 失效传播实验

对 5 个真实提供者各做两次故障注入：修改包 YAML；修改章节正文且不运行
inventory。所有操作只发生在临时副本，恢复后逐任务重新检查 freshness。

| 修改的提供者 | 必须失效的包（含自身） | 保持有效数量 |
|---|---|---:|
| SELECT | SELECT、CREATE VIEW、INSERT、UPDATE、DELETE、MERGE INTO、DROP TABLE | 5 |
| CREATE TABLE | CREATE TABLE、ALTER TABLE、CREATE INDEX、CREATE SEQUENCE、DROP TABLE、INSERT、MERGE INTO、TRUNCATE | 4 |
| CREATE VIEW | CREATE VIEW、INSERT、UPDATE、DELETE、DROP TABLE | 7 |
| CREATE SEQUENCE | CREATE SEQUENCE、TRUNCATE | 10 |
| CREATE INDEX | CREATE INDEX、TRUNCATE | 10 |

另将 SELECT 设为 blocked，在隔离队列中逐次调用真实认领函数。CREATE TABLE、
ALTER TABLE、CREATE INDEX、CREATE SEQUENCE、TRUNCATE 仍可推进；SELECT 的
消费者及传递消费者不能被认领。

故障注入覆盖缺失 Fact、未导出 Fact、错误 Fact 类型、因子循环、缺失 Fixture
和 Fixture 循环。报告保存实际校验错误，不能用“有异常”替代命中目标错误。

## 本轮发现并修复

之前 dependency snapshot 部分使用队列保存的 `source_sha256`，未读取依赖正文。
复现步骤是只修改提供者章节文件、保留队列哈希，旧实现仍把消费者判断为 fresh。
已用失败先行测试复现并修复：队列内依赖现在核对实际正文哈希，快照保存正文
路径，无需重新 inventory 也能发现漂移。无队列参数的 freshness 检查也使用该路径。

同时更新了 DELETE/UPDATE 中“CREATE VIEW 尚未接入”的过时缺口说明。定义已
可引用，但完整连接形态、CHECK OPTION 及行为验证仍保持待完成，未提升状态。

## 结果边界和下一批

- Pairwise 完整只对应当前 manifest 的已建模可行参数对。
- 12 章依然有文档域、环境、目标 Oracle 和 planned scenario 缺口，依赖测试
  通过不把这些包自动提升为 `static_complete` 或数据库验证通过。
- 失效实验中的 `static_complete` 仅是临时副本中的测试前提；真实队列没有被
  人工改成通过。报告用 `simulation: true` 明确标记。
- 当前精准失效以章节/包为单位，同一包中未被引用的 Fact 变化仍可能使消费者
  失效。父 PDF 或公共工具链变化也仍属于全局失效，不属于逐章节实验。
- 批次外包若没有正文定位，只能检查声明哈希与包哈希；因此批次必须包含已知
  依赖闭包及其正文，本脚本会检查闭包未漏章。
- 仍未实现抽取前自动发现依赖、全局共享 Capability 和公共 Subgrammar。

这组结果支持下一批按 20～30 章推进。新批次应先明确事实提供者和消费者，纳入
实际依赖闭包，对无法确认的交叉引用保留人工队列。无需继续让这 12 章承担所有
数据库行为验证，也无需重构公共 Schema 才能开始下一批。

## 重跑与产物

```bash
python3 scripts/verify_cross_chapter_dependencies.py
# 当前 Python 未装 pypdf 时，可以指定带 pypdf 的解释器：
python3 scripts/verify_cross_chapter_dependencies.py --pdf-python /path/to/python
python3 -m unittest discover -s tests
```

脚本默认输出到 `work/doc2spec/batches/cross_chapter_12/`：

- `corpus/catalog.json` 和章节正文：从原 PDF 重新抽取；
- `queue.json`：真实的 12 章检查结果及状态；
- `dependency_report.json`：每条引用的两端原文、检查结果、依赖快照和隔离实验；
- `generated/generation_report.json`：整批 SQL case 和 Pair 报告；
- `generated/<factor>/*.sql`：setup、目标 SQL、teardown；
- `generated/<factor>/coverage_audit.json`：保留未完成覆盖项。

生成目录可以重建。长期维护的是批次配置、脚本、回归测试与这份验收说明。
