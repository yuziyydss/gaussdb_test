# SQL Reference Wave 8-172 Extraction V1

## 目标

抽取 高级包第二十四批切片：`3.12.2.23 DBE_XMLDOM` 尾段（NEWDOMDOCUMENT/SET*/WRITE*/会话诊断/GETELEMENTSBYTAGNAME，页 3028–3045，DBE_XMLDOM 收官）+ DBE_LOB 页 2792 历史缝隙补漏。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 两个切片：2792、3028–3045） |
| 物理页 | 19 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 页2792补漏：BFILENAME示例收尾（GET_LENGTH=8、READ 0123、多接口ERASE/COPY流程）
- NEWDOMDOCUMENT三原型（无参/XMLType/CLOB）与2GB/外部DTD/UTF-8默认/独立doc限制
- SETATTRIBUTE双原型（含ns覆盖语义基线50cm→55cm）
- SETCHARSET（60字节、16种支持字符集清单）、SETDOCTYPE（32500字节、PUBLIC/sysid输出基线）
- SETNODEVALUE（空值不改、'&'清空、32767上限）
- WRITETOBUFFER（1GB）/WRITETOCLOB（2GB）/WRITETOFILE四原型（255/60字节、pg_directory、safe_data_path）
- 会话诊断三函数（GETSESSIONTREENUM含FREE*统计口径、GETDOCTREESINFO、GETDETAILDOCTREEINFO）
- GETELEMENTSBYTAGNAME三原型（*通配）与三组嵌套cpu基线

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_172_oq_runtime` | NEWDOMDOCUMENT的2GB入参限制在接近边界时的报错形态、SETNODEVALUE含'&'清空节点值是否可恢复、WRITETOFILE多字符集输出的实际编码校验、GETSESSIONTREENUM对FREE*后dom树的统计口径需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_172_v1.yaml
generated/core_sql_reference_wave8_172_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_172.py
python scripts/build_core_sql_reference_wave8_172.py --check
python -m unittest tests.test_core_sql_reference_wave8_172 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作XML文档或文件。
