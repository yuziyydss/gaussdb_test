# SQL Reference Wave 8-76 Extraction V1

## 目标

抽取 `GENERATED UPDATE SYSTEM OBJECT` 升级回滚脚本生成与 IMPDP 族六个章节（DATABASE CREATE/RECOVER、PLUGGABLE DATABASE CREATE/RECOVER、TABLE、TABLE PREPARE）。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.13.1` | 1 | GENERATED UPDATE SYSTEM OBJECT |
| `1.13.14.1` | 1 | IMPDP DATABASE CREATE |
| `1.13.14.2` | 1 | IMPDP PLUGGABLE DATABASE CREATE |
| `1.13.14.3` | 2 | IMPDP PLUGGABLE DATABASE RECOVER |
| `1.13.14.4` | 2 | IMPDP RECOVER |
| `1.13.14.5` | 1 | IMPDP TABLE |
| `1.13.14.6` | 2 | IMPDP TABLE PREPARE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 7 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 7 / 7 |
| chapter has facts | 7 / 7 |

## 覆盖能力

- GENERATED UPDATE SYSTEM OBJECT：升级回滚脚本由OM调用、upgrade_mode/application_name双条件、仅初始用户
- IMPDP DATABASE CREATE准备阶段（新库名/SOURCE/OWNER/LOCAL原集群）
- IMPDP RECOVER执行阶段
- IMPDP PLUGGABLE CREATE执行阶段、RECOVER修复阶段
- IMPDP TABLE执行阶段与TABLE PREPARE准备阶段
- 细粒度备份恢复工具专用、直接调用报错/禁止（PDB CREATE可能异常重启）
- PDB修复阶段资源计划指令三步（pending_area/create_resource_plan_directive/submit）与OPEN后连入恢复
- behavior oracle：DATABASE CREATE/RECOVER、PDB CREATE/RECOVER、TABLE与TABLE PREPARE

## Open questions

| ID | 内容 |
|---|---|
| `impdp_wave8_76_oq_runtime` | GENERATED UPDATE SYSTEM OBJECT升级回滚流程与IMPDP族各阶段在真实备份恢复工具联动、资源规划和集群场景下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_76_v1.yaml
generated/core_sql_reference_wave8_76_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_76.py
python scripts/build_core_sql_reference_wave8_76.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_76.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行导入/升级语句。
