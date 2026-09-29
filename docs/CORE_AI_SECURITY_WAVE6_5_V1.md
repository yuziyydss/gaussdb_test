# Core AI, Sensitive Data, Masking and Hierarchy Wave 6-5 Extraction V1

## 目标

细抽并一次性完成4个相邻章节：

```text
1.6.35 AI特性函数
1.6.36 敏感数据发现函数
1.6.37 动态数据脱敏函数
1.6.38 层次递归查询函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 4 |
| 物理页并集 | 909–918，共10页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 4 / 4 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### AI特性

- 索引推荐与虚拟索引：`gs_index_advise`、`hypopg_create_index`、`hypopg_display_index`、`hypopg_drop_index`、`hypopg_reset_index`、`hypopg_estimate_size`
- 计划编码：`encode_plan_node`、`encode_feature_perf_hist`、`gather_encoding_info`
- 模型推断：`db4ai_predict_by_*`
- 模型解释与智能统计：`gs_explain_model`、`gs_ai_stats_explain`
- 反馈基数与代价模型：ACM反馈、代价校准、代价参数
- AutoHint与多计划缓存
- AI Watchdog
- LLM语义分析、向量和重排序

关键边界：

- `encode_plan_node`是内部功能，不建议用户直接使用。
- `db4ai_predict_by_*`是内部调用函数，建议使用`PREDICT BY`语法。
- AI Watchdog函数需要`SYSADMIN`或`MONADMIN`权限。
- `gs_show_aplan`暂不支持`explain_perf_mode=pretty`。

### 敏感数据发现

- `gs_sensitive_data_discovery`
- `gs_sensitive_data_discovery_detail`

关键边界：

- `scan_target`必须是schema、table或column，并包含上级名称。
- `scan_classifier`支持email、creditcard、phonenumber、chinesename、encryptedcontent；可逗号多选或`all`。

### 动态数据脱敏

- `creditcardmasking`
- `basicemailmasking`
- `fullemailmasking`
- `alldigitsmasking`
- `shufflemasking`
- `randommasking`
- `regexpmasking`

关键边界：

- 各函数分别处理信用卡、邮箱、数字、乱序、随机和正则脱敏。
- `regexpmasking`的`pos`默认0，`reg_len`默认-1。

### 层次递归查询

- `sys_connect_by_path`
- `connect_by_root`

关键边界：

- 两个函数仅在层次递归查询中适用。
- `sys_connect_by_path`返回根节点到当前行路径，不支持表达式列。
- `connect_by_root`返回顶层父亲行指定列值；列类型必须在白名单内，强转不能绕过限制。

## Open questions

| ID | 内容 |
|---|---|
| `ai_wave6_5_oq_model_matrix` | AI推荐、推断、校准、AutoHint、Watchdog和LLM函数在不同权限、模型状态和负载下的输出矩阵 |
| `ai_wave6_5_oq_discovery_masking_hierarchy` | 敏感数据发现、脱敏和层次递归函数在数据形态、分类器、递归路径和白名单类型下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_ai_security_wave6_5_v1.yaml
generated/core_ai_security_wave6_5_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_ai_security_wave6_5.py
python scripts/build_core_ai_security_wave6_5.py --check
python -m pytest -q tests/test_core_ai_security_wave6_5.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不训练模型、不执行推断、不创建虚拟索引、不扫描敏感数据、不验证脱敏结果、不执行层次递归查询。
- 不宣称目标环境行为验证通过。
