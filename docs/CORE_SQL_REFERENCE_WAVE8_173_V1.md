# SQL Reference Wave 8-173 Extraction V1

## 目标

抽取 高级包第二十四批切片：`3.12.2.24 DBE_XMLGEN`（SQL结果转XML，16接口，页 3045–3068）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3045–3068） |
| 物理页 | 23 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CTXHANDLE类型与session 65535上限（关闭不回收）、大小写一致规则、HIERARCHY三设置方法不生效说明
- CONVERT编码/解码（五条XML转义映射、FLAG 0/1）
- NEWCONTEXT双原型（VARCHAR2/SYS_REFCURSOR）、NEWCONTEXTFROMHIERARCHY（connect by递归、5000万层上限）
- SETCONVERTSPECIALCHARS（true/false与XML注入警告）、SETNULLHANDLING（0/1/2三模式基线）、USENULLATTRIBUTEINDICATOR（xsi:nil）、USEITEMTAGSFORCOLL（_item后缀）
- 分批机制：SETMAXROWS/SETSKIPROWS/GETNUMROWSPROCESSED/RESTARTQUERY
- GETXMLTYPE双原型/GETXML三原型（DTDORSCHEMA无意义）/CLOSECONTEXT
- rowset/row自定义tag基线（asd/qwe七行）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_173_oq_runtime` | CTXHANDLE 65535上限耗尽后的报错形态与session生命周期回收、SETCONVERTSPECIALCHARS=false时XML注入的实际防护边界、RESTARTQUERY重启用cursor重新执行的隔离级别语义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_173_v1.yaml
generated/core_sql_reference_wave8_173_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_173.py
python scripts/build_core_sql_reference_wave8_173.py --check
python -m unittest tests.test_core_sql_reference_wave8_173 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行SQL转XML。
