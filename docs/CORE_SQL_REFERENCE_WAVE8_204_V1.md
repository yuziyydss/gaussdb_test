# SQL Reference Wave 8-204 Extraction V1

## 目标

抽取 GUC安全和认证：`7.3.3.2 安全和认证`（页 4181–4197）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 16 |
| 结构化 facts | 13 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 监听线程：enable_server_listener_thread
- 认证：authentication_timeout/auth_iteration_count/session_authorization/session_timeout/idle_in_transaction_timeout
- SSL：ssl/require_ssl/ssl_ciphers/ssl_renegotiation_limit（已禁用）/ssl_cert_file/ssl_key_file/ssl_enc_cert_file/ssl_enc_key_file/ssl_ca_file/ssl_crl_file/enable_shared_sslctx/ssl_cert_notify_time
- Kerberos：krb_server_keyfile/krb_srvname/krb_caseins_users
- 密码策略：modify_initial_password/password_policy/password_reuse_time/password_reuse_max/password_lock_time/failed_login_attempts/enable_lock_account/password_encryption_type（md5/sha256/sm3/FIPS）/password_min_length/password_min_uppercase/lowercase/digital/special/password_effect_time/password_notify_time/enable_innertool_cert
