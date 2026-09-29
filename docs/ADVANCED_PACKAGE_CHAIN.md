# Advanced Package Static Chain

## 目标

`scripts/build_advanced_package_chain.py` 用一条命令重建高级包 Pilot V1 的静态链，并校验产物哈希稳定。

它只生成静态候选矩阵、策略审计、runtime dry run 和 Evidence Bundle，不连接数据库，不执行高级包调用。

## 命令

```bash
python scripts/build_advanced_package_chain.py
```

检查：

```bash
python scripts/build_advanced_package_chain.py --check
```

## 构建顺序

1. Advanced Package Candidate Matrix
   - 22 个支持的 `DBE_*` 包
   - 22 个已建模 / 0 个未建模
2. Advanced Package Policy Audit
   - 8 个新增包
   - 99/99 distinct callable已建模
   - 126/126 文档签名已建模
   - 16个推荐进入case设计 / 6个首批block
3. Runtime Validation Pilot Dry Run
   - 2 个 GUC overlay 单元
   - 27 个高级包 runtime candidate
4. Advanced Package Runtime Preflight Plan
   - 27 个 case 全覆盖
   - 8 个只读 preflight query
   - 77个 runtime candidate 接口
5. Advanced Package Evidence Bundle

## 输出

```text
generated/runtime_validation_pilot/dry_run.json
generated/advanced_package_pilot/policy_audit.json
generated/advanced_package_pilot/runtime_preflight_plan.json
generated/advanced_package_pilot/evidence_bundle.json
```

## 当前结果

```text
packages=22/22
interfaces=251
runtime_candidates=26
static=True
runtime=False
```

## 页面

浏览静态链结果：

```text
/advanced-package
```

## 边界

- 不连接 GaussDB。
- 不执行高级包调用。
- 不生成 runtime receipt / audit。
- 静态链完整不代表高级包行为验证通过。
