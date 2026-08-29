# 内网 AI 执行入口

本项目支持在无法把产品文档带出公司内网的情况下，由公司内可用的任意 AI 完成 Doc2Spec 抽取。AI 厂商、调用方式和模型名称不属于项目协议；输入输出都通过本地文件交接。

## 给 AI 的唯一总指令

> 你只处理任务文件中指定的一个章节。完整阅读任务文件列出的规则，只修改 OUTPUT_DIR，不改生成器和其他因子包；有歧义记为 open question，不猜测。完成后把队列状态更新为 generated，并运行静态 verify。数据库执行不在本阶段范围。

## 入口命令

首次把已经按章节拆分的内网语料登记为队列：

```bash
python3 scripts/manage_extraction_queue.py inventory --corpus-dir intranet_corpus
```

AI/操作者认领一项任务并生成任务文件：

```bash
python3 scripts/manage_extraction_queue.py claim \
  --worker company-ai-01 \
  --render
```

把命令输出中的 `rendered_task_path` 交给公司 AI。AI 完成文件后记录状态：

```bash
python3 scripts/manage_extraction_queue.py update \
  --task-id <TASK_ID> \
  --status generated \
  --message "Factor Package V1 已生成"
```

最后执行确定性静态门禁：

```bash
python3 scripts/manage_extraction_queue.py verify --task-id <TASK_ID>
```

只有任务信封对账和三道程序门禁全部成功，工具才会写入 `static_complete`。它表示“文档到静态 SQL 生成闭环”，不表示 planned scenario、真实数据库行为或目标 SQLSTATE 已经执行验证。

完整操作、目录约定、失败恢复和批量策略见 [内网批量抽取运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)。Factor Package 数据契约见 [Factor Package Schema V1](docs/FACTOR_PACKAGE_SCHEMA_V1.md)。
