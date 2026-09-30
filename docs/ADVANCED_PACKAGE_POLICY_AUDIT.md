# Advanced Package Expansion Coverage & Policy Audit V1

## 目标

`core.advanced_package_policy_audit.py` 对 22 包扩展后的 8 个新增包做两件事：

1. 对照显式 coverage manifest，静态检查文档接口覆盖缺口。
2. 复审新增包接口的执行策略，区分可进入 case 设计的只读/资源闭环接口与首批应 block 的高影响接口。

审计模块不生成 runtime SQL，不连接数据库，也不宣称实机行为验证通过。当前 inventory 已按审计结论把 38 个接口提升为 `runtime_candidate`，并登记 27 个 runtime case。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 审计包 | 8 |
| 文档 callable 接口 | 99 |
| 已建模 callable 接口 | 99 |
| 缺失 callable 接口 | 0 |
| 文档/已建模签名 | 126 / 126 |
| 文档/已建模类型 | 10 / 10 |
| 完整覆盖包 | 8 |
| 部分覆盖包 | 0 |

## 覆盖缺口

| Package | Scope | Documented | Modeled | Missing | 说明 |
|---|---|---:|---:|---:|---|
| `DBE_COMPRESSION` | complete | 6 | 6 | 0 | 六个接口已建模 |
| `DBE_DESCRIBE` | complete | 1 | 1 | 0 | 另有 2 个集合类型已建模 |
| `DBE_HEAT_MAP` | complete | 1 | 1 | 0 | `ROW_HEAT_MAP` 已建模 |
| `DBE_ILM` | complete | 2 | 2 | 0 | `EXECUTE_ILM` / `STOP_ILM` 已建模 |
| `DBE_ILM_ADMIN` | complete | 5 | 5 | 0 | 五个接口已建模 |
| `DBE_STATS` | complete | 36 | 36 | 0 | `ALTER_STATS_HISTORY_RETENTION`仅为交叉提及，无独立原型，不计入 |
| `DBE_XMLDOM` | complete | 41 | 41 | 0 | 68个文档签名全部建模；额外27个overload已闭合 |
| `DBE_XMLPARSER` | complete | 7 | 7 | 0 | `PARSER` 类型与七个接口已建模 |

## 执行策略复审

当前 inventory 中 38 个接口已按审计结论提升为 `runtime_candidate`；其中 22 个是文档本地 XMLDOM overload。其余 98 个新增接口策略如下：

| Review decision | 数量 | 推荐策略 | 含义 |
|---|---:|---|---|
| `static_type_only` | 10 | `static_probe` | 类型/集合身份可静态核对 |
| `promote_after_case_design` | 38 | `runtime_candidate` | 生命周期/只读 case 已登记，实机验证仍缺失 |
| `keep_manual_review` | 82 | `manual_review` | 需要专用 fixture、权限或清理设计；含 5 个 XMLDOM overload |
| `block_for_runtime_pilot` | 6 | `blocked` | 首批授权 runtime batch 禁止执行 |

当前 38 个 `runtime_candidate` 接口分布在：

- `DBE_XMLDOM`：31 个 document-local 创建、遍历、读取、输出和释放接口（含 22 个 overload）
- `DBE_XMLPARSER`：5 个 parser 生命周期/读取接口
- `DBE_STATS`：2 个只读历史信息函数

推荐 block 的接口集中在：

- `DBE_ILM.EXECUTE_ILM`
- `DBE_ILM_ADMIN.CUSTOMIZE_ILM`
- `DBE_ILM_ADMIN.DISABLE_ILM`
- `DBE_ILM_ADMIN.ENABLE_ILM`
- `DBE_ILM_ADMIN.CREATE_ILM_DB_POLICY`
- `DBE_ILM_ADMIN.DELETE_ILM_DB_POLICY`

## 数据输入

| 来源 | 作用 |
|---|---|
| `environments/advanced_packages_v1.yaml` | 当前接口合同与 `execution_policy` |
| `environments/advanced_package_expansion_coverage_v1.yaml` | 文档接口数、类型数与缺失接口清单 |
| `environments/advanced_package_policy_audit_v1.yaml` | 推荐 runtime/block/static 清单、原因与前置条件 |

## 输出

```text
generated/advanced_package_pilot/policy_audit.json
```

## 命令

构建：

```bash
python scripts/build_advanced_package_policy_audit.py
```

校验：

```bash
python scripts/verify_advanced_package_policy_audit.py
```

重建整条静态链：

```bash
python scripts/build_advanced_package_chain.py --check
```

## 下一步

1. 为 5 个仍保持 manual review 的 XMLDOM overload 补充专用 case 或继续排除。
2. 为 27 个 runtime case 补充实机前置环境、权限检查和捕获/恢复步骤。
3. 在授权执行前核对 XML 资源释放与异常路径收据。
4. ILM 策略与 job 接口继续排除在首批授权执行外。

## 边界

- 审计推荐不生成 runtime receipt；runtime candidate 也不是 runtime evidence。
- 静态签名覆盖不证明数据库行为。
- 本审计不生成 runtime receipt。
- runtime 行为验证必须另接收据与独立 audit。
