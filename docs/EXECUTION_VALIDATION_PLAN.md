# 实机验证执行方案

## 目标

验证"规格驱动SQL测试生成"链路的正确性：
**PDF原文 → 因子包 → manifest → 生成SQL → 执行 → 结果比对**

## 当前状态

- 候选SQL: 5,273条（全部静态生成，从未执行）
- 知识库: 795条结构化facts
- 实际执行: **0条**

## 最小验证方案（Phase 1: 10条SQL）

### 选择标准

1. 语法简单（单条CREATE/INSERT/SELECT）
2. 无外部依赖（不需要TDE/ILM/存储过程等）
3. 预期结果可静态判断（成功或已知错误）
4. 覆盖不同DML类型和模式

### 建议选取

| # | 类型 | 候选来源 | 验证目标 |
|---|---|---|---|
| 1 | CREATE TABLE | m_create_table | 基本建表语法 |
| 2 | INSERT | m_insert | 基本插入 |
| 3 | SELECT | m_select | 基本查询 |
| 4 | UPDATE | m_update | 基本更新 |
| 5 | DELETE | m_delete | 基本删除 |
| 6 | CREATE INDEX | m_create_index | 索引创建 |
| 7 | GRANT | m_grant | 权限授予 |
| 8 | BEGIN/COMMIT | m_begin/m_commit | 事务控制 |
| 9 | behavior_compat差异 | display_leading_zero | GUC行为验证 |
| 10 | behavior_compat差异 | end_month_calculate | 日期函数差异 |

### 执行步骤

```bash
# 1. 连接数据库
gsql -d testdb -p 5432

# 2. 创建独立测试schema
CREATE SCHEMA IF NOT EXISTS test_validation_phase1;

# 3. 逐条执行候选SQL
# 4. 记录实际结果（成功/失败/错误信息）
# 5. 与预期结果比对
# 6. 记录差异
```

### 验证通过标准

- 语法正确性: 10/10 SQL可执行（或按预期报错）
- Fixture正确性: 建表/清表生命周期有效
- 预期准确性: success/error判断与实际一致
- GUC差异: behavior_compat_options设置前后输出确实不同

## Phase 1 dry-run

当前可以先生成不连接数据库的 Phase 1 计划：

```bash
python scripts/auto_validate.py \
  --dry-run \
  --output generated/runtime_validation_pilot/phase1_dry_run.json
```

当前计划包含：

- 1 个 setup schema
- 10 个 target unit
- 1 个 owned cleanup schema
- `database_executed=false`
- `execution_authorized=false`
- `runtime_verified=0`

该文件只是执行计划，不是执行回执。

该文件只是执行计划，不是执行回执。

生成计划后，可以使用同一份计划执行 Phase 1：

```bash
python scripts/auto_validate.py \
  --plan generated/runtime_validation_pilot/phase1_dry_run.json \
  --host HOST \
  --port PORT \
  --db DATABASE \
  --user USER
```

`--plan` 会拒绝包含执行声明、runtime claim 或单元 ID 不匹配的文件。

## Phase 1 报告审计

Phase 1 执行后，使用独立审计器检查报告：

```bash
python scripts/audit_phase1_report.py \
  --report validation_report_TIMESTAMP.json \
  --output generated/runtime_validation_pilot/phase1_report_audit.json
```

审计器会检查：

- setup / 10 target / teardown 阶段顺序
- P1-001 至 P1-010 目标 ID
- setup 与 cleanup 是否通过
- BLOCKED 是否只出现在前置失败之后
- summary 中 passed / failed / blocked / executed 计数
- 12 条结果是否与报告一致

只有 setup、10 个 target 和 cleanup 全部通过时，才标记 `runtime_verified=true`。

## Phase 2: 100条（1个完整manifest）

如果Phase 1通过，扩展到完整manifest：

| manifest | 候选数 | 特点 |
|---|---|---|
| m_create_table普通正向 | ~18 | 全部CREATE TABLE变体 |
| m_insert VALUES正向 | ~22 | INSERT各种形式 |
| m_select基础正向 | ~23 | SELECT各种投影 |

## Phase 3: 跨包依赖验证

验证因子包之间的fixture依赖：
- CREATE TABLE → INSERT → SELECT → DELETE → DROP TABLE 完整生命周期

## 已知风险

| 风险 | 缓解措施 |
|---|---|
| 数据库版本不匹配 | 确认GaussDB版本与PDF版本一致 |
| 权限不足 | 使用初始用户或系统管理员 |
| 并发冲突 | 独立schema，串行执行 |
| 数据残留 | 每条用例前清理相关对象 |
| GUC干扰 | 记录执行前后的GUC状态 |

## 环境要求

- GaussDB实例（集中式，支持M-Compatibility模式）
- gsql客户端
- 初始用户或系统管理员权限
- 网络连通（如果远程连接）

## 前置检查清单

- [ ] 确认数据库版本（SELECT version()）
- [ ] 确认兼容模式（SHOW sql_compatibility）
- [ ] 确认当前GUC状态（SHOW behavior_compat_options）
- [ ] 确认当前m_format_behavior_compat_options
- [ ] 确认可用schema列表
- [ ] 确认磁盘空间

## 需要用户提供的

1. GaussDB连接信息（主机/端口/数据库名/用户名/密码）
2. 或本地gsql可直接连接的确认
3. 允许创建测试schema的权限确认
