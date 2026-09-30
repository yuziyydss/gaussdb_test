# GUC Reference Schema V2

## 目标

`core/guc_reference.py` 将权威全书目录中的 **7.3 GUC参数说明** 全章转换为严格、可审计的参考目录。它复用：

- `generated/full_document_catalog/catalog.json` 作为章节、页码和哈希权威来源；
- `core.guc_environment` / `environments/guc_parameters_v1.yaml` 作为已有20个参数的 V1 pilot 模型；
- V2 不把参考目录当作新的执行策略，也不放宽 V1 的 `session_overlay` / `read_only` / `manual_review` / `blocked` 安全边界。

## 构建结果

| 指标 | 当前值 |
|---|---:|
| 参数定义出现次数 | 1,177 |
| 唯一参数名 | 1,175 |
| 显式重复定义 | 2 |
| 覆盖参数小节 | 82 |
| 参数类型 | 字符串234 / 布尔型384 / 整型443 / 枚举类型76 / 浮点型40 |
| context 提取 | explicit 1,167 / conditional 1 / unspecified 9 |
| 7.3.59 预留名 | 15 |
| 7.3.59 废弃名 | 35 |
| 其中已有完整定义的预留/废弃名 | 4 |
| V1 pilot 链接 | 20 / 20 |
| V1 pilot context 对齐 | 20 / 20 |

显式重复定义不合并：

- `unix_socket_directory`
- `enable_hypo_index`

每个名称保留两个 occurrence，各自绑定小节、物理页、行锚点和原始字段，避免把不同章节中的语义差异静默压扁。

## 每个 occurrence 保留的字段

- 参数说明
- 参数类型
- 参数单位
- 取值范围
- 默认值
- 设置方式
- 设置建议
- 设置不当的风险与影响
- GaussDB context type（explicit / conditional / unspecified）
- 小节路径、物理页、`source_anchor`
- 章节来源 SHA-256、全书 catalog SHA-256、父 PDF SHA-256

其中 `exec_behavior_knob` 的 PDF 抽取文本存在换行标签 `默认\n值：`，解析器显式保留为 `默认 值：...`，不猜测或丢弃该默认值。

## 后续消费

V2 已被 [GUC Candidate Matrix V1](GUC_CANDIDATE_MATRIX_V1.md) 消费，用于生成候选准入分类和下一批人工评审队列；该矩阵不扩大执行策略。

## 输出

构建：

```bash
python scripts/build_guc_reference_catalog.py
```

输出：

```text
generated/guc_reference_catalog/catalog.json
```

加载与校验：

```bash
python -m unittest tests.test_guc_reference -q
```

## 与 V1 pilot 的关系

V2 对每个 V1 pilot 参数建立：

- pilot id
- reference id
- pilot schema version
- V1 execution policy
- V1 context type
- V2 reference context types
- context match 结果

构建时如果出现以下情况会失败关闭：

- V1 pilot 参数在 7.3 全章中不存在；
- V1 context type 与 V2 原文提取结果不一致；
- 生成 artifact 与当前 V1 pilot 文件或权威 full-book catalog 发生哈希/字段漂移。

## 边界

- V2 是参考目录，不是数据库行为验证结果。
- `取值范围`、`默认值` 和 `设置方式` 保留为文档原文，不自动转换成可执行 SQL。
- `context_type=unspecified` 的9个定义、1个 conditional 定义以及所有 POSTMASTER / SIGHUP / SUSET 参数都不能从 V2 直接推导为 session overlay。
- 预留参数、废弃参数和已有定义之间的交叉关系被显式登记，但不自动移除或改写历史定义。
- V1 的安全执行策略仍以 `environments/guc_parameters_v1.yaml` 为准；V2 只提供更完整的原文索引和一致性校验。
- 重建命令依赖本机保留的 `work/pdf_tiered_2026_09_07/batch_34/corpus/general/utility/section_7_3.txt`；提交后的 `catalog.json` 自身保留全部解析结果，供没有本地 work 语料的消费者加载。
