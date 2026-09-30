# Core Ledger, Encrypted, SRF and Overload Wave 6-4 Extraction V1

## 目标

细抽并一次性完成4个相邻章节：

```text
1.6.21 账本数据库的函数
1.6.22 密态函数和操作符
1.6.23 返回集合的函数
1.6.24 重载查询函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 4 |
| 物理页并集 | 534–553，共20页 |
| 结构化 facts | 29 |
| Open questions | 3 |
| Source resolved | 4 / 4 |
| Facts bound to scope | 29 / 29 |

## 覆盖内容

### 账本数据库

- `get_dn_hist_relhash`
- `ledger_hist_check`
- `ledger_hist_repair`
- `ledger_hist_archive`
- `ledger_gchain_check`
- `ledger_gchain_repair`
- `ledger_gchain_archive`
- `hash16in / hash16out / hash32in / hash32out`

关键边界：

- `get_dn_hist_relhash`集中式暂不支持。
- 历史表归档到审计日志目录`hist_back`下。
- 历史表名中的`/`会在归档文件名中替换为`_`。
- `hash32in`要求输入32个十六进制字符。

### 密态函数和操作符

覆盖密态等值类型的I/O、比较、HLL hash、排序选择率、聚合、确定性加解密和类型转换加解密。

关键边界：

- `sum`和`avg`支持密文聚合；`min`、`max`、样本/总体标准差和方差当前不支持。
- `tee_trans`、`tee_collect`、`tee_final`为内部函数，不支持用户调用。
- `security_tee_process`当前版本不支持使用。
- 确定性加解密密钥OID来自`gs_column_keys.column_key_distributed_id`。
- 确定性加解密仅在开启内存解密逃生通道时使用；NULL入参返回NULL。
- 类型转换加解密函数不支持用户调用。
- 密文I/O函数会验证本地CEK；本地无对应CEK或数据不是正常密文格式时报错。

### 返回集合的函数

- SRf通用语义
- `generate_series`
- `gs_search_function_with_name`
- `generate_subscripts`

关键边界：

- 任意函数入参列表中存在多个SRF会报错。
- 多层嵌套SRF返回乘积行数。
- strict非SRF函数的输入包含SRF时不做strict优化。
- step为0报错；方向不符或NULL输入返回零行。
- 数组无请求维度或数组为NULL时`generate_subscripts`返回零行。

### 重载查询

- `gs_search_function_with_name_and_arg`
- `gs_search_operator_with_name_and_arg`

关键边界：

- 两者均仅在A兼容模式支持。
- NULL入参须用`UNKNOWN`替代。
- 窗口函数查询须加`over()`。
- 操作符查询仅支持二元操作符；`!=`和`^=`须用`<>`替代。
- 语法关键字实现的函数无法通过函数查询，文档表1-97提供内部调用映射。
- 函数、操作符或选择逻辑变更可能导致结果变化。

## Open questions

| ID | 内容 |
|---|---|
| `ledger_encrypted_wave6_4_oq_ledger_matrix` | 账本校验、修复、归档和hash转换在真实防篡改表、历史表损坏与归档权限下的行为矩阵 |
| `ledger_encrypted_wave6_4_oq_encrypted_matrix` | 密态I/O、比较、聚合、确定性加解密和CEK验证在不同密钥、客户端模式和NULL边界下的行为矩阵 |
| `ledger_encrypted_wave6_4_oq_srf_overload_matrix` | 序列、下标和重载查询在不同类型、NULL/UNKNOWN、窗口函数和兼容GUC下的输出矩阵 |

## 产物

```text
docs/compat_facts/core_security_ledger_wave6_4_v1.yaml
generated/core_security_ledger_wave6_4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_security_ledger_wave6_4.py
python scripts/build_core_security_ledger_wave6_4.py --check
python -m pytest -q tests/test_core_security_ledger_wave6_4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不修复或归档账本、不操作密钥/密文、不生成序列、不查询重载结果。
- 不宣称目标环境行为验证通过。
