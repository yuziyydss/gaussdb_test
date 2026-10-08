# SQL Reference Wave 8-155 Extraction V1

## 目标

抽取 高级包第十四批切片：`3.12.2.11 DBE_MATCH`（编辑距离相似度）与 `3.12.2.12 DBE_OBFUSCATION_TOOLKIT`（DES/DES3/MD5兼容加解密）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2793–2800，两个完整小节） |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_MATCH：EDIT_DISTANCE_SIMILARITY（0~100归一化、null直接输出0）
- DBE_OBFUSCATION_TOOLKIT：安全警告（DES/DES3/MD5不安全）、七接口总账、VARCHAR2/RAW双原型设计
- DESGETKEY/DES3GETKEY（种子≥80字节、随机密钥、which 0=16字节/1=24字节密钥）
- DESENCRYPT/DESDECRYPT（input 8字节倍数、key≥8字节超长不影响）、DES3ENCRYPT/DES3DECRYPT（key依赖which 16/24字节、iv非NULL须8字节倍数）
- 八组示例基线（含具体十六进制输出与WARNING上下文）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_155_oq_runtime` | EDIT_DISTANCE_SIMILARITY对多字节字符按字符还是字节计步、DES/DES3填充模式（ECB/CBC）与iv的完整语义、相同种子多次调用DESGETKEY的随机性范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_155_v1.yaml
generated/core_sql_reference_wave8_155_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_155.py
python scripts/build_core_sql_reference_wave8_155.py --check
python -m unittest tests.test_core_sql_reference_wave8_155 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行加解密操作。
