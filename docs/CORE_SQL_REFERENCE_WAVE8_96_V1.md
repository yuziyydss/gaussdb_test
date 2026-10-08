# SQL Reference Wave 8-96 Extraction V1

## 目标

抽取 A/B 族第三批：`ALTER GLOBAL CONFIGURATION`、`ALTER GROUP`、`ALTER LANGUAGE`、`ALTER MASKING POLICY` 与 `ALTER MATERIALIZED VIEW`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.15` | 2 | ALTER GLOBAL CONFIGURATION |
| `1.13.7.16` | 2 | ALTER GROUP |
| `1.13.7.18` | 1 | ALTER LANGUAGE |
| `1.13.7.19` | 5 | ALTER MASKING POLICY |
| `1.13.7.20` | 3 | ALTER MATERIALIZED VIEW |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- ALTER GLOBAL CONFIGURATION新增/修改gs_global_config键值、仅初始用户、weak_password/undostoragetype保留名限制
- redis_is_ok插入/修改/DROP删除行为基线
- ALTER GROUP非SQL标准定位、ADD/DROP USER与GRANT/REVOKE等价、RENAME等效ALTER ROLE
- pg_group/gs_roles查询行为基线、63字节大写命名规则
- ALTER LANGUAGE当前形态暂不支持
- ALTER MASKING POLICY五种修改形式（COMMENTS/ADD/REMOVE/MODIFY/DROP FILTER/ENABLE DISABLE）
- poladmin/sysadmin/初始用户权限与enable_security_policy前提
- 八类预置脱敏方式与自定义函数、maskall不支持\df
- COMMENTS/ADD/REMOVE/MODIFY/FILTER/DISABLE六类行为基线（GS_MASKING_POLICY polenabled验证）
- ALTER MATERIALIZED VIEW仅辅助属性、不支持改结构、所有者/系统管理员权限
- OWNER TO/RENAME COLUMN/RENAME TO三形式与\dm、\d _RETURN规则基线

## Open questions

| ID | 内容 |
|---|---|
| `alter_agc_grp_amp_amv_wave8_96_oq_runtime` | gs_global_config自定义key-value在集群内的同步行为、用户组权限等价的GRANT/REVOKE映射、脱敏策略ADD/REMOVE/MODIFY与过滤条件组合的真实脱敏输出、物化视图重命名后依赖对象引用在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_96_v1.yaml
generated/core_sql_reference_wave8_96_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_96.py
python scripts/build_core_sql_reference_wave8_96.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_96.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行全局配置/用户组/脱敏策略/物化视图语句。
