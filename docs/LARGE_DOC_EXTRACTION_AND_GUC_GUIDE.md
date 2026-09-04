# 海量文档抽取与 GUC 建模边界

状态：当前海量文档执行入口是 [内网批量 Doc2Spec 运行手册](INTRANET_AI_BATCH_EXTRACTION.md)。本文只说明文档分类和GUC边界，不再定义另一套抽取流程。

## 1. 5800页不能作为一个任务

整本 PDF 必须先由 `scripts/extract_pdf_sections.py` 按书签路径和页内坐标转换为稳定的 UTF-8 章节语料及 `catalog.json`。一个任务对应一个可独立验收的章节；catalog 负责建立全书任务库存和来源边界，章节正文才作为产品事实。

第一阶段只处理SQL命令章节：

```text
intranet_corpus/<variant>/<category>/<statement>.txt
```

例如：

```text
intranet_corpus/general/ddl/create_table.txt
intranet_corpus/general/dml/update.txt
intranet_corpus/m_compat/dml/select.txt
```

任务登记、认领、状态机和静态门禁全部由 `scripts/manage_extraction_queue.py` 完成。整本 PDF 的分母对账由 `scripts/audit_pdf_catalog_coverage.py` 完成。详细命令见当前运行手册。

## 2. 文档类型需要不同出口

| 文档类型 | 当前处理方式 |
|---|---|
| SQL DDL/DML/DCL/TCL命令 | Factor Package V1 |
| 兼容模式SQL命令 | 独立variant和factor ID，禁止与general混写 |
| 数据类型 | 未来共享类型能力Schema/matrix |
| 函数与操作符 | 未来表达式目录、签名和结果Oracle |
| GUC参数 | 未来环境能力与overlay模型 |
| 系统表/系统视图 | 未来metadata oracle目录 |
| 安装、部署、运维 | 不直接生成SQL factor；单独登记范围 |

因此不能用“生成了多少 factor”衡量整本手册覆盖。必须先有 PDF catalog 分母，再按文档类型以及 cataloged、extracted、package_bound、static_complete 四个阶段分别对账。

## 3. GUC不是SQL语法槽位

GUC会改变优化器、事务、兼容模式、内存和执行行为，它属于环境能力，不应硬编码进单条SQL syntax。

未来GUC模型至少需要：

- 参数名、类型、默认值和值域；
- 生效层级：实例、数据库、用户、会话或事务；
- 是否需要重启/重载；
- 适用部署形态和兼容模式；
- 与其他参数的依赖或互斥；
- 可验证的metadata/behavior oracle；
- 恢复原值和环境清理方式。

在专用Schema和执行器完成前，根目录 `matrices/guc_parameters.matrix.yaml` 只是Legacy V0样例，不能据此宣称GUC抽取或NoREC已经闭环。

## 4. NoREC和差分测试状态

NoREC、Astore/Ustore差分和跨版本结果比对都需要真实数据库、稳定fixture、会话级GUC控制和结果集Oracle。当前V1静态生成阶段没有实现这些执行闭环，因此它们只属于路线图，不计入已完成功能。

## 5. 推荐批量顺序

1. 关闭当前五个示例的静态审计缺口；
2. 在内网完成10个SQL章节试点；
3. 扩展一个完整DML或DDL子目录；
4. 隔离general和各兼容模式；
5. SQL命令稳定后，再分别设计数据类型、函数、GUC和系统目录Schema。
