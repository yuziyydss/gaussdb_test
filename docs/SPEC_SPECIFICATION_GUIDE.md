# 三类标准规格文件设计范式与编写规范

> 本规范定义了从 GaussDB 产品文档中抽取并维护的三类标准化规格文件：**语法规范 (`*.syntax.yaml`)**、**全局兼容矩阵 (`*.matrix.yaml`)** 与 **组合测试清单 (`*.manifest.yaml`)** 的详细 Schema、字段语义、设计范式与编写准则。

---

## 目录

- [一、 核心设计思想与分工](#一-核心设计思想与分工)
- [二、 语法规范文件 (`*.syntax.yaml`) 编写规范](#二-语法规范文件-syntaxyaml-编写规范)
  - [1. 字段详细 Schema](#1-字段详细-schema)
  - [2. AST 插槽类型与产生式修饰](#2-ast-插槽类型与产生式修饰)
  - [3. 完整示例](#3-完整示例)
- [三、 全局语义兼容矩阵 (`*.matrix.yaml`) 编写规范](#三-全局语义兼容矩阵-matrixyaml-编写规范)
  - [1. 字段详细 Schema](#1-字段详细-schema-1)
  - [2. 数据类型等价类池定义](#2-数据类型等价类池定义)
  - [3. CSP 兼容性规则编写语法](#3-csp-兼容性规则编写语法)
  - [4. 完整示例](#4-完整示例)
- [四、 组合测试清单 (`*.manifest.yaml`) 编写规范](#四-组合测试清单-manifestyaml-编写规范)
  - [1. 字段详细 Schema](#1-字段详细-schema-2)
  - [2. 绑定与测试强度配置](#2-绑定与测试强度配置)
  - [3. 完整示例](#3-完整示例)
- [五、 文档抽取与校验工具链 (Doc2Spec & spec-lint)](#五-文档抽取与校验工具链-doc2spec--spec-lint)

---

## 一、 核心设计思想与分工

```
                    ┌──────────────────────────────────────────────┐
                    │      GaussDB 产品手册 (SQL 参考 / 特性说明)   │
                    └──────────────────────┬───────────────────────┘
                                           │
        ┌──────────────────────────────────┼──────────────────────────────────┐
        ▼                                  ▼                                  ▼
【1. 语法规范 (*.syntax.yaml)】   【2. 兼容矩阵 (*.matrix.yaml)】   【3. 测试清单 (*.manifest.yaml)】
• 描述：客观文法“能怎么拼”        • 描述：客观限制“能填什么值”      • 描述：主观意图“本次怎么测”
• 存放：grammars/ 目录             • 存放：matrices/ 目录             • 存放：manifests/ 目录
• 内容：BNF 产生式、AST 插槽、     • 内容：数据类型池、引擎兼容矩阵、 • 内容：参数取值绑定、组合策略
  子语法产生式、符号动作注解         CSP 互斥规则、预期错误码           (Pairwise/3-way)、附加约束
```

---

## 二、 语法规范文件 (`*.syntax.yaml`) 编写规范

### 1. 字段详细 Schema

| 字段名 | 类型 | 必填 | 说明 |
| :--- | :--- | :---: | :--- |
| `id` | `string` | **是** | 语法唯一标识符（如 `syntax_create_table`） |
| `name` | `string` | **是** | 语法中文名称（如 `CREATE TABLE 主语法`） |
| `category` | `string` | 否 | 分类（`DDL` / `DML` / `DCL` / `TCL`），默认 `DDL` |
| `doc_ref` | `string` | 否 | 对应的官方产品文档章节路径（如 `"SQL参考/DDL/CREATE-TABLE"`） |
| `description` | `string` | 否 | 语法功能简要说明 |
| `production` | `string` | **是** | 主语法产生式骨架，使用 `{slot_name}` 作为 AST 插槽占位符 |
| `slots` | `dict` | **是** | 插槽详细定义字典（Key 为占位符名称，Value 为插槽规格） |
| `sub_grammars` | `dict` | 否 | 嵌套子语法定义（如列定义、表级约束、分区定义） |

### 2. AST 插槽类型与产生式修饰

* `type`:
  * `token`：单值或枚举词插槽；
  * `element_list`：列表产生式（如 `col_1 INT, col_2 TEXT`），支持 `delimiter`（默认 `, `）、`min_elements` 与 `max_elements`；
  * `sub_grammar`：嵌套子语法插槽；
  * `optional_group`：可选修饰组。
* `symbol_action`:
  * `creates_table`：声明当前语句向 `SchemaContext` 注册新表；
  * `consumes_table`：声明从 `SchemaContext` 动态拾取已有可用表；
  * `consumes_column`：声明从 `SchemaContext` 拾取指定类型的兼容列。

### 3. 完整示例

```yaml
# grammars/ddl/create_table.syntax.yaml
id: syntax_create_table
name: "CREATE TABLE 主语法"
category: DDL
doc_ref: "SQL参考/DDL/CREATE-TABLE"
description: "创建普通/临时/非日志表主语法及列定义插槽"

production: "CREATE {table_modifier} TABLE {table_name} ( {table_body} ) {storage_options}"

slots:
  table_modifier:
    type: token
    optional: true
    values: ["", "TEMPORARY", "UNLOGGED"]
    symbol_action: null

  table_name:
    type: token
    values: ["t_spec_test"]
    symbol_action: "creates_table"

  table_body:
    type: element_list
    delimiter: ", "
    min_elements: 1
    max_elements: 3
    allowed_sub_grammars:
      - "sub_column_def"

  storage_options:
    type: token
    optional: true
    values: ["", "WITH (ORIENTATION = ROW)", "WITH (ORIENTATION = USTORE)", "WITH (ORIENTATION = COLUMN)"]

sub_grammars:
  sub_column_def:
    production: "{column_name} {column_datatype} {column_constraint}"
    slots:
      column_name:
        type: token
        values: ["col_1", "col_2"]
      column_datatype:
        type: token
        values: ["INTEGER", "VARCHAR(100)", "DATE", "BYTEA"]
      column_constraint:
        type: token
        values: ["", "NOT NULL", "PRIMARY KEY", "DEFAULT 0"]
```

---

## 三、 全局语义兼容矩阵 (`*.matrix.yaml`) 编写规范

### 1. 字段详细 Schema

| 字段名 | 类型 | 必填 | 说明 |
| :--- | :--- | :---: | :--- |
| `id` | `string` | **是** | 矩阵唯一标识符（如 `matrix_gaussdb_core`） |
| `name` | `string` | **是** | 矩阵中文名称 |
| `description` | `string` | 否 | 矩阵描述 |
| `data_types` | `dict` | 否 | 全局数据类型规格字典（Key 为类型名，Value 为类型属性） |
| `storage_engines` | `dict` | 否 | 存储引擎特性支持矩阵（Astore/Ustore/Cstore 等） |
| `compatibility_rules`| `list[string]` | 否 | 全局客观互斥与兼容性 CSP 约束规则 |

### 2. 数据类型等价类池定义

每个数据类型包含：
* `category`: 语义大类（`numeric` / `string` / `datetime` / `binary` / `json` / `boolean`）；
* `representative`: 正向典型代表值（如 `'2026-08-26'`）；
* `boundary_values`: 边界值列表（如最大值、最小值、空串、闰年）；
* `invalid_values`: 负向非法值列表（如超长串、非法格式）；
* `expected_sqlstates_for_invalid`: 选取非法值时预期触发的 SQLSTATE 候选集合（如 `["42704", "42601"]`）。

### 3. CSP 兼容性规则编写语法

规则支持一阶逻辑蕴含式（`P => Q`）与 Pythonic 谓词：
* `table_modifier in ['TEMPORARY', 'TEMP'] => storage_options != 'WITH (ORIENTATION = COLUMN)'`（临时表不能用列存）
* `storage_options == 'WITH (ORIENTATION = COLUMN)' => column_constraint != 'PRIMARY KEY'`（列存不支持主键）

### 4. 完整示例

```yaml
# matrices/gaussdb_core.matrix.yaml
id: matrix_gaussdb_core
name: "GaussDB 核心数据类型与引擎兼容矩阵"
description: "全局共享的数据类型等价类与存储引擎客观限制规则"

data_types:
  INTEGER:
    category: "numeric"
    representative: "100"
    boundary_values: ["-2147483648", "2147483647", "0"]
    invalid_values: ["'invalid_str'"]
    expected_sqlstates_for_invalid: ["22P02"]

  VARCHAR(100):
    category: "string"
    representative: "'hello_world'"
    boundary_values: ["''", "'100_chars_sample'"]
    invalid_values: ["'101_chars_overflow'"]
    expected_sqlstates_for_invalid: ["22001"]

  FAKETYPE:
    category: "custom"
    representative: "FAKETYPE"
    boundary_values: []
    invalid_values: ["FAKETYPE"]
    expected_sqlstates_for_invalid: ["42704", "42601"]

storage_engines:
  ASTORE:
    orientation: "ROW"
    supports_temporary: true
  USTORE:
    orientation: "USTORE"
    supports_temporary: true
  CSTORE:
    orientation: "COLUMN"
    supports_temporary: false

compatibility_rules:
  - "table_modifier in ['TEMPORARY', 'TEMP'] => storage_options != 'WITH (ORIENTATION = COLUMN)'"
  - "storage_options == 'WITH (ORIENTATION = COLUMN)' => column_constraint != 'PRIMARY KEY'"
```

---

## 四、 组合测试清单 (`*.manifest.yaml`) 编写规范

### 1. 字段详细 Schema

| 字段名 | 类型 | 必填 | 说明 |
| :--- | :--- | :---: | :--- |
| `id` | `string` | **是** | 测试清单唯一标识符 |
| `name` | `string` | **是** | 清单中文名称 |
| `description` | `string` | 否 | 测试意图说明 |
| `target_syntax` | `string` | **是** | 引用的语法规范 ID（如 `syntax_create_table`） |
| `import_matrices`| `list[string]` | 否 | 导入并生效的兼容矩阵 ID 列表 |
| `bindings` | `dict` | **是** | 本次测试关注的各插槽参数候选值列表 |
| `strategy` | `string` | 否 | 组合测试算法（`pairwise` / `equivalence` / `full_cartesian`），默认 `pairwise` |
| `high_priority_dimensions` | `list[list]` | 否 | 高优先级维度列表（用于提升局部组合强度至 3-way） |
| `additional_constraints` | `list[string]` | 否 | 本次测试场景特有的附加 CSP 约束 |

### 2. 完整示例

```yaml
# manifests/ddl/create_table_comprehensive.manifest.yaml
id: manifest_create_table_matrix
name: "CREATE TABLE 存储引擎与多数据类型组合测试清单"
description: "覆盖普通/临时表、行存/Ustore/列存、正常类型与非法类型的两两组合"

target_syntax: "syntax_create_table"

import_matrices:
  - "matrix_gaussdb_core"

bindings:
  table_modifier: ["", "TEMPORARY", "UNLOGGED"]
  storage_options: ["", "WITH (ORIENTATION = ROW)", "WITH (ORIENTATION = USTORE)", "WITH (ORIENTATION = COLUMN)"]
  column_datatype: ["INTEGER", "VARCHAR(100)", "DATE", "FAKETYPE"]
  column_constraint: ["", "NOT NULL", "PRIMARY KEY"]

strategy: "pairwise"

high_priority_dimensions:
  - ["storage_options", "column_datatype"]

additional_constraints:
  - "table_modifier == 'TEMPORARY' => storage_options != 'WITH (ORIENTATION = COLUMN)'"
```

---

## 五、 文档抽取与校验工具链 (Doc2Spec & spec-lint)

### 1. 静态完整性校验 (`spec-lint`)

在新增或通过 LLM 抽取完 YAML 规格后，可通过内置校验器执行静态检查：

```python
from core.spec_model import SpecRegistry
from core.spec_linter import SpecLinter

registry = SpecRegistry(base_dir=".")
registry.load_all()

linter = SpecLinter(registry)
issues = linter.lint_all()
for issue in issues:
    print(f"[{issue.level}] {issue.file_type} {issue.spec_id}: {issue.message}")
```

### 2. 生成与渲染执行

```python
from core.spec_generator import SpecSQLGenerator

generator = SpecSQLGenerator(registry)
manifest = registry.get_manifest("manifest_create_table_matrix")
cases = generator.generate_cases_for_manifest(manifest)

# 打印生成的 SQL 与自动推导的 expected 结果
for c in cases:
    print(f"[{c.expected}] ({'/'.join(c.expected_sqlstates)}) -> {c.sql}")
```
