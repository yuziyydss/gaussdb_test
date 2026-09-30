# Advanced Package Candidate Matrix V1

## 目标

`core.advanced_package_candidate.py` 把 22 个 GaussDB 支持的 `DBE_*` 高级包全部纳入候选矩阵，用来回答：

- 哪些包已经建模？
- 哪些包已有 facts 可以进入下一批建模？
- 哪些包还需要补抽取？
- 各包的 syntax / behavior oracle / environment fact 数量是多少？

它不生成接口签名，不修改 `specs/`，也不宣称这些 facts 可以直接执行。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 支持的 `DBE_*` 包 | 22 |
| Pilot V1 已建模 | 22 |
| 未建模包 | 0 |
| Near term 候选 | 0 |
| Later batch | 0 |
| Needs extraction | 0 |
| 相关 facts | 294 |
| Syntax facts | 260 |
| Behavior oracle facts | 20 |
| Environment facts | 7 |

## 分层规则

| Tier | 条件 |
|---|---|
| `modeled_pilot` | 已进入 Advanced Package Pilot V1 / Expansion V1 |
| `near_term_candidate` | 未建模，且 facts >= 8 |
| `later_batch` | 未建模，且有 facts 但少于 8 |
| `needs_extraction` | 当前没有匹配 facts |

## 未建模候选

当前没有未建模 `DBE_*` 支持包。新增的 `DBE_COMPRESSION`、`DBE_DESCRIBE`、`DBE_HEAT_MAP`、`DBE_ILM`、`DBE_ILM_ADMIN`、`DBE_STATS`、`DBE_XMLDOM` 与 `DBE_XMLPARSER` 均为 manual review 接口合同；其中 `DBE_XMLDOM` 是核心类型/节点首批，`DBE_STATS` 是核心锁定、恢复、清理与统计表接口子集。

## 命令

```bash
python scripts/build_advanced_package_candidate_matrix.py
```

输出：

```text
generated/advanced_package_pilot/candidate_matrix.json
```

## 边界

- Candidate Matrix 不生成接口签名。
- 不生成 runtime SQL。
- 不证明 facts 已覆盖完整文档章节。
- 不证明任何高级包行为验证通过。
