# 开发路线图

## Phase 1: 基础框架 (已完成)

- [x] 因子数据模型 (Pydantic)
- [x] 三种组合策略 (equivalence / pairwise / full_cartesian)
- [x] SQL 模板渲染
- [x] YAML 因子加载器
- [x] Web UI (FastAPI + HTMX + Tailwind)
- [x] HTML/JSON 报告
- [x] 执行器桩模式

## Phase 2: 增强能力 (当前)

- [x] 预期结果标注 (expected + expected_sqlstate)
- [x] 文档溯源 (doc_ref)
- [x] Fixture 链 (setup + _resolve_setup)
- [x] Fixture 矩阵 (matrix + _generate_matrix)
- [x] 上下文叠加 (context_overlays)
- [x] 跨因子预期规则 (expected_matrix)
- [x] 执行器真实模式骨架 (psycopg2 + SQLSTATE + core dump 检测)
- [x] 预期比对 + verdict (pass/fail/crash)
- [ ] 执行器真实模式接入真实 GaussDB
- [ ] 报告器展示 expected + verdict
- [ ] Web UI 展示预期结果和 fixture 链

## Phase 3: 因子量扩充

目标: 从 5 个因子扩到 50+ 个

- [ ] 数据类型因子 (INTEGER/VARCHAR/DATE/JSON/BYTEA/...)
- [ ] DDL 因子 (CREATE INDEX/VIEW/SEQUENCE/FUNCTION/TRIGGER)
- [ ] DML 因子 (INSERT 多行/SELECT/UPDATE/DELETE/MERGE)
- [ ] 约束因子 (NOT NULL/PK/UK/CK/FK)
- [ ] 查询特性因子 (JOIN/子查询/CTE/窗口/集合运算)
- [ ] 对象形态因子 (临时表/分区表/外部表)

## Phase 4: 深度能力

- [ ] 场景链 (多因子顺序执行 + 逐步验证)
- [ ] 覆盖度仪表盘 (doc_ref 对照文档, 缺口报告)
- [ ] 基线快照 + 版本 diff
- [ ] 上下文矩阵 (存储引擎 × 兼容模式 × 隔离级别)
- [ ] 文档解析器 (从产品文档提取特性树)

## Phase 5: GaussDB 扩展纵深

- [ ] Ustore 引擎因子
- [ ] MOT 引擎因子
- [ ] Oracle/MySQL 兼容模式因子
- [ ] 系统包因子 (DBE_OUTPUT/DBE_SCHEDULER/...)
- [ ] 分布式特性因子 (若适用)

## Phase 6: 工程化

- [ ] CI/CD 集成
- [ ] 测试选择策略 (变更影响分析)
- [ ] 缺陷反馈闭环 (bug → 因子权重)
- [ ] 性能优化 (并行执行, 用例裁剪)
- [ ] 团队协作 (因子评审, 权限管理)
