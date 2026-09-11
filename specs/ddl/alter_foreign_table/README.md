# ALTER FOREIGN TABLE：有限表级选项候选

根据本地PDF抽取正文 L13–15、L28–31、L71–86，使用已有log_fdw服务器提供者，
补充省略ADD、ADD、SET和DROP latest_files的四个静态候选。值只取文档示例2与5；
不从示例推出任意整数都合法，也不承诺日志数据读取能力。

ADD/省略ADD：初始外表只有logtype，不存在latest_files。
SET/DROP：setup在创建外表后先ADD latest_files '2'，再运行目标。
每个候选独立创建schema/外表，最后逆序RESTRICT清理；不串接四份快照。
共享服务器本身也须独占并取得创建回执，不能在公用实例直接执行快照。

生成器核对真实server/schema/foreign table身份、log_fdw、选项初始状态、目标操作、
非PDB与已确认目录能力门禁及完整清理序列。错wrapper、缺少初始选项、其他选项名、
多余SQL、目标漂移会拒绝生成；这不是通用FDW validator或执行授权。

`scope: syntax_only`：只代表有限文档候选，不代表已验证DDL执行和目录行为。
物理模式、实际权限、wrapper能力、目录Oracle和运行归属仍待核实。
四个操作各自以单步骤场景绑定真实候选，保持planned，目录Oracle仍为待校准手工断言。
`prepare_execution_batch.py --profile foreign_options`可离线生成四份独立生命周期计划；
SET/DROP的前置ADD仅在已登记外表、latest_files尚未添加时识别，记录成功回执要求。
重复ADD、其他选项/值、未归属目标仍阻断，不代表运行时已建立状态或已实现Oracle。

原有通用operation条件值、file_fdw文件合同、列级不完整产生式及开发指南依赖均保留。
新增专用值不把这些缺口标为covered，也不把本包整体标成ready。
