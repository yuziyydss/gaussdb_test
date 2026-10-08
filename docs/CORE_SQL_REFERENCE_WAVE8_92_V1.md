# SQL Reference Wave 8-92 Extraction V1

## 目标

抽取 C 族第十批：`CREATE AUDIT POLICY` 与 `CREATE TABLE PARTITION | SUBPARTITION AS`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.11` | 4 | CREATE AUDIT POLICY |
| `1.13.9.51` | 7 | CREATE TABLE PARTITION \| SUBPARTITION AS |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- CREATE AUDIT POLICY语法（PRIVILEGES/ACCESS子句 + ON LABEL + FILTER ON + ENABLE/DISABLE）
- POLADMIN/SYSADMIN/初始用户权限、enable_security_policy前提、GS_AUDITING_POLICY*四系统表查询
- 策略名63字节唯一命名规则与IF NOT EXISTS防重复
- PRIVILEGES九类操作（ANALYZE联动VACUUM审计）与ACCESS十类操作、ALL语义、默认ENABLE
- FILTER三类型APP/ROLES/IP
- adt1基础策略/adt2按标签+角色过滤/adt3用户+客户端+IP组合过滤行为基线
- DATABASE LINK场景发送方属性为服务端的说明
- CREATE TABLE PARTITION|SUBPARTITION AS一级/二级分区表语法与AS query填充
- IF NOT EXISTS NOTICE/ERROR行为、ENGINE仅语法适配、column_name覆盖语义
- 透明加密参数enable_tde/encrypt_algo/dek_cipher/key_type/cmk_id
- FILLFACTOR 10~100（Ustore 92/Astore 100）与ORIENTATION ROW默认
- autovacuum系列参数取值与Astore生效范围、freeze阈值与强制VACUUM
- ILM ADVANCED高级压缩（不支持hour、默认MEDIUM）与TURBO跨页透明压缩（支持hour）、NONE
- ILM ON(EXPR)行级表达式与兼容性参数影响（upper在B模式5.7失效）
- TABLESPACE/AS query/WITH [NO] DATA语义
- t1_part_dup一级3分区按PARTITION(pN)查询与二级填充行为基线

## Open questions

| ID | 内容 |
|---|---|
| `create_audit_ctpas_wave8_92_oq_runtime` | 统一审计策略在PRIVILEGES/ACCESS与APP/ROLES/IP组合过滤下的实际审计日志记录行为、ILM高级压缩与跨页透明压缩在真实负载下的压缩率及性能影响、CREATE TABLE PARTITION AS透明加密与分区填充组合在授权环境下的完整行为矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_92_v1.yaml
generated/core_sql_reference_wave8_92_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_92.py
python scripts/build_core_sql_reference_wave8_92.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_92.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行审计策略/分区表语句。
