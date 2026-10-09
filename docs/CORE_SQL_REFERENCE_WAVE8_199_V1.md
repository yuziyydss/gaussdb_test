# SQL Reference Wave 8-199 Extraction V1

## 目标

抽取 MySQL兼容B模式其他函数/操作符/字符集/排序规则/表达式：`4.4.3.2.11 其他函数` + `4.4.3.3 操作符` + `4.4.3.4 字符集` + `4.4.3.5 排序规则` + `4.4.3.6 表达式`（表4-188~4-191，页 3546–3549）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5（完整节合并） |
| 物理页 | 3 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 其他函数（表4-188）：UUID()/UUID_SHORT()支持
- 操作符（表4-189）：概述/安全等于<=>支持/[NOT] REGEXP与[NOT] RLIKE差异（转义字符/\\b/右单括号/|空值/[:blank:]/非贪婪/BINARY BYTEA）
- 字符集（表4-190）：utf8mb4/gbk/gb18030/utf8/binary
- 排序规则（表4-191）：binary/gb18030系列/gbk系列/utf8系列/utf8mb4系列11种；仅字符串/部分二进制支持；对应字符集与库级一致限制；utf8mb4默认general_ci；utf8=utf8mb4
- 表达式概述
