# SQL Reference Wave 8-147 Extraction V1

## 目标

抽取 高级包第六批切片：`3.12.2.1 DBE_ALERT`（跨会话告警）与 `3.12.2.2 DBE_APPLICATION_INFO`（会话标注信息），3.12.2 二次封装接口开篇。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2715–2722，含两个完整小节） |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_ALERT：REGISTER（30字节/ORA$·GS$禁用/全库32上限）/REMOVE/REMOVEALL/SET_DEFAULTS（兼容占位）/SIGNAL（事务提交才发送、唤醒等待会话、message 1800字节）/WAITANY·WAITONE（timeout默认86400000秒、status 0/1、不受事务回滚影响）
- 名称规则：不区分大小写（回显大写基线）、ORA$/GS$禁用
- 跨会话示例基线（register→signal+commit→waitone/waitany→remove/removeall→视图0行）与DBE_ALERT_INFO视图列
- DBE_APPLICATION_INFO：作用范围当前session；SET/READ CLIENT_INFO、SET_MODULE（双参数）/READ_MODULE（双OUT）/SET_ACTION；64字节截断规则；示例基线
- 两包作用域对比（跨会话告警 vs 会话级标注、报错 vs 截断）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_147_oq_runtime` | DBE_ALERT跨节点（非主节点会话）调用报错形态、SIGNAL事务提交后WAITONE唤醒的延迟上界、REGISTER 32个上限在多会话并发注册下的计数口径需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_147_v1.yaml
generated/core_sql_reference_wave8_147_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_147.py
python scripts/build_core_sql_reference_wave8_147.py --check
python -m unittest tests.test_core_sql_reference_wave8_147 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不注册或发送告警。
