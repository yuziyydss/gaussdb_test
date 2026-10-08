# SQL Reference Wave 8-58 Extraction V1

## 目标

合并抽取 `CREATE/ALTER/DROP USER MAPPING`，完成用户映射创建、OPTIONS维护、加密密钥文件和删除生命周期闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.59` | 2 | CREATE USER MAPPING |
| `1.13.7.45` | 2 | ALTER USER MAPPING |
| `1.13.10.48` | 2 | DROP USER MAPPING |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- 用户映射用于携带外部访问连接信息
- SERVER所有者和USAGE权限下的创建边界
- `user_name`、`USER`、`CURRENT_USER`、`PUBLIC`语义
- OPTIONS唯一约束和FDW验证
- `usermapping.key.cipher`、`usermapping.key.rand`与gs_guc/gs_ssh发布
- 敏感password字段多层引号脱敏边界
- ADD/SET/DROP选项维护
- `IF EXISTS`和目标用户/服务器定位

## Open questions

| ID | 内容 |
|---|---|
| `usermap_wave8_58_oq_runtime` | CREATE/ALTER/DROP USER MAPPING在真实FDW、加密密钥文件、PUBLIC映射、OPTIONS权限和跨节点发布组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_58_v1.yaml
generated/core_sql_reference_wave8_58_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_58.py
python scripts/build_core_sql_reference_wave8_58.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_58.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行用户映射DDL。
