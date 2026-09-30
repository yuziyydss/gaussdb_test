# Tools Wave 8-16 Extraction V1

## 目标

抽取 `5.11 统一数据库管理工具`，补齐 `cm_ctl`、CM组件职责、状态查询、启停、倒换、build 和安全/日志能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.11` | 80 | 统一数据库管理工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 80 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CM组件：OMM、ETCD/DDB、CMA、CMS、DN
- 集群状态和详细状态查询
- 启停、主备倒换、build重建备DN
- 进程状态检测
- CM参数设置/获取/动态加载
- CM热补丁、加密、安全证书

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_16_oq_runtime` | CM组件故障、仲裁切换、build、容灾和证书场景下的真实行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_16_v1.yaml
generated/core_tools_wave8_16_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_16.py
python scripts/build_core_tools_wave8_16.py --check
python -m pytest -q tests/test_core_tools_wave8_16.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行cm_ctl。
