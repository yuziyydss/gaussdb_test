# GaussDB 规格驱动SQL测试生成系统 — 交付报告

**日期**: 2026-09-14
**PDF版本**: V2.0-10.0.0 集中式参考（5,686页）

---

## 一、系统架构

```
PDF原文（5,686页）
    ↓ [Doc2Spec 抽取]
因子包（317个: 224 general + 93 M兼容）
    ↓ [Factor Package V1 模型]
manifest（841份）
    ↓ [Pairwise/全组合生成]
候选SQL（5,273条）
    ↓ [待执行] ← 当前状态
测试结果 → 覆盖报告
```

## 二、已交付成果

### 2.1 因子包体系

| 指标 | 数值 |
|---|---|
| 因子包总数 | 317（224 general + 93 M兼容） |
| manifest | 841份 |
| 候选SQL | 5,273条 |
| M包source extraction | 93/93 ✅ |
| Value gaps | 25条（18合法阻断 + 7可行动） |

### 2.2 结构化知识库

| 类别 | Facts数 | 深度 |
|---|---|---|
| Oracle高级包（22个） | 170 | 接口签名+参数+行为示例 |
| Oracle系统函数 | 18 | 兼容性差异+SQL示例 |
| Oracle系统视图 | 17 | ALL→DB/DBA→ADM映射 |
| Oracle PL/SQL语法 | 19 | 操作符/类型/控制/SQL/触发器 |
| M模式数据类型 | 21 | 数值/日期/字符串/二进制 |
| M模式操作符 | 25 | 比较/逻辑/正则/索引走行 |
| M模式系统函数 | 17 | 流程/日期/字符串/聚合差异 |
| behavior_compat SQL示例 | 26 | 设置前后完整对比 |
| 运行参数 | 116 | 兼容性/查询/锁/事务/连接/WAL/复制/日志/统计/负载 |
| 兼容性说明 | 77 | Oracle+M+B模式 SQL/类型/操作符 |
| 存储过程 | 54 | 游标(WHERE CURRENT OF)/基本/控制/动态/高级包 |
| 系统表/视图 | 78 | 核心目录+DBE_PERF+权限/审计/脱敏 |
| Schema | 30 | Information/DBE_PERF详细/其他 |
| 工具参考 | 13 | gsql/gs_guc/gs_dump/gs_loader |
| 日志参考 | 6 | 系统/操作/审计/WAL/内存 |
| WDR/ASP | 6 | 报表概览 |
| **总计** | **795** | 全部confirmed |

### 2.3 原文语料

- 103个txt文件，覆盖PDF全部大部
- SHA-256溯源，可与PDF对账

## 三、Git提交记录

| 阶段 | 提交数 | 内容 |
|---|---|---|
| M包源补全 | ~20 | 93包unmapped清零（2,639条） |
| 兼容性说明提取 | ~5 | Oracle/M/B模式 |
| 运行参数提取 | ~3 | 116条核心参数 |
| 存储过程提取 | ~5 | 54条+22个高级包 |
| 系统表/视图提取 | ~3 | 78条 |
| 深化抽取 | ~10 | 313条详细facts |
| 测试修复 | ~15 | builder测试+fact类型修复 |
| **总计** | **~70** | 全部已推送至GitHub |

## 四、已知限制

| 限制 | 说明 |
|---|---|
| 实机验证 | **0条SQL执行**，所有结论均为静态 |
| Value gaps | 25条中18条为合法阻断（文档冲突/环境资产/语义设计） |
| 深化不均匀 | 高级包/操作符/数据类型较深，系统函数为概要级 |
| 非SQL参考Schema | 未实现V1真实执行与非SQL参考Schema |
| 数据库执行 | 需单独授权和验收 |

## 五、下一步路线

### 短期（有数据库环境后）
1. 执行Phase 1最小验证（10条SQL）→ 详见 EXECUTION_VALIDATION_PLAN.md
2. 修复发现的生成器问题
3. 扩展到Phase 2（完整manifest）

### 中期
1. 将795条facts接入现有包的条件值判定
2. 用behavior_compat_options差异设计GUC切换测试
3. 实现存储过程包装的WHERE CURRENT OF测试

### 长期
1. 实现V1真实执行框架
2. 建立非SQL参考Schema
3. 覆盖率报告自动化

## 六、文件位置

| 内容 | 路径 |
|---|---|
| 因子包 | specs/ |
| 结构化facts | docs/compat_facts/ |
| 候选SQL | generated/factor_packages/ |
| 原文语料 | docs/compat_facts/*.txt |
| 执行验证方案 | docs/EXECUTION_VALIDATION_PLAN.md |
| 缺口处置 | docs/VALUE_GAP_DISPOSITION_20260911.md |
| 运行记录 | work/overnight_evolution_20260912_0829/state.md |
