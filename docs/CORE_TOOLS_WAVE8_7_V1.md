# Tools Wave 8-7 Extraction V1

## 目标

抽取 `5.10 安全工具`，补齐 `gs_encrypt` 和 `gs_sdf_checker` 的静态事实。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.10` | 3 | 安全工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 3 |
| 结构化 facts | 10 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- `gs_encrypt` 命令、key/vector/明文限制
- cipher/rand 文件前缀和 base64 输入
- 历史记录安全建议
- 随机IV导致的密文不可复现
- `gs_sdf_checker` 检测sdf_kms动态库

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_7_oq_runtime` | `gs_encrypt`边界值、随机IV输出与`gs_sdf_checker`在真实sdf_kms动态库下的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_7_v1.yaml
generated/core_tools_wave8_7_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_7.py
python scripts/build_core_tools_wave8_7.py --check
python -m pytest -q tests/test_core_tools_wave8_7.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行安全工具。
