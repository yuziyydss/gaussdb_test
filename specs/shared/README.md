# Shared V1 Specifications

这里仅保存被多个 factor package 共同引用、且语义完全相同的 fixture 或 matrix。

共享前必须满足：

- 至少有两个因子包实际使用。
- profile 名称表达对象能力，不绑定某条 SQL 的偶然表名。
- 产品规则仍归属各自 factor；不能为了复用把规则搬进 shared。

只有单个语句使用的内容应保留在该语句目录中，避免过早抽象。
