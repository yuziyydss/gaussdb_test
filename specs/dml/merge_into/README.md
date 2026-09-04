# MERGE INTO Factor Package V1

唯一产品证据是第二批 PDF catalog 中的 `1.13.16.2 MERGE INTO` 章节。

当前可生成范围：

- 普通表及一级分区目标；
- 表、视图和一层 SELECT 子查询源；
- MATCHED/NOT MATCHED 两种顺序、单分支、元组赋值、WHERE 与 DEFAULT VALUES；
- 文档明确的无 action、重复 action、多行 VALUES 和更新关联字段负向结构。

当前明确保留的缺口：

- 具体 plan hint 值域；
- 二级分区 fixture 与被引用章节的完整契约；
- 任意深度子查询及完整 expression/subquery 值域；
- 权限、触发器、分区异常、hint 生效、系统列限制和结果行为尚未连接数据库执行。

因此本包是静态生成候选，不宣称 PDF 语法域全覆盖或数据库行为已验证。
