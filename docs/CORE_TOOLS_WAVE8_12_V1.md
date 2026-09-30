# Tools Wave 8-12 Extraction V1

## 目标

抽取 `5.3 数据库连接工具`，补齐 `gsql` 连接、脚本执行、变量代换、输出控制和元命令能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.3` | 52 | 数据库连接工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 52 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- `gsql` 连接边界和超时
- SQL/文件执行和元命令
- 变量设置、SQL代换、历史记录
- 常用命令行选项 `-c/-f/-l/-1/-A/-o/-t`
- 连接参数 `-h/-p/-U/-W/-d`
- 元命令PATTERN规则
- `\dp`权限代码

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_12_oq_runtime` | `gsql`连接超时、历史记录、变量代换和输出控制在真实客户端环境下的行为矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_12_v1.yaml
generated/core_tools_wave8_12_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_12.py
python scripts/build_core_tools_wave8_12.py --check
python -m pytest -q tests/test_core_tools_wave8_12.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行gsql。
