# Core Network and Sequence Wave 7-4 Extraction V1

## 目标

细抽并完成两个早期通用函数章节：

```text
1.6.11 网络地址函数和操作符
1.6.15 SEQUENCE函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 2 |
| 物理页并集 | 392–397与439–442，共10页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 2 / 2 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 网络地址

覆盖 `cidr/inet` 比较、子网包含测试、位运算、地址加减、显示格式、地址族、主机地址、主机/子网掩码、网络地址、掩码长度转换以及 `macaddr` 截断、排序和位运算。

关键边界：

- `<< / <<= / >> / >>=`只比较地址网络部分，忽略主机部分。
- `family=4`表示IPv4，`family=6`表示IPv6。
- cidr可显式或隐式转换为inet；inet转cidr时掩码右侧所有位转为零。
- 本地地址和文本转换函数均适用于cidr/inet。

### SEQUENCE

覆盖 `nextval`、`currval`、`lastval`、`setval`两个重载、序列当前值/参数查询函数，以及 `last_insert_id`两个重载。

关键边界：

- `nextval`不回滚，可能留下序列空洞；仅主机可执行。
- 插入语句同时含SRF函数和序列自增列时，序列值会跳数一位。
- rowid系统列序列的 `nextval` 仅支持维护模式。
- `currval`未在当前会话调用过指定序列时报错。
- `setval`当前会话立即生效且本地缓存失效；其他会话缓存需用尽后感知。
- `setval`修改不可回滚；rowid系统列序列仅维护模式可修改。
- `last_insert_id`为会话级函数，仅B兼容模式可用。

## Open questions

| ID | 内容 |
|---|---|
| `network_sequence_wave7_4_oq_network_matrix` | 网络比较、子网、位运算、掩码转换和macaddr函数在IPv4/IPv6、边界掩码和非法输入下的输出矩阵 |
| `network_sequence_wave7_4_oq_sequence_matrix` | 序列函数在并发事务、SRF混合插入、序列缓存、备机和rowid维护模式下需实机验证 |

## 产物

```text
docs/compat_facts/core_network_sequence_wave7_4_v1.yaml
generated/core_network_sequence_wave7_4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_network_sequence_wave7_4.py
python scripts/build_core_network_sequence_wave7_4.py --check
python -m pytest -q tests/test_core_network_sequence_wave7_4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不推进序列、不修改序列值、不执行网络运算或转换。
- 不宣称目标环境行为验证通过。
