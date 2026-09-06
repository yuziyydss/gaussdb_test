# 模型包输入契约：已实现与保留边界

2026-09-06，静态阶段。范围仅为本地 PDF 的 CREATE MODEL、PREDICT BY 示例；
没有创建、训练、预测或删除任何模型，没有数据库执行。

## 本批可检查的东西

两个包现在引用同一个 `fixture_create_model_training_input`，没有重复维护八列十五行。
fixture 通过现有 V1 `factor_ref: null` 共享；保留原 ID、目录和所有生命周期 SQL。
CREATE MODEL 仍保存原始示例事实，PREDICT BY 引用明确导出的事实，依赖关系不靠相同表名猜测。

| 消费位置 | 有序输出 | 用途与限制 |
| --- | --- | --- |
| CREATE MODEL 输入投影场景 | size INTEGER、lot INTEGER、mark TEXT | 前两列为本示例 FEATURES，末列为 TARGET；不训练 |
| PREDICT BY 输入投影场景 | size INTEGER、lot INTEGER | 保持示例 FEATURES 顺序，不把 TARGET 混入；不调用预测 |

两场景均为 `planned`，各自含真实只读 SELECT、精确列定义、按 id 排序的十五行
投影哈希与回滚结果要求。测试使用已有有限投影/类型检查函数，并核对 fixture 声明、
SQL、顺序与 seed 投影；这不是新增通用模型签名接口，也不是数据库 Oracle 已执行。

两列恰好同为 INTEGER 不能证明交换后语义不变，因此这里同时固定列名、顺序、
精确类型和数据投影，而不只比较类型族。nullable 来自示例 DDL，不被改为 NOT NULL；
样本恰好没有空值不等于产品列不可空。

## 来源

- CREATE MODEL 正文 L27–32 定义 FEATURES/TARGET，L202–230 为表与 seed，L232–237 为训练示例。
  章节 SHA256：`4541a1701fad83234a3982934035b7d0255775dca7c28fbf254c222e9f0f06da`。
- PREDICT BY 正文 L5 要求训练完成的模型，L8 指出系统目录，L55–63 的示例使用相同训练/预测特征。
  章节 SHA256：`60f4f34e6eb3ecbd5a623d79b997d5d70b0f541d63f5e8578d568b9fa7353915`。
- DROP MODEL 正文说明删除已训练保存的模型；不能以未成功创建的名字直接生成无条件清理。

示例只用于构造有限一致性样本，不提升为所有算法必须有两个整数特征或 TEXT 目标。
无序查询不得直接对返回顺序取哈希；哈希 Oracle 单独指定 `ORDER BY id` 和 JSON 编码。

## 为什么还没有普通模型清单

1. CREATE MODEL 的四个训练器仍为 conditional，当前 V1 正向清单禁止直接绑定。
   不通过改 validity、换 suite 或环境标记绕过。
2. 真实模型资产尚缺成功创建记录、唯一身份/所有权、算法及有序特征签名、资源预算和清理证据。
   表、fixture、投影和固定模型名均不能替代模型资产。
3. 文档正文只列四个算法，超参表又出现其他算法；原有来源冲突保留。
4. 训练预算不能照搬文档的 `statement_timeout=0` 建议。任何未来训练须另外授权有限预算；
   超时是本次试验未完成，不自动证明算法不支持。
5. 预测结果标签/概率没有本次实际训练证据，不填造期望输出。

下阶段的模型身份/签名契约应与公共模型评审一起处理，不能把 planned 场景的自由字段
当成已存在的执行器协议。当前收获是共享输入与明确可测试的输入 Oracle 蓝图，
不是 56 个无普通清单包中的模型包已经闭环。

## 复核入口

`tests.test_model_input_shapes` 核对两包输入投影与共享依赖；
`tests.test_package_closure_batch` 保留原始十五行和 INSERT 条件值门禁测试。
最新本批回执与完整用例对账位于 `work/evening_2026_09_06/model_shape_batch/`。
