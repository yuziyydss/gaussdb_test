# B 模式单列 MODIFY：有限定义替换合同

原文一般 ALTER TABLE L364—366 给扩展单列语法；L367—369说明新定义替换原定义；L370—374给 B 模式及依赖对象限制；L387—389指出同形语法的 `enable_modify_column` 语义选择。它不是此前 L359—363 的括号多列 MODIFY。

本批只有一个候选：新普通表的可空 `note VARCHAR(48)` 扩宽到 `VARCHAR(96)`。真实 seed 含 ASCII 和 NULL，没有 DEFAULT、索引、约束、生成列、视图或其他依赖。因此不涉及任意类型转换、依赖重建或字符集转换。

`b_format_enable_modify_column: [enabled]` 表示实际 `b_format_behavior_compat_options` 中存在 `enable_modify_column` 选项，不是另一个真实 GUC 名称，也不是整个选项字符串必须只等于这一项。生成器检查声明门禁；运行前仍须在实际 B 数据库核验，不能靠会话参数假装 B。本批不会自动 SET 或恢复该配置。

`at_table_modify_single_b_fresh` 携带 `ordinary_b_single_widen` 列合同，`at_action_modify_single_b_fresh` 要求实际目标提供该合同。生成器复用实际表/字面 seed 解析，仅增加独立单列分支；既有括号多列、ADD 和 RENAME 路径不放宽。检查真实旧长度、可空无默认定义、每行 seed 合法、目标身份、B/选项/隔离/权限门禁及精确同表 DROP。

`scenario_alter_table_modify_single_b_fresh` 从 manifest 绑定真实候选。长度、原行保留和目录 Oracle 仍 planned/manual；`expected.scope=syntax_only` 并不意味着实机验证通过。setup 成功回执、清理归属和残留核验仍须运行时实现及单独授权。

原 `at_action_modify_b` 保持 conditional；覆盖账本原三个 grouped/open_question 单元没有变成 atomic 或 mapped。新四条细分事实只链接已有真实行范围，没有借这一个候选宣布依赖重建、统计刷新、IDENTITY、加密或泛化转换全部覆盖。
