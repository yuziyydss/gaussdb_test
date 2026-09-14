# 结构化Facts接入现有包的条件值判定 — 实施计划

## 目标

将795条结构化facts从"参考文档"变为"可被因子包消费的决策依据"，
用于解锁conditional值、改进预期结果、补充环境门。

## 当前25条Value Gaps的接入方案

### 可通过facts直接改善的（7条）

| 包/值 | 需要的facts | 已有facts | 接入方式 |
|---|---|---|---|
| create_foreign_table.format × 5 | format→OPTIONS语法接线 | create_foreign_table_fact_format | 需修改syntax.yaml添加format slot |
| insert.tuple_update | 更新冲突键的专属facet | insert_on_conflict的语义分析 | 需创建新facet值 |
| create_foreign_table.if_not_exists_yes | IF NOT EXISTS fresh值 | 已有log_fresh模式 | 可直接复制drop_foreign_table模式 |

### 可通过facts改善环境门的（10条）

| 包/值 | 已有facts | 改善方式 |
|---|---|---|
| alter_table.tde_rotation | tde_storage | 可用TDE参数facts作为环境门 |
| alter_table.tde | tde_storage | 同上 |
| create_index.tde | tde_storage | 同上 |
| alter_table.ilm | ilm相关 | 可用ILM facts作为环境门 |
| alter_table.colview | colview相关 | 可用视图兼容facts作为环境门 |
| drop_foreign_table.cascade | 依赖语义 | 可用系统表依赖facts |
| update/delete WHERE CURRENT OF × 2 | sp_where_current_of × 16条约束 | 存储过程包装测试方案 |

### 保持阻断的（8条）

| 包/值 | 阻断原因 | 已有证据 |
|---|---|---|
| resource_pool dop_one × 2 | 文档冲突 | PG_RESOURCE_POOL facts |
| alter_package COMPILE × 4 | 文档冲突 | alter_package_fact_support_conflict |
| alter_table.partition_set_tablespace | 需第二表空间 | 分区表facts |

## 实施步骤

### Step 1: 改善环境门（最简单）

将已有facts作为manifest的environment_requirements引用：

```yaml
# 示例：alter_table TDE rotation
environment_requirements:
  - key: tde_enabled
    allowed_values: ["true"]
    fact_refs:
      - "alter_table.tde_storage"  # 引用结构化facts
```

### Step 2: 添加format语法接线（中等）

修改create_foreign_table.syntax.yaml，在OPTIONS内添加format参数：

```yaml
# 当前
production: "CREATE FOREIGN TABLE {if_not_exists} {table_name} ({column_definitions}) SERVER {server_name} OPTIONS ({table_options})"

# 修改后——format通过table_options传递
# 在factor.yaml的table_options维度添加format值
# 新值: create_foreign_table_options_format_text/csv/binary/fixed
```

### Step 3: WHERE CURRENT OF存储过程包装（较复杂）

设计一个包含存储过程的测试方案：

```sql
CREATE OR REPLACE PROCEDURE test_update_where_current_of()
AS
  CURSOR c1 IS SELECT id FROM test_table FOR UPDATE;
  v_id INT;
BEGIN
  OPEN c1;
  FETCH c1 INTO v_id;
  UPDATE test_table SET value = 'updated' WHERE CURRENT OF c1;
  CLOSE c1;
END;
/
```

需要：
1. 新fixture（建表+数据+游标）
2. 新manifest（引用存储过程）
3. 新scenario（预期行为）
4. 16条WHERE CURRENT OF约束作为环境门

## 预计工作量

| 步骤 | 难度 | 时间 |
|---|---|---|
| Step 1: 环境门改善 | 低 | 2小时 |
| Step 2: format接线 | 中 | 4小时 |
| Step 3: WHERE CURRENT OF | 高 | 8小时 |
| **合计** | | **~14小时** |
