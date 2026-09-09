# M 兼容环境准备与执行边界

本次只补齐**可生成、可检查的环境准备流程**。未连接数据库、未创建任何数据库/schema、未执行测试。M 专用执行器仍待授权后的校准，不是已交付实机闭环。

## 两种 CREATE DATABASE 不能混淆

| 所在连接 | 语句 | 含义 |
|---|---|---|
| 非 M 管理数据库 | `CREATE DATABASE m_factor_test DBCOMPATIBILITY = 'M';` | 创建物理 M 数据库 |
| 已连接 M 数据库 | `CREATE DATABASE m_case_schema;` | 创建 schema，与 CREATE SCHEMA 同义 |
| 已连接 M 数据库 | `USE m_case_schema;` | 切换当前 schema，不是切换物理数据库 |

依据本地 PDF：1.13.9.16 CREATE DATABASE、2.4.2.8.7 CREATE DATABASE、2.4.2.18.2 USE、5.3 gsql。源码正文和 PDF 哈希写入生成的 `plan.json`。不默认指定 `templatem`：原文对其可用性有额外条件。角色权限、M 特性开通和版本仍需目标环境核验。

## 生成准备文件（不执行）

在项目根目录运行：

```bash
GAUSSDB_ENABLED=false python3 scripts/prepare_m_compat_environment.py \
  --management-database postgres \
  --database m_factor_test \
  --namespace m_factor_run
```

产物位于 `generated/m_compat_environment/`：

1. `00_create_database.gsql`：可选的新建路径；要求非 M 管理连接、CREATEDB 权限、事务外执行。显式打开 AUTOCOMMIT，已有同名库时报错，不覆盖。
2. `01_connect_verify.gsql`：通过 gsql 的 `\connect` 重新连接；从 `pg_database` 回读当前物理库与 `datcompatibility`。复用已获批准的 M 库时跳过第 1 步，但不能跳过此步。
3. `02_namespace.gsql`：重新核验 M，再创建新测试 schema、`USE`、检查 `database()`。原文说明 USE 缺少 USAGE 权限时可能不报错，因此必须回读。
4. `plan.json`：明确连接边界、新建/复用分支、失败处置、来源及文件哈希。

这里的 `.gsql` 包含客户端命令，**不能作为 psycopg2 的 SQL 字符串执行**。如将来获准执行，应在新开的 gsql 会话中按计划分阶段运行；不使用单事务选项包住物理建库。文件本身不会自动执行后续测试。

环境准备脚本的数据库/schema 名使用 `m_factor_` 前缀；每轮 namespace 必须是未被使用过的新名字。因子内另有 `m_…` 测试对象，其所有权仍须由未来的 case 运行时确认。没有自动 DROP DATABASE、DROP OWNED 或 CASCADE 清理文件，也不会把管理库密码写入产物。

## 测试 SQL 如何使用这个前置条件

所有要求 M 的 SQL 快照头部都引用本计划。环境只准备一次，不向每条 fixture 塞建库语句。逐 case 使用同一连接完成 setup → target → Oracle → teardown；事务和保存点绝不能在不同连接执行。

`generated/factor_packages/m_*/` 是**供校对的 SQL 快照**，不是可以直接整文件执行的测试程序：它们包含多个独立生命周期及负向用例。命名空间命令还会创建/切换 schema，不能仅靠通用 `search_path` 隔离。

当前 Legacy Executor 使用通用模式 sandbox/CASCADE 清理，尚未验证 M 的清理语义。因此单条 M 执行和包含 M 的混合批次均在连接/写入前返回 `skip`，原因 `m_staged_execution_not_calibrated`。这不是“不支持 M”，也不是负向通过；生成和静态审计仍正常。

## 下一阶段运行时验收

获得数据库执行授权后再实现/校准：真实模式预检、每轮/每 case 对象所有权台账、事务会话保持、失败后的精准清理，以及目标错误/结果集 Oracle。环境失败不能算目标错误；setup 失败不能继续 target，也不能盲目删除可能属于别人的对象。不得用本次静态通过宣称这些运行时能力完成。
