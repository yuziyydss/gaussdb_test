# Stored Procedure Wave 8-6 Extraction V1

## 目标

抽取 `3.13 Retry管理`、`3.14 调试` 与 `3.15 package`，补齐错误重试、异常输出和包封装能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `3.13` | 2 | Retry管理 |
| `3.14` | 4 | RAISE / EXCEPTION_INIT 调试 |
| `3.15` | 1 | package封装 |
| 合计 | **6** | **3章** |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 6 |
| 结构化 facts | 18 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- Retry的触发、决策和回滚/重执行
- `RAISE`五种语法形式
- DEBUG/LOG/INFO/NOTICE/WARNING/EXCEPTION级别
- `log_min_messages` / `client_min_messages`
- MESSAGE/DETAIL/HINT/ERRCODE
- 默认 `P0001`
- `EXCEPTION_INIT` 自定义SQLCODE及边界
- package定义、包头/包体可见性
- package类型、变量、cursor和参数签名限制

## Open questions

| ID | 内容 |
|---|---|
| `sp_wave8_6_oq_runtime` | Retry、RAISE级别和EXCEPTION_INIT自定义错误码的真实错误输出矩阵，以及PACKAGE边界行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_stored_procedure_wave8_6_v1.yaml
generated/core_stored_procedure_wave8_6_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_stored_procedure_wave8_6.py
python scripts/build_core_stored_procedure_wave8_6.py --check
python -m pytest -q tests/test_core_stored_procedure_wave8_6.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行Retry或RAISE。
