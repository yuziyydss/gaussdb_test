# SQL Reference Wave 8-86 Extraction V1

## 目标

抽取 C 族第四批：`CREATE CAST`、`CREATE CLIENT MASTER KEY`、`CREATE COLUMN ENCRYPTION KEY` 与 `CREATE CONVERSION`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.12` | 3 | CREATE CAST |
| `1.13.9.13` | 4 | CREATE CLIENT MASTER KEY |
| `1.13.9.14` | 2 | CREATE COLUMN ENCRYPTION KEY |
| `1.13.9.15` | 2 | CREATE CONVERSION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- CREATE CAST三种转换（WITH FUNCTION/WITHOUT FUNCTION/WITH INOUT）、AS ASSIGNMENT/AS IMPLICIT、1~3参数转换函数签名、域类型限制、以调用者权限执行的越权风险
- double precision→timestamptz转换行为基线
- CREATE CLIENT MASTER KEY多级加密模型、全密态特有语法、三类外部密钥管理者（hcs_kms/user_token/sdf_kms）
- KEY_STORE/KEY_PATH/ALGORITHM参数与表1-374取值矩阵
- user_token场景行为基线（gsql_env.sh、-C、\key_info、AES_256_GCM）
- CREATE COLUMN ENCRYPTION KEY用途与-C开关、CEK算法七种与膨胀率推荐、ENCRYPTED_VALUE 28~256字符、国密配套约束、KMS 16字节整数倍
- CREATE CONVERSION内部功能定位、DEFAULT双向转换、SQL_ASCII排除、EXECUTE/CREATE权限
- conv_proc函数签名

## Open questions

| ID | 内容 |
|---|---|
| `create_cast_wave8_86_oq_runtime` | CREATE CAST三种转换形式、全密态CMK/CEK多级加密（各KEY_STORE与算法组合约束）和CREATE CONVERSION编码转换在真实驱动配置、权限和密钥服务场景下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_86_v1.yaml
generated/core_sql_reference_wave8_86_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_86.py
python scripts/build_core_sql_reference_wave8_86.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_86.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CAST/密钥/编码转换语句。
