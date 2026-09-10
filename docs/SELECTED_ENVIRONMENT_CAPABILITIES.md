# 实际选中值的环境前提

`required_compatibility_modes` 已对实际渲染的维度值检查兼容模式。本轮在同一入口增加可选的 `properties.required_environment_capabilities`，避免关键字禁用和升级阶段等前提仅出现在说明里。

```yaml
properties:
  required_compatibility_modes: [A]
  required_environment_capabilities:
    disable_keyword_options_state: [empty]
    upgrade_phase: [not_upgrading]
```

这只是既有 `properties` 字典中的内部消费者合同，没有增加或放宽 Factor Package V1 公共模型字段。要求的键与取值均为非空字符串；集合不能为空或重复。对每个已消费维度，manifest必须恰有一个同名environment requirement，且允许值只能等于或收窄该值的要求。缺失、重复或扩大门均生成失败。未消费的产生式分支不额外约束候选，不把条件注入Pairwise求解域，也不改写预期。

首个消费者是一般CREATE INDEX的两个可见性受限代表：

- compatibility_mode=A：本地PDF的VISIBLE/INVISIBLE均仅A模式可用。
- disable_keyword_options_state=empty：表示执行前应核对实际GUC为空字符串；`empty`不是GUC字面量，也不是已经探测到环境。使用显式状态是因为V1环境门禁止空值。
- upgrade_phase=not_upgrading：本批仅在完全非升级中的环境准入；正文禁止升级未提交阶段，不据此把其他阶段一概称为产品不支持。

候选使用独占fresh用户schema内的普通ASTORE表和整数BTREE；无预DROP/CASCADE，无GUC修改。普通条件取值继续保留，窄代表不冒充全部模式/参数/升级组合覆盖。元数据接口、关键字负向SQLSTATE、查询计划和实际对象所有权仍须独立验证。

生成器只检查**声明一致性**。执行阶段必须获得授权、提供真实环境能力，再通过原有环境预检；本轮没有连接或执行数据库。
