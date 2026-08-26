# 海量文档（5800+页）抽取防遗漏管理与 GUC 参数归档规范

> 本指南用于解决两大工业级实战场景：
> 1. **5800+ 页海量 GaussDB 官方产品手册** 如何切片抽取、避免遗漏并实现端到端对账；
> 2. **GaussDB 上千个 GUC（Grand Unified Configuration）系统参数** 如何优雅归档到因子库，并结合 NoREC 实施优化器等价性验证。

---

## 目录

- [一、 5800+ 页海量文档抽取与防遗漏管理体系](#一-5800-页海量文档抽取与防遗漏管理体系)
  - [1. 章节切片与过滤策略 (Chapter Slicing)](#1-章节切片与过滤策略-chapter-slicing)
  - [2. 建立《文档大纲 TOC 特征索引总表》](#2-建立文档大纲-toc-特征索引总表)
  - [3. 自动化 TOC 对账机制 (TOC Reconciler)](#3-自动化-toc-对账机制-toc-reconciler)
  - [4. 基于 SpecCoverageMeter 的深层缺口动态排查](#4-基于-speccoveragemeter-的深层缺口动态排查)
- [二、 GaussDB GUC 参数归档与建模规范](#二-gaussdb-guc-参数归档与建模规范)
  - [1. GUC 参数的核心定位：上下文修饰因子 (Context Modifier)](#1-guc-参数的核心定位上下文修饰因子-context-modifier)
  - [2. 归档层级 1：全局 GUC 参数池 (`matrices/guc_parameters.matrix.yaml`)](#2-归档层级-1全局-guc-参数池-matricesguc_parametersmatrixyaml)
  - [3. 归档层级 2：测试清单场景叠加 (`guc_overlays`)](#3-归档层级-2测试清单场景叠加-guc_overlays)
  - [4. 归档层级 3：驱动 NoREC 优化器正确性差分测试](#4-归档层级-3驱动-norec-优化器正确性差分测试)

---

## 一、 5800+ 页海量文档抽取与防遗漏管理体系

GaussDB 官方文档体系非常庞大（通常包含《开发者指南》、《SQL参考》、《管理员指南》、《系统参数参考》等，合计超过 5800 页）。直接全量抽取必然会导致大模型上下文溢出和抽样遗漏。

### 1. 章节切片与过滤策略 (Chapter Slicing)

首先对 5800 页文档进行粗粒度过滤，精准定位与 SQL 语法及语义相关的核心篇章：

```
GaussDB 5800+ 页文档总集
├── 架构概览与安装部署篇 (~1200页) ───> 【跳过】(与语法测试无关)
├── SQL 语法参考篇 (~1800页) ─────────> 【核心抽取目标 1】──> 转化为 `grammars/*.syntax.yaml`
├── 数据类型与函数篇 (~1000页) ───────> 【核心抽取目标 2】──> 转化为 `matrices/gaussdb_core.matrix.yaml`
├── GUC 系统参数篇 (~1000页) ─────────> 【核心抽取目标 3】──> 转化为 `matrices/guc_parameters.matrix.yaml`
└── PL/SQL 与存储过程篇 (~800页) ─────> 【二期抽取目标】──> 转化为 `grammars/plsql/*.syntax.yaml`
```

---

### 2. 建立《文档大纲 TOC 特征索引总表》

利用脚本一次性提取 PDF 目录书签或 HTML 目录树（Table of Contents），建立基准索引清册（如 `docs/gaussdb_doc_catalog.yaml`）：

```yaml
# docs/gaussdb_doc_catalog.yaml (对账基准)
metadata:
  total_sections: 142
  doc_version: "GaussDB 3.0"

sections:
  - id: "sec_ddl_create_table"
    doc_ref: "SQL参考/DDL/CREATE-TABLE"
    title: "CREATE TABLE"
    status: "extracted"       # 已抽取 -> grammars/ddl/create_table.syntax.yaml

  - id: "sec_ddl_create_index"
    doc_ref: "SQL参考/DDL/CREATE-INDEX"
    title: "CREATE INDEX"
    status: "pending"         # 待抽取

  - id: "sec_dml_update"
    doc_ref: "SQL参考/DML/UPDATE"
    title: "UPDATE"
    status: "pending"
```

---

### 3. 自动化 TOC 对账机制 (TOC Reconciler)

通过对账程序定期扫描项目：
1. 自动读取 `grammars/` 中所有 YAML 文件的 `doc_ref` 属性；
2. 与 `gaussdb_doc_catalog.yaml` 取差集（Set Difference）；
3. **输出未抽取章节清单**：
   ```
   [TOC 对账结果]
   总章节数: 142 | 已抽取入库: 15 (10.5%) | 待抽取: 127
   未覆盖核心章节 TOP 5:
   - SQL参考/DDL/CREATE-INDEX
   - SQL参考/DML/UPDATE
   - SQL参考/DML/DELETE
   - SQL参考/DDL/CREATE-VIEW
   - SQL参考/DDL/CREATE-SEQUENCE
   ```

---

### 4. 基于 `SpecCoverageMeter` 的深层缺口动态排查

即使某章节已生成 `*.syntax.yaml`，大模型可能漏掉了某个冷门 AST 插槽或选项：
* 运行覆盖率度量器：`python3 -m unittest tests.test_coverage_meter` 或打开 Web 页面；
* 仪表盘与导出的 Markdown 缺口报告会精确指出：
  * **插槽级未覆盖**：如 `syntax_create_table.storage_options` 缺少了 `WITH (ORIENTATION = COLUMN)`；
  * **数据类型级未覆盖**：如 `matrix_gaussdb_core` 中的 `BYTEA` 尚未被任何测试清单绑定。

---

## 二、 GaussDB GUC 参数归档与建模规范

GaussDB 拥有大量的 GUC（Grand Unified Configuration）参数，直接决定了查询执行计划、兼容模式、存储引擎行为与事务隔离级别。

### 1. GUC 参数的核心定位：上下文修饰因子 (Context Modifier)

* **核心原则**：**GUC 参数严禁硬编码在单条 SQL 语法文件中！**
* GUC 是跨所有 SQL 全局通用的环境修饰因子，应当归档在 `matrices/` 中并按需在 `manifests/` 中叠加。

---

### 2. 归档层级 1：全局 GUC 参数池 (`matrices/guc_parameters.matrix.yaml`)

将优化器算子开关、兼容模式、事务行为与内存参数归档在全局参数池中：

```yaml
# matrices/guc_parameters.matrix.yaml
id: matrix_gaussdb_guc
name: "GaussDB 核心 GUC 参数等价类池"
description: "覆盖优化器算子开关、兼容模式多态、事务隔离级别与存储引擎控制参数"

guc_parameters:
  # 1. 优化器算子执行开关
  enable_seqscan:
    scope: "session"
    type: "boolean"
    classes:
      - { name: "开启全表扫描", value: "on" }
      - { name: "强制禁用全表扫描", value: "off" }

  enable_indexscan:
    scope: "session"
    type: "boolean"
    classes:
      - { name: "开启索引扫描", value: "on" }
      - { name: "强制禁用索引扫描", value: "off" }

  # 2. 数据库兼容模式
  sql_compatibility:
    scope: "session / db_init"
    type: "enum"
    classes:
      - { name: "PostgreSQL 兼容模式", value: "'PG'" }
      - { name: "MySQL 兼容模式(B模式)", value: "'B'" }
      - { name: "Oracle 兼容模式(A模式)", value: "'A'" }

  # 3. 事务隔离级别
  default_transaction_isolation:
    scope: "session"
    type: "enum"
    classes:
      - { name: "读已提交", value: "'read committed'" }
      - { name: "可重复读", value: "'repeatable read'" }
```

---

### 3. 归档层级 2：测试清单场景叠加 (`guc_overlays`)

在具体的测试清单中，引入 GUC 场景叠加配置。执行器在执行目标 SQL 前自动下发 `SET ...;` 命令：

```yaml
# manifests/dml/select_optimizer_guc.manifest.yaml
id: manifest_select_optimizer_guc
name: "SELECT 查询 × 优化器 GUC 算子开关矩阵测试"
target_syntax: "syntax_select"

import_matrices:
  - "matrix_gaussdb_guc"

# GUC 上下文场景叠加
guc_overlays:
  - name: "场景1: 纯全表扫描回放"
    set_sqls:
      - "SET enable_seqscan = on;"
      - "SET enable_indexscan = off;"

  - name: "场景2: 强制索引扫描回放"
    set_sqls:
      - "SET enable_seqscan = off;"
      - "SET enable_indexscan = on;"

  - name: "场景3: B模式 MySQL 兼容回放"
    set_sqls:
      - "SET dolphin.b_compatibility_mode = on;"
```

---

### 4. 归档层级 3：驱动 NoREC 优化器正确性差分测试

利用 GUC 参数可以全自动实施数据库测试领域的 **NoREC (Non-optimizing Reference Engine Construction)** 测试：

```
                               ┌───────────────────────────┐
                               │ 目标查询 Q (带过滤与聚合)  │
                               └─────────────┬─────────────┘
                                             │
                      ┌──────────────────────┴──────────────────────┐
                      ▼                                             ▼
          【执行环境 1: 禁用索引优化】                   【执行环境 2: 强制索引优化】
           SET enable_indexscan = off;                    SET enable_indexscan = on;
           SET enable_seqscan = on;                       SET enable_seqscan = off;
                      │                                             │
                      ▼                                             ▼
               得到基线结果集 R1                             得到优化结果集 R2
                      │                                             │
                      └──────────────────────┬──────────────────────┘
                                             │
                                             ▼
                                   【断言比对: R1 == R2】
                           不相等则 100% 捕获优化器/索引算子 Bug!
```

---

### 三、 实施检查清单 (Checklist)

- [x] 在 `matrices/guc_parameters.matrix.yaml` 中建立核心 GUC 参数池；
- [x] 在 `docs/gaussdb_doc_catalog.yaml` 中登记文档章节大纲目录；
- [x] 通过 `SpecCoverageMeter` 实时监控未抽取的文档特性与插槽；
- [x] 在测试清单中通过 `guc_overlays` 叠加执行计划与兼容模式；
- [x] 利用 GUC 开关组合验证 NoREC 优化器结果集等价性。
