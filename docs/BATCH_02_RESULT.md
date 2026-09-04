# 第二批 PDF Doc2Spec 验收结果

状态：静态抽取与生成已完成；数据库执行未进行。

本报告只评价冻结 PDF 到 Factor Package V1、SQL 候选和静态证据的链路。
`needs_review` 表示缺口被系统正确保留，不等价于任务失败，也不表示 SQL 已在
GaussDB 上执行通过。

## 1. 固定输入与分母

- 产品版本：`V2.0-10.0.0`
- 文档版本：`01`
- 父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`
- 批次 catalog SHA-256：`cbea45ca5a96938432c0562d3a15c58cefee430f0ddfece1bb682820e31f9fad`
- 本批：10 个章节、3572 行、DDL 4 / DML 3 / DCL 1 / TCL 2
- 整本 PDF 的 general SQL catalog：224 个章节；本批只占其中 10 个

必须同时保留两个口径：本批 10/10 已拆章并绑定包；整本 PDF 仍是
10/224 已进入本批抽取，不能把前者写成全书完成率。

## 2. 最终静态门禁

| 指标 | 结果 |
|---|---:|
| 任务信封、章节哈希和行数对账 | 10/10 |
| Factor Package 严格加载 | 10/10 |
| Source 行覆盖 | 3572/3572 |
| Source units | 763 |
| Source atomicity gaps | 0 |
| 第二批 manifests | 48 |
| 第二批生成 SQL 候选 | 702 |
| 可行 Pair 覆盖 | 6031/6031 |
| 跨 manifest 重复 case ID | 0 |
| 跨 manifest 重复 SQL | 0 |
| 目标/setup/teardown 基础 SQL 校验错误 | 0 |
| Queue `needs_review` | 10 |
| Queue `static_complete` | 0 |
| 数据库执行 | 未进行 |

全仓库 canonical 生成结果为 15 个 PDF factor、123 个 manifest、1644 条
SQL 候选。全量自动化测试为 131/131；最终复验命令见第 7 节。

## 3. 分章节结果

| Factor | Lines | Units | Manifests | Cases | Pair | Source | Generation | Open facts | Feature gaps | Planned |
|---|---:|---:|---:|---:|---:|---|---|---:|---:|---:|
| BEGIN | 93 | 23 | 2 | 30 | 84/84 | true | true | 3 | 5 | 3 |
| COMMIT / END | 66 | 15 | 1 | 6 | 6/6 | true | true | 1 | 0 | 3 |
| CREATE SEQUENCE | 199 | 44 | 4 | 175 | 647/647 | true | false | 2 | 1 | 8 |
| CREATE TABLE | 1351 | 307 | 2 | 8 | 24/24 | true | true | 22 | 11 | 7 |
| DROP TABLE | 64 | 18 | 3 | 17 | 63/63 | true | true | 1 | 2 | 7 |
| TRUNCATE | 156 | 36 | 6 | 44 | 857/857 | true | true | 5 | 6 | 8 |
| DELETE | 421 | 68 | 6 | 55 | 1179/1179 | true | false | 7 | 10 | 8 |
| GRANT | 636 | 134 | 6 | 271 | 1944/1944 | true | false | 2 | 14 | 7 |
| MERGE INTO | 154 | 48 | 6 | 38 | 162/162 | true | true | 11 | 14 | 5 |
| UPDATE | 432 | 70 | 12 | 58 | 1065/1065 | true | false | 13 | 18 | 10 |

`Generation=false` 的四个包不是生成器崩溃，而是仍有未选择的条件值、环境型
值域或规则/profile 缺口；这些内容没有被删除，而是使结论保持 false。
10 个包均因 open question、feature domain、Oracle 或 planned scenario 未关闭而
保持 `static_complete=false`。

## 4. 人工交叉审查发现并修复的问题

统一生成门禁之后又进行了逐包和逐锚点审查，修复了以下确定性问题：

1. DELETE 的 USING 表与目标表同名列造成未限定引用歧义，多目标表别名与谓词
   不一致；现已统一列/别名契约，55 条用例及 Pair 覆盖不缩水。
2. GRANT 的部分 manifest 会修改预置角色的成员关系或全局权限，却没有可靠的
   对称回收；这些用例已移入 planned lifecycle，不再伪装成可独立执行候选。
3. CREATE SEQUENCE 的系统列负向用例会先命中“列不存在”，不能隔离目标规则；
   已转为 `needs_profile`/planned scenario，schema 语法候选降为 `syntax_only`。
4. DROP TABLE/TRUNCATE 的通用 fixture、YAML flow list 和分区 profile 曾造成
   对象不匹配或错误参数形态；已改为专用可控 fixture，并移除无证据的分区值。
5. CREATE TABLE 曾把 LIKE 专属 GUC 规则推广到一般 STORAGE_TYPE，并为
   COMPRESSLEVEL 加入原文没有的表类型限制；逐锚点复核后已纠正，并将范围、
   默认值、环境和行为拆成独立事实。57 个高风险原子性候选全部复核，最终
   307 units、0 atomicity gap。

这些结果证明“lint 通过”仍不能代替语义抽检。静态校验只能说明 SQL 候选满足
当前结构和契约，不能证明其在目标 GaussDB 版本上必然执行成功。

## 5. 首轮通过率与重试率的证据限制

当前 queue 的 `attempt=1` 记录任务认领次数，而每次 `verify` 会覆盖上一轮
`checks`。因此本批无法从机器事实源可靠重建首轮通过率和逐任务重试次数；本
报告不使用对话回忆伪造百分比。最终一次 verify 的事实是：10/10 信封、lint、
generate 通过，10/10 因诚实的 audit gaps 进入 `needs_review`。

该缺口已登记到 `FACTOR_PACKAGE_V1_1_CHANGE_PROPOSALS.md` 的 P6：后续 queue
需要追加不可变验证历史，同时保留当前 `checks` 最新快照。

## 6. 扩批决策

第二批已经证明冻结的 V1 能跨 DDL、DML、DCL、TCL 工作，并能把复杂或环境
依赖域隔离为人工队列；没有发现必须阻塞所有简单章节的公共生成器缺陷。
下一步可以进入每批 20～30 章，但必须保持以下门禁：

- 简单章节独立推进，高风险章节进入 `needs_review`，不拖住整个批次；
- 每个批次都保留 PDF 总目录与本批任务两个分母；
- 自动门禁后仍做按风险分层的逐锚点抽检；
- 不把 Pairwise 100% 写成文档全域或数据库行为 100%；
- V1.1 提案单独评审，不与某个章节的抽取混合实现。

## 7. 可重复复验

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 scripts/audit_factor_coverage_v1.py
python3 -m unittest discover -s tests
python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_02/queue.json \
  summary
```

逐任务严格验证应使用 `manage_extraction_queue.py ... verify`。其返回码 1 可以
表示预期的覆盖缺口；必须检查 `checks`，确认 task envelope、lint 和 generate
为 0，且只有 audit 因公开缺口为 1，不能用 `|| true` 隐藏工具故障。
