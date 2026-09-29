# Core Security Functions Wave 6-3 Extraction V1

## 目标

细抽 `1.6.20 安全函数`，覆盖：

```text
对称加解密与AES向量模式
摘要算法
密码有效期与提醒策略
登录审计
传统审计与统一审计
审计删除
数据脱敏内部函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 522–534，共13页 |
| 结构化 facts | 31 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 31 / 31 |

## 覆盖内容

### 加密与解密

- `gs_encrypt_aes128`
- `gs_encrypt`
- `gs_encrypt_bytea`
- `gs_decrypt_aes128`
- `gs_decrypt`
- `gs_decrypt_bytea`
- `aes_encrypt`
- `aes_decrypt`

关键边界：

- 常规加密口令长度为8–16字节，至少包含大写字母、小写字母、数字、特殊字符中的3类。
- `gs_encrypt_aes128`返回值至少92字节，上限为`4*[(Len+68)/3]`字节。
- `gs_encrypt`支持`aes128`、`sm4`、`aes128_cbc_sha256`、`aes256_cbc_sha256`、`aes128_gcm_sha256`、`aes256_gcm_sha256`、`sm4_ctr_sm3`。
- `gs_encrypt_bytea`不支持旧版`aes128`和`sm4`参数。
- `aes_encrypt` / `aes_decrypt`仅在B兼容模式有效；`block_encryption_mode`、密钥和IV必须匹配。
- 为安全起见，gsql不将包含这些函数名字样的SQL记入执行历史。

### 摘要

- `gs_digest`

关键边界：

- 输入字符串不能为`NULL`。
- 支持`SHA256`、`SHA384`、`SHA512`、`SM3`，大小写均可。
- 不支持的算法报错。

### 密码策略

- `gs_password_deadline`
- `gs_password_notifytime`
- `gs_password_lifetime`

关键边界：

- `gs_password_deadline`查询`password_effect_time`设置的到期时间。
- `gs_password_lifetime`查询账户自身设置的密码有效期；未设置时返回`-`。

### 登录与审计

- `login_audit_messages`
- `login_audit_messages_pid`
- `gs_query_audit`
- `pg_query_audit`
- `gs_query_unified_audit`
- `gs_delete_audit`
- `pg_delete_audit`

关键边界：

- `login_audit_messages(true)`查询上次成功登录；`false`查询其后失败尝试。
- `login_audit_messages_pid`基于backendid向前查找；线程池开启时不建议调用。
- 传统审计与统一审计在Non-PDB返回全部日志，PDB仅返回本PDB相关日志。
- 统一审计在传统审计字段外增加`policy_id`、`unified_audit_type`和`unified_audit_policy`。
- 审计删除函数在PDB内仅能删除本PDB相关时间段日志。

### 数据脱敏

- `alldigitsmasking`
- `creditcardmasking`
- `randommasking`
- `fullemailmasking`
- `basicemailmasking`
- `shufflemasking`

关键边界：

- 这些是脱敏策略内部函数。
- 分别覆盖全字符、信用卡、随机、完整邮箱、基础邮箱和乱序脱敏语义。

## Open questions

| ID | 内容 |
|---|---|
| `security_wave6_3_oq_crypto_matrix` | 加解密在不同encrypttype、block mode、IV、字符集、NULL和非法密钥下的输出与错误矩阵 |
| `security_wave6_3_oq_audit_masking_evidence` | 登录审计、传统/统一审计、审计删除和脱敏函数在真实负载、权限、PDB/Non-PDB和时间边界下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_security_wave6_3_v1.yaml
generated/core_security_wave6_3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_security_wave6_3.py
python scripts/build_core_security_wave6_3.py --check
python -m pytest -q tests/test_core_security_wave6_3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行加密/解密、不修改密码策略、不查询或删除审计日志、不验证脱敏结果。
- 不宣称目标环境行为验证通过。
