# SQL Reference Wave 8-79 Extraction V1

## 目标

抽取 D 族第三批：`DROP FUNCTION`、`DROP GLOBAL CONFIGURATION`、`DROP GROUP`、`DROP INDEX`、`DROP LANGUAGE`、`DROP LLM`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.17` | 2 | DROP FUNCTION |
| `1.13.10.18` | 2 | DROP GLOBAL CONFIGURATION |
| `1.13.10.19` | 1 | DROP GROUP |
| `1.13.10.20` | 2 | DROP INDEX |
| `1.13.10.21` | 1 | DROP LANGUAGE |
| `1.13.10.22` | 2 | DROP LLM |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- DROP FUNCTION权限（所有者/DROP权限/初始用户函数边界）、临时表限制、重载需参数列表
- IF EXISTS/CASCADE/RESTRICT与argmode/argname/argtype
- 省略参数列表与重载删除行为基线
- DROP GLOBAL CONFIGURATION仅初始用户、weak_password/undostoragetype保留名、不存在报错
- DROP GROUP与DROP ROLE同义、管理工具封装接口不建议直接使用
- DROP INDEX权限（模式所有者/INDEX权限/DROP ANY INDEX）、全局临时表跨会话限制
- CONCURRENTLY完整约束（单索引、禁CASCADE、事务禁止、临时表阻塞式、锁超时/死锁、残留清理、耗时特征）
- 在线创建+在线删除行为基线
- DROP LANGUAGE当前形态暂不支持
- DROP LLM sysadmin权限、M库排除、63字节命名规则与自动截断

## Open questions

| ID | 内容 |
|---|---|
| `drop_index_wave8_79_oq_runtime` | DROP FUNCTION重载与临时表限制、DROP INDEX CONCURRENTLY失败清理、全局配置删除和大模型服务删除在真实权限、并发DDL和依赖对象组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_79_v1.yaml
generated/core_sql_reference_wave8_79_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_79.py
python scripts/build_core_sql_reference_wave8_79.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_79.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP语句。
