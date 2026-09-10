# 外表有限目录 profile：范围和依据

新增 CREATE FOREIGN TABLE、DROP FOREIGN TABLE 各一条静态候选。依据当前 PDF 的 CREATE FOREIGN TABLE L101—111：先建 log_fdw 服务器，用单 TEXT 列和 `logtype 'gs_log'` 建外表，再删外表/服务器。CREATE SERVER L26—27 又明确 log_fdw/file_fdw 仅语法兼容、可以创建外表、没有实际使用意义。

因此，本批只测试**目录对象 DDL 的有限形状**，不读取日志、扫描外表、导入文件或证明 FDW 数据能力。没有服务端路径、地址或凭据，也没有把 log_fdw 示例替代 file_fdw 的 filename/format 规则。

## 实际前置

两个包共同引用 `fixture_shared_log_fdw_catalog_server`，实际 setup 为 CREATE SERVER；包内 fixture 创建独占 schema。DROP 的 fixture 还实际创建与目标同名的外表，不用普通表或不存在对象冒充前置。

CREATE 的清理顺序是外表 → schema → server；DROP 的清理顺序是 schema → server。均采用 RESTRICT，没有预 DROP、CASCADE 或仅靠 ROLLBACK 的清理。若目标 DROP 失败，schema/server 清理可能因为残留依赖再次失败：必须保留原始目标错误与独立的清理错误，不能把清理成功当成目标通过。

这仍不是运行时归属证明。执行前需要单独授权、确认新建对象不存在、记录每次成功 CREATE 和目标 DDL 的身份回执；只能清理已核实由本次创建的对象。不能将 SQL 快照直接拼起来执行，特别不能在 setup 失败后继续目标或盲目清理。

## 静态合同

`core/log_fdw_catalog_contract.py` 核对服务器类型、无额外 OPTIONS 的 server、先 server 后 schema 的顺序、schema/table/server 引用、单 TEXT 列、精确 gs_log 选项、RESTRICT 清理和真实 DROP 前置。它拒绝 file_fdw 混用、文件名/凭据选项、缺 server、普通表冒充和错误清理次序。

此合同仅接入当前一般模式来源的两个包，要求显式有限 profile 和环境门禁，不能去掉合同标签后继续生成。未来其他 FDW/参数分支需要自己的有来源合同，不能假装已由此合同支持。

原有 conditional 值没有改成 valid。新增的有限 fresh 取值只对本示例生效。`format=not_applicable` 不渲染，也不计入已消费的文件格式维度；原 TEXT/CSV/BINARY/FIXED 仍待真实文件布局与 validator 合同。每包只有一个候选，交互覆盖显示 n/a，不能声称进行了丰富的 Pairwise 组合测试。

## Oracle 和未覆盖项

场景通过 manifest 与维度选择器引用真实候选，元数据断言仍为 planned/manual_assertion。没有猜测系统目录字段或 SQLSTATE，也不声明行为验证成功。

本批不覆盖文件数据语义、递归列定义、FIXED FORMATTER、缺失外表 NOTICE、CASCADE/视图/函数依赖差异、PDB 操作等。CREATE CONVERSION 经同批评审仍保留内部调用限制：普通 schema 权限和一个同签名 dummy 函数不足以满足系统内部转换处理器合同，不增加其正向候选。
