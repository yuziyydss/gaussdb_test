# Core PL/SQL Runtime and Recompile Wave 6-2 Extraction V1

## 目标

细抽并一次性完成5个PL/SQL运行相关章节：

```text
1.6.45 Global Plsql Cache特性函数
1.6.46 存储过程字节码特性函数
1.6.47 数据透视函数
1.6.48 通用标识符函数
1.6.59 失效重编译函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 5 |
| 物理页并集 | 980–991与1056–1058，共15页 |
| 结构化 facts | 25 |
| Open questions | 2 |
| Source resolved | 5 / 5 |
| Facts bound to scope | 25 / 25 |

## 覆盖内容

### Global PL/SQL Cache

- `invalidate_plsql_object`
- `gs_plsql_memory_object_detail`
- `dump_plsql_compiled_object`

关键边界：

- `invalidate_plsql_object`仅在`enable_global_plsqlcache=on`时可用，需`SYSADMIN`权限。
- 无入参失效当前DATABASE所有全局缓存对象；三入参可失效指定package/function。
- `objtype=package`表示包；`objtype=function`表示函数或存储过程。
- 失效结果可通过`gs_glc_memory_detail`中valid状态行消失观察。
- `gs_plsql_memory_object_detail`的`obj_type`支持`all`、`pkg`、`func`和`func_in_pkg`。
- `dump_plsql_compiled_object`中function与procedure查询效果等价。

### 存储过程字节码

- `dump_plsql_bytecode`

关键边界：

- 仅限用户管理员查询。
- 全局缓存开启时pid、sessionid和global_sessionid为NULL，编译产物全局共享。
- 全局缓存关闭时编译产物为每个会话独有。
- 不支持的字节码显示`Not supported`；尚未创建显示`To be created`。

### 数据透视

- `tablefunc`
- `crosstab(source_sql[,N])`
- `crosstab2 / crosstab3 / crosstab4`
- `crosstab(source_sql,category_sql)`

关键边界：

- `tablefunc`为扩展接口，仅系统管理员可安装扩展。
- `crosstab`中的`N`是无效参数，不影响结果。
- `crosstabN`生成N+1列透视表。

### 通用标识符

- `sys_guid`
- `uuid`
- `uuid_short`

关键边界：

- `sys_guid`为16字节raw标识符。
- `uuid`符合RFC 4122，共32个十六进制数字表示128位。
- `uuid_short`唯一性要求节点数不超过256、节点重启间不修改系统时间、平均调用少于1600万次/秒。
- 从505.0.0之前版本升级且升级未提交时不能使用`uuid_short`。

### 失效重编译

- `transform_view_dep_source`
- `gs_compile_schema`

关键边界：

- `transform_view_dep_source`仅管理员可用。
- `gs_compile_schema`可重编译包、函数、存储过程和视图。
- `compile_all=false`只编译失效对象；true编译全部对象。
- `retry_times`默认10，表示失败后重试次数。
- 该函数支持所有兼容模式，推荐替代`PKG_UTIL.GS_COMPILE_SCHEMA`。

## Open questions

| ID | 内容 |
|---|---|
| `plsql_wave6_2_oq_cache_dump_matrix` | PL/SQL缓存失效、内存明细、编译产物dump和字节码在不同开关、跨session和对象类型下的输出矩阵 |
| `plsql_wave6_2_oq_crosstab_recompile_evidence` | crosstab数据边界以及视图依赖刷新/schema重编译在依赖变更、失败重试和兼容模式下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_plsql_wave6_2_v1.yaml
generated/core_plsql_wave6_2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_plsql_wave6_2.py
python scripts/build_core_plsql_wave6_2.py --check
python -m pytest -q tests/test_core_plsql_wave6_2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不失效PL/SQL缓存、不dump编译产物、不安装扩展、不生成UUID、不刷新视图依赖、不重编译Schema。
- 不宣称目标环境行为验证通过。
