# SQL Reference Wave 8-108 Extraction V1

## 目标

抽取 M 兼容 `COPY`（2.4.2.8.5，10 页单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- COPY FROM/TO方向语义、enable_copy_server_files权限模型、safe_data_path白名单
- 字段列表与生成列行为（TO排除/FROM自动更新）
- STDIN/STDOUT协议（TAB分隔、\\.结束、\\N转义）、并行导入STDIN风险
- 预处理不支持与临时表中转方案、低并发定位
- COPY服务端 vs \\COPY客户端、云上路径规则、extra_float_digits=3建议
- 三种语法形式与option/copy_option双参数体系全清单
- LOG ERRORS容错（DATA_EXCEPTION）、SKIP_CONSTRAINT_ERRORS五类约束冲突及性能劣化
- LOG ERRORS DATA super权限与rawrecord限制、REJECT LIMIT计数规则
- FORMAT CSV/TEXT/BINARY差异、DELIMITER多字符≤10字节推荐、NULL/HEADER/QUOTE/ESCAPE
- SKIP/LIMIT/STARTS/WHEN/SEQUENCE行控制
- ship_mode导入导出七组示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_copy_wave8_108_oq_runtime` | safe_data_path白名单与相对路径报错行为、SKIP_CONSTRAINT_ERRORS在大量约束冲突下的性能劣化边界、LOG ERRORS DATA写入容错表失败场景需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_108_v1.yaml
generated/core_sql_reference_wave8_108_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_108.py
python scripts/build_core_sql_reference_wave8_108.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_108.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容COPY语句。
