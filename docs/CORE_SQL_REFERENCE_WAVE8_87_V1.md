# SQL Reference Wave 8-87 Extraction V1

## 目标

抽取 C 族第五批：`CREATE DATABASE LINK`、`CREATE DIRECTORY`、`CREATE EVENT` 与 `CREATE EXTENSION`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.17` | 5 | CREATE DATABASE LINK |
| `1.13.9.18` | 2 | CREATE DIRECTORY |
| `1.13.9.19` | 4 | CREATE EVENT |
| `1.13.9.20` | 2 | CREATE EXTENSION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- CREATE DATABASE LINK语法（PUBLIC/CURRENT_USER/OCI）、A模式限制与初始用户禁令
- GaussDB options（host/port/dbname/fetch_size）与Oracle options九项（含case_insensitive大小写规则）
- SSL连接四步配置（sqlnet.ora/tnsnames.ora/TNS名/重启）
- 四类DBLink创建删除行为基线
- CREATE DIRECTORY用途与dbe_file、安全须知（关键目录风险/最小权限/审计）、开关权限矩阵
- 路径校验（特殊字符/相对路径禁止、omm R/W/X、节点一致性）、pg_directory行为基线
- CREATE EVENT语法、B模式与赋权、浮点间隔取整、同名限制
- 待执行语句安全边界与definer指定失败场景、失败原因查看
- AT/EVERY+STARTS/ENDS调度、interval单位与B模式5.7 s1下划线写法
- ON COMPLETION/ENABLE/DISABLE/COMMENT/DEFINER
- 一次性与周期任务行为基线
- CREATE EXTENSION内部定位、支持文件与同名对象检查、enable_extension开关
- SCHEMA/VERSION/FROM old_version语义与security_plugin基线

## Open questions

| ID | 内容 |
|---|---|
| `create_dbl_wave8_87_oq_runtime` | DATABASE LINK（GaussDB/Oracle/SSL）连接、目录对象安全校验、定时任务调度执行和扩展安装升级在真实网络、权限与兼容模式组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_87_v1.yaml
generated/core_sql_reference_wave8_87_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_87.py
python scripts/build_core_sql_reference_wave8_87.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_87.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DBLink/目录/定时任务/扩展语句。
