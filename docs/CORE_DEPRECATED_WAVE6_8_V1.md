# Core Deprecated Functions Wave 6-8 Extraction V1

## 目标

完成 `1.6.61 废弃函数` 的静态抽取，按函数族记录当前版本已废弃的接口清单。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 1114–1117，共4页 |
| 结构化 facts | 7 |
| Open questions | 1 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 7 / 7 |

## 覆盖内容

废弃函数按族群记录：

- 工作负载与资源统计函数
- pgxc / 分布式路由与连接函数
- 查询、容灾和复制函数
- 存储、内存、segment、COPY和context tracking函数
- OBS文件函数及杂项函数
- MOT、GTM、IMCU函数

关键边界：

- 本批只记录原文声明为当前版本废弃的函数清单。
- 不推断每个废弃函数的替代接口。
- 不推断删除时间、调用结果或迁移行为。
- 不将废弃等同于运行时报错。

## Open questions

| ID | 内容 |
|---|---|
| `deprecated_wave6_8_oq_replacement_matrix` | 各废弃函数的替代接口、迁移路径和调用错误/告警行为需结合目标版本与授权环境逐项验证 |

## 产物

```text
docs/compat_facts/core_deprecated_wave6_8_v1.yaml
generated/core_deprecated_wave6_8_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_deprecated_wave6_8.py
python scripts/build_core_deprecated_wave6_8.py --check
python -m pytest -q tests/test_core_deprecated_wave6_8.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不调用任何废弃函数。
- 不宣称目标环境行为验证通过。
