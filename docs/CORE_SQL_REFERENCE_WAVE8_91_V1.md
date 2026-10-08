# SQL Reference Wave 8-91 Extraction V1

## 目标

抽取 C 族第九批：`CREATE ROW LEVEL SECURITY POLICY`、`CREATE RULE` 与 `CREATE SECURITY LABEL`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.41` | 5 | CREATE ROW LEVEL SECURITY POLICY |
| `1.13.9.42` | 3 | CREATE RULE |
| `1.13.9.44` | 2 | CREATE SECURITY LABEL |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CREATE ROW LEVEL SECURITY POLICY语法（AS PERMISSIVE/RESTRICTIVE + FOR ALL/SELECT/UPDATE/DELETE + TO + USING）
- 表支持范围（行存/行存分区/unlogged/hash）与外表/本地临时表/视图限制、单表100个上限
- 系统管理员豁免、enable row level security开关前提、仅影响读取不影响INSERT/MERGE INTO
- USING表达式true/false/null可见性语义、查询重写阶段拼接、策略名表内唯一
- PERMISSIVE OR拼接与RESTRICTIVE AND拼接公式、FOR各命令适配SQL关系（表1-378）
- TO子句PUBLIC默认与role_name/CURRENT_USER/SESSION_USER语义
- USING表达式禁用agg/窗口函数
- all_data_rls管理员/alice双用户SELECT、EXPLAIN Filter与INSERT权限报错行为基线
- CREATE RULE语法（event四类 + DO ALSO/INSTEAD/NOTHING + command列表）
- 表拥有者权限与同类型规则按名称字母序触发
- 视图规则RETURNING子句限制（无条件INSTEAD、单事件最多一个、缺失时拒绝查询）
- ON SELECT规则必须为无条件INSTEAD、规则名必须_RETURN、空表转视图限制
- condition禁止引用其他表/聚集函数、INT隐式转布尔风险、ALSO默认语义
- rule_test DO ALSO INSERT跨表同步行为基线
- CREATE SECURITY LABEL语法与初始用户/SYSADMIN/gs_role_seclabel权限
- label_name 63字节唯一命名规则
- label_content等级:范围结构、L1~L1024偏序、G1~G1024集合运算与区间语法
- L/G大写、首位非零、yyy≥xxx格式校验与'L3:'报错样例
- gs_security_label查询与同名重复创建报错行为基线

## Open questions

| ID | 内容 |
|---|---|
| `create_rls_rule_seclabel_wave8_91_oq_runtime` | 行访问控制PERMISSIVE/RESTRICTIVE组合拼接的执行计划行为、多类型规则字母序触发、RETURNING子句在视图上的实际输出、安全标签等级偏序与范围集合运算在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_91_v1.yaml
generated/core_sql_reference_wave8_91_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_91.py
python scripts/build_core_sql_reference_wave8_91.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_91.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行行级安全/规则/安全标签语句。
