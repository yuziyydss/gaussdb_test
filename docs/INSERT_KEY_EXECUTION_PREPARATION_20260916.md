# PG 同键元组与 file_fdw 离线执行准备（2026-09-16）

本轮接续 2026-09-15 的 file_fdw 增量，关闭最新一批离线执行准备缺口。
没有连接数据库、没有部署服务器文件、没有执行 Git 提交或推送。

## 范围与结果

- 上一轮正式产物：845 个 manifest、5,292 条候选。
- 当前正式产物：846 个 manifest、5,295 条候选。
- 唯一新增 manifest：`manifest_insert_same_key_tuple`，包含 3 个独立分支：
  - 同键 conflict
  - 新键 insert
  - WHERE filtered
- 对旧 845 个 manifest 的候选对象逐项比较，除报告中的 SQL 快照输出路径外，
  SQL、case ID、参数、预期、环境门槛和生命周期均不变。
- 新增 SQL 快照：
  `generated/factor_packages/insert/manifest_insert_same_key_tuple.sql`。

本轮没有把 `expected_oracle_status=confirmed` 或 `scope=syntax_only` 解释为实机通过。
三个 result-set Oracle 仍处于待校准状态，只能在授权数据库中执行后关闭。

## 离线执行准备接入

`core/execution_preparation.py` 现在重新计算实际绑定候选的有限合同，而不是信任标签：

1. PG 同键元组合同复用 `core/insert_conflict_key_contract.py`：
   - 校验实际 DDL、种子、模式门槛和目标 SQL；
   - 输出 `same_inline_integer_key_tuple_v1` finite contract evidence；
   - 从有限种子与输入推导 planned rows；
   - 修改 Oracle SQL 或 expected 后输出 `finite_oracle_identity:write` blocker。
2. file_fdw 输入合同复用 `core/file_fdw_options_contract.py`：
   - 重新检查本地文件字节、OPTIONS、setup 和 RESTRICT cleanup；
   - 目标 `CREATE FOREIGN TABLE` 进入 ownership plan，标记为 `phase=target`；
   - 依赖显式记录为 schema 与 server；
   - 文件计划要求 validator、SELECT 权限和目标 CREATE 成功回执；
   - 修改 expected 或额外 step 时输出 blocker；
   - 保留 `exclusive_file_fdw_namespace_serialization` 运行时证据要求。
3. 新增 bounded profile：
   - `insert_same_key`
   - `file_fdw_options`

生成命令：

```bash
python3 scripts/prepare_execution_batch.py \
  --profile insert_same_key \
  --output work/insert_key_20260916/insert_same_key_preparation.json

python3 scripts/prepare_execution_batch.py \
  --profile file_fdw_options \
  --output work/insert_key_20260916/file_fdw_options_preparation.json
```

结果：

| Profile | Packages | Manifests | Candidates | Sequences | Bound | Runtime verified |
|---|---:|---:|---:|---:|---:|---:|
| `insert_same_key` | 1 | 1 | 3 | 3 | 3 | 0 |
| `file_fdw_options` | 1 | 2 | 2 | 2 | 2 | 0 |

两个 profile 的所有单元均为 `oracle_calibration_pending`，不是 `runtime_verified`。
file_fdw 的本地资产仍未部署，远端 validator、路径独占、权限和读取结果均待独立证据。

## 跨章依赖同步

新增 file_fdw 场景实际引用：

- `copy::copy_fact_body_384`
- `create_database::create_database_fact_compatibility_environment`

因此 `tests/data/cross_chapter_batch.json` 将 COPY 纳入 21 章依赖闭包，
并显式记录：

- file_fdw 场景对 COPY 文件布局事实的依赖；
- file_fdw manifest 对 CREATE DATABASE 物理模式门槛的依赖；
- COPY fixture 对 CREATE SCHEMA 的 fixture closure；
- COPY 自身的 CREATE MASKING POLICY supplemental source。

这不是自动发现依赖，而是把已经存在于正式规格中的引用纳入审计闭包。

## 静态审计结果

| 检查 | 结果 |
|---|---|
| Factor package | 317 |
| Manifest | 846 |
| 候选 SQL | 5,295 |
| Scenario | 902 |
| Source extraction complete | 317 / 317 |
| Generation model complete | 255 / 317 |
| Static coverage complete | 46 / 317 |
| Behavior coverage complete | 0 / 317 |
| 渲染写合同 | checked 334 / needs_review 20 / rejected 26 / not_applicable 4,915 |
| 正向 rejected | 0 |
| 公共类型证据 | 15 条 checked_types；4 条 INSERT 仍为 finite write needs_review |
| 兼容事实库存 | 67 YAML / 885 records / 885 qualified IDs / 8 组裸 ID 重名 / 869 条待模式复核 |

正式回执：

- `work/insert_key_20260916/rendered_sql_contracts.json`
- `work/insert_key_20260916/common_type_evidence.json`
- `work/insert_key_20260916/compat_fact_inventory.json`
- `work/insert_key_20260916/insert_same_key_preparation.json`
- `work/insert_key_20260916/file_fdw_options_preparation.json`

## 全量静态回归

最终冻结输入上的 8 分片静态回归全部通过：

| 指标 | 数值 |
|---|---:|
| 测试模块 | 270 |
| 测试数 | 1,982 |
| 分片 | 8 |
| 输入文件 | 9,739 |
| 分片前/后/当前输入一致性 | 是 |
| 模块覆盖 | 270 / 270 |
| 重复模块分配 | 0 |
| skipped / expected failure | 0 |
| 数据库执行 | 否 |

机器回执：

`work/insert_key_20260916/static_final2/result.json`

各分片测试数：

48、311、314、247、276、291、257、238。

说明：日志中出现的字符串 `skipped` 只是一个测试名
“invalid YAML cannot be silently skipped”；所有 unittest summary 均为 `OK`，
没有 skipped 或 expected-failure 结果。

## 保留边界

- 静态测试和离线准备不证明数据库行为。
- `finite_contract_evidence.runtime_proven=false`。
- file 资产 `deployed=false`，未发生文件传输。
- file_fdw validator、远端路径权限、对象所有权和读取 Oracle 均未校准。
- INSERT 同键赋回不证明任意键值变更、多唯一索引或多行输入。
- 本轮没有 Git commit、push 或数据库授权。

## 2026-09-17 runtime pilot dry run

新增 `scripts/execute_prepared_batch.py`。当前版本只支持
`insert_same_key`，且没有数据库执行参数或 execute flag。

它读取已冻结的 offline preparation，重新执行：

- 3 个 unit / 3 个 case 的绑定身份；
- `same_inline_integer_key_tuple_v1` finite contract；
- setup / target / Oracle / teardown 生命周期；
- planned rows 与 Oracle SQL identity；
- ownership 与 runtime proof 边界。

输出是 dry-run plan，不是执行回执：

```bash
python3 scripts/execute_prepared_batch.py \
  --input work/insert_key_20260916/insert_same_key_preparation.json \
  --output work/runtime_pilot_20260917/insert_same_key_dry_run_final.json
```

当前结果：

- ready units：3 / 3
- planned target steps：3
- planned oracles：3
- blocked units：0
- database_executed：false
- execution_authorized：false
- runtime_verified：0

每个 unit 的执行顺序固定为：

```text
environment_check
setup
setup
target
oracle
teardown
```

该脚本不打开连接、不执行 SQL、不部署文件，也不接受任意 SQL 输入。
真实执行入口必须另行显式授权并补充连接与环境校验。
