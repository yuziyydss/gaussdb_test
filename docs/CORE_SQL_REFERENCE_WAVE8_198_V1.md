# SQL Reference Wave 8-198 Extraction V1

## 目标

抽取 MySQL兼容B模式系统函数：`4.4.3.2 系统函数`（流量控制/日期时间/字符串/强制转换/加密/信息/JSON/聚合/数字操作，表4-179~4-187，页 3525–3546）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 21 |
| 结构化 facts | 21 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 概述：绝大多数兼容/精度丢失问题
- 流量控制（表4-179）：IF/IFNULL/NULLIF/ISNULL类型推导与返回差异
- 日期时间（表4-180）：公共差异（NULL入参/纯数字/运算范围/0月0日/numeric非法/精度/分隔符/varchar返回）；ADDTIME/SUBTIME返回值矩阵；CURRENT_TIME等精度四舍五入vs截断/末尾0/256求余；PERIOD_ADD/DIFF回绕差异；STR_TO_DATE/UNIX_TIMESTAMP返回类型；MAKETIME自嵌套/UTC_DATE无括号/UTC_TIME隐式输入
- 字符串（表4-181）：BIN/CONCAT/CONCAT_WS/ELT/FIELD/FIND_IN_SET/INSERT/QUOTE/SPACE/STRCMP差异
- 强制转换（表4-182）：CAST/CONVERT以GaussDB转换范围为准
- 加密（表4-183）：AES_DECRYPT/AES_ENCRYPT支持
- 信息（表4-184）：LAST_INSERT_ID支持
- JSON（表4-185）：转义/精度/JSON_SEARCH返回差异
- 聚合（表4-186）：GROUP_CONCAT/DEFAULT差异
- 数字操作（表4-187）：log2/log10/RAND差异
