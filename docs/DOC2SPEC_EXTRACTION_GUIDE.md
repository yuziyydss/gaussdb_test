# Doc2Spec 产品文档自动抽取指南与 Prompt 模板

> **Legacy V0：** 本文模板面向旧三文件结构。新的抽取流程以 [Doc2Spec Extraction Rules V1](DOC2SPEC_EXTRACTION_RULES_V1.md) 为准，并输出 Factor Package V1。

> 本文档指导如何利用大语言模型（LLM: DeepSeek / Gemini / GPT-4）从 GaussDB 官方产品手册、SQL 参考文档及约束说明中，标准化抽取生成 **语法规范 (`*.syntax.yaml`)**、**兼容矩阵 (`*.matrix.yaml`)** 与 **测试清单 (`*.manifest.yaml`)**。

---

## 一、 抽取工作流与分工原则

为了保证抽取质量，**严禁使用单一大 Prompt 一次性抽取所有内容**。推荐采用 **“分章节分工抽取”** 流程：

```
                    ┌──────────────────────────────────────────────┐
                    │      GaussDB 产品文档 (Markdown/HTML/Text)    │
                    └──────────────────────┬───────────────────────┘
                                           │
        ┌──────────────────────────────────┼──────────────────────────────────┐
        │ [任务 1: 语法参考章节]           │ [任务 2: 数据类型与约束章节]     │ [任务 3: 测试场景与特性]
        ▼                                  ▼                                  ▼
【Prompt 1: 提取语法产生式】        【Prompt 2: 提取数据类型与限制】   【Prompt 3: 生成测试意图清单】
        │                                  │                                  │
        ▼                                  ▼                                  ▼
 `grammars/*.syntax.yaml`           `matrices/*.matrix.yaml`           `manifests/*.manifest.yaml`
        │                                  │                                  │
        └──────────────────────────────────┼──────────────────────────────────┘
                                           │
                                           ▼
                           【Step 4: 静态校验与入库】
                           `python -m unittest tests.test_spec_engine`
                           `SpecLinter` 自动检查语法与引用闭合性
```

---

## 二、 Prompt 模板 1：从 SQL 参考章节抽取语法规范 (`*.syntax.yaml`)

### 输入说明
将官方手册中的 SQL 语法章节内容（如 `CREATE INDEX` 语法说明、BNF 产生式）作为上下文输入。

### 提示词模板 (Prompt)

```text
你是一个专业的数据库文法工程专家。请阅读以下提供的 GaussDB 产品文档中关于【SQL 语法】的章节内容，将其精确转化为标准化的 YAML 语法规范。

【输出目标格式规范】
文件类型：*.syntax.yaml
Schema 定义：
- id: "syntax_<sql_name>" (唯一标识符)
- name: "语法中文名称"
- category: "DDL" | "DML" | "DCL" | "TCL"
- doc_ref: "文档章节相对路径"
- description: "语法功能简要说明"
- production: "产生式模板字符串，其中可变部分使用 {slot_name} 占位"
- slots:
    slot_name:
      type: "token" | "element_list"
      optional: true | false
      values: [候选值列表]
      delimiter: ", " (仅 element_list 需提供)
      min_elements: 1 (仅 element_list 需提供)
      max_elements: 3 (仅 element_list 需提供)
      symbol_action: "creates_table" | "consumes_table" | "consumes_column" | null

【提取准则】
1. production 骨架必须包含所有主要关键字与占位符；
2. 占位符必须在 slots 字典中有明确的对应定义；
3. 如果是列表型参数（如列清单、索引列），设置 type: "element_list"；
4. 仅输出合法的 YAML 代码块，不要包含任何额外的客套话。

【文档输入】
===
{PASTE_YOUR_DOCUMENTATION_HERE}
===
```

---

## 三、 Prompt 模板 2：从特性限制章节抽取兼容性矩阵 (`*.matrix.yaml`)

### 输入说明
将官方手册中关于“数据类型取值范围”、“存储引擎限制”、“约束条件限制”或“版本兼容性说明”的章节输入。

### 提示词模板 (Prompt)

```text
你是一个数据库内核与测试专家。请阅读以下提供的 GaussDB 官方手册中关于【数据类型与约束限制】的章节内容，将其转化为全局语义兼容性矩阵。

【输出目标格式规范】
文件类型：*.matrix.yaml
Schema 定义：
- id: "matrix_gaussdb_<topic>"
- name: "矩阵中文名称"
- description: "矩阵说明"
- data_types:
    TYPE_NAME:
      category: "numeric" | "string" | "datetime" | "binary" | "json" | "boolean"
      representative: "典型合法正向值"
      boundary_values: ["边界值1", "边界值2"]
      invalid_values: ["非法值1"]
      expected_sqlstates_for_invalid: ["预期错误码集合如 22P02"]
- storage_engines:
    ENGINE_NAME:
      orientation: "ROW" | "USTORE" | "COLUMN"
      supports_temporary: true | false
- compatibility_rules:
    - "一阶逻辑约束规则字符串 (支持 P => Q 蕴含逻辑与 Pythonic 表达式)"

【提取准则】
1. 找出文档中明确声明的限制规则（例如：“某特性不支持临时表”、“某引擎不支持某类约束”），转化为 `A => B` 格式的 compatibility_rules；
2. 为每个数据类型明确标注非法输入时的预期 SQLSTATE 错误码；
3. 仅输出合法的 YAML 代码块。

【文档输入】
===
{PASTE_YOUR_DOCUMENTATION_HERE}
===
```

---

## 四、 Prompt 模板 3：生成组合测试清单 (`*.manifest.yaml`)

### 提示词模板 (Prompt)

```text
你是一个资深数据库测试设计专家。请根据已有的语法规范 ID 和兼容矩阵，针对【指定测试目标】生成组合测试清单。

【测试目标】
{DESCRIBE_TESTING_GOAL: 例如测试 CREATE INDEX 的索引类型与多数据类型组合覆盖}

【输出目标格式规范】
文件类型：*.manifest.yaml
Schema 定义：
- id: "manifest_<name>"
- name: "清单中文名称"
- description: "测试意图说明"
- target_syntax: "引用的语法 ID"
- import_matrices: ["引用的矩阵 ID 列表"]
- bindings:
    slot_name: [本次测试关心的取值空间]
- strategy: "pairwise" | "equivalence" | "full_cartesian"
- additional_constraints:
    - "本次测试特定的附加剪枝约束规则"

【提取准则】
1. 确保 bindings 中的 key 与对应 syntax 中的 slot_name 匹配；
2. 默认选择 "pairwise" 算法保障高性价比两两组合；
3. 仅输出合法的 YAML 代码块。
```

---

## 五、 入库与质量校验门禁

当大模型输出上述 YAML 后，只需两步即可完成全自动校验与入库：

1. **保存文件**：
   * 语法规范保存至 `grammars/<category>/<name>.syntax.yaml`
   * 兼容矩阵保存至 `matrices/<name>.matrix.yaml`
   * 测试清单保存至 `manifests/<category>/<name>.manifest.yaml`

2. **运行静态 Linter 与单元测试**：
   ```bash
   python3 -m unittest tests.test_spec_engine
   ```
   * `SpecLinter` 会自动验证所有的语法占位符是否闭合、矩阵引用是否存在、CSP 约束是否有语法错误；
   * 校验通过后，Web UI 和 CLI 即可立刻识别并生成对应的测试用例！
