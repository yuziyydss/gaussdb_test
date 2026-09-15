# GaussDB 验证错误诊断手册

> 弱LLM使用方法：找到错误码 → 按步骤操作 → 不需要分析，按表执行

## 快速查找

### 连接类

| 错误信息 | 原因 | 操作 |
|---|---|---|
| Connection refused | 端口未开放 | 1.确认服务已启动 2.检查防火墙 3.确认端口号 |
| Connection timeout | 网络不可达 | 1.ping目标 2.检查VPN 3.确认IP地址 |
| Authentication failed | 密码/用户错 | 1.确认用户名 2.重输密码 3.检查pg_hba.conf |
| Database does not exist | 库名错 | 1.列出数据库: gsql -l 2.确认库名 |

### 权限类

| 错误码 | 含义 | 操作 |
|---|---|---|
| 42501 | 权限不足 | 1.SELECT current_user; 2.确认是DB管理员 3.联系DBA授权 |
| 28000 | 连接被拒 | 1.检查pg_hba.conf 2.确认IP白名单 |

### 语法类

| 错误码 | 含义 | 操作 |
|---|---|---|
| 42601 | SQL语法错 | 1.检查SQL拼写 2.确认M模式 3.查兼容性facts |
| 42703 | 列不存在 | 1.DESC table_name; 2.检查列名拼写 |
| 42P01 | 表不存在 | 1.确认表已创建 2.检查schema前缀 |
| 42704 | 类型不存在 | 1.确认数据类型 2.检查兼容模式 |

### 兼容性差异类

| 现象 | 根因 | facts位置 |
|---|---|---|
| SELECT TRUE返回t/f而非1/0 | M模式已知差异 | mysql_m_datatypes_complete.yaml |
| NULL显示空值而非NULL文本 | M模式已知差异 | mysql_m_operators_complete.yaml |
| ADD_MONTHS月末计算不同 | behavior_compat_options | runtime_params_behavior_compat_examples.yaml |
| ORDER BY NULL在最后 | M模式已知差异 | mysql_m_operators_complete.yaml |
| LPAD最大长度不同 | 1048576 vs 1398101 | mysql_m_system_functions_complete.yaml |
| BINARY填充符不同 | 0x20 vs 0x00 | mysql_m_datatypes_complete.yaml |
| ROUND精度不一致 | float类型精度损失 | oracle_sysfunc_detailed.yaml |
| GROUP_CONCAT排序不稳定 | DISTINCT+ORDER BY差异 | mysql_m_sysfunc_detailed.yaml |

### 运行时类

| 错误码 | 含义 | 操作 |
|---|---|---|
| 22012 | 除零 | SELECT 1/0; 确认除数非零 |
| 22003 | 数值溢出 | 检查INT范围(2147483647) |
| 23505 | 唯一约束冲突 | 先DELETE旧数据或用不同ID |
| 23503 | 外键约束冲突 | 先INSERT父表数据 |
| 23514 | CHECK约束冲突 | 检查值范围 |
| 42501 | 表权限不足 | GRANT或在正确schema操作 |

## 标准操作流程

### 验证脚本报错时

```
1. 打开 validation_report_*.txt
2. 找到 [FAIL] 的测试
3. 查看Error列
4. 在上面表格中查找错误码
5. 按操作列执行
6. 重新运行验证脚本
```

### 需要更多信息时

```sql
-- 查看数据库信息
SELECT version();
SHOW sql_compatibility;
SHOW behavior_compat_options;

-- 查看表结构
\dt v_test.*
\d v_test.t1

-- 查看当前用户权限
SELECT current_user, session_user;
SELECT has_database_privilege(current_user, current_database(), 'CREATE');
```

## 已知的25条Value Gaps

| 包 | 数量 | 原因 | 状态 |
|---|---|---|---|
| alter_table | 8 | TDE/ILM/COLVIEW环境 | 阻断 |
| create_foreign_table | 5 | file_fdw场景 | 阻断 |
| alter_package | 4 | COMPILE文档冲突 | 阻断 |
| create_index | 2 | TDE/active_pages | 阻断 |
| alter+create_resource_pool | 2 | MAX_DOP冲突 | 阻断 |
| delete+update | 2 | WHERE CURRENT OF | 阻断 |
| insert | 1 | tuple_update语义 | 阻断 |
| drop_foreign_table | 1 | CASCADE依赖 | 阻断 |
