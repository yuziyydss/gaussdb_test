# Tools Wave 8-14 Extraction V1

## 目标

抽取 `5.7 数据导入导出工具`，补齐 `COPY`、`gs_loader`、`gs_dump`、`gs_dumpall`、`gs_restore` 的能力与边界。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.7` | 55 | 数据导入导出工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 55 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- `COPY` / `\COPY` 范围
- `gs_loader` 版本、日志级别和三权分立
- `gs_dump` 导出格式、data-only、clean/create、并行导出
- `gs_dumpall` 实例级导出和 gsql 恢复
- `gs_restore` 恢复方式、并行能力与格式限制

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_14_oq_runtime` | 大规模数据、复杂依赖和并行边界下的导入导出行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_14_v1.yaml
generated/core_tools_wave8_14_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_14.py
python scripts/build_core_tools_wave8_14.py --check
python -m pytest -q tests/test_core_tools_wave8_14.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行导入导出工具。
