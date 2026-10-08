# SQL Reference Wave 8-148 Extraction V1

## 目标

抽取 高级包第七批切片：`3.12.2.3 DBE_COMPRESSION`（压缩评估）与 `3.12.2.4 DBE_DESCRIBE`（参数描述）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2722–2734，含两个完整小节） |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_COMPRESSION六接口全原型：GET_COMPRESSION_RATIO（COMPTYPE 1-6枚举、SAMPLE_RATIO 0-100默认20、CMP_RATIO=UNCMP/CMP、跨页透明压缩ROW_*为0）、GET_COMPRESSION_TYPE（1/2、运维类不做可见性判断、跨页透明压缩默认1）、GET_ACTUAL_COMPRESSION_RATIO（仅跨页透明、FILE_COUNT含cmap、小表压缩比<1正常）、GET_HOLE_RATIO（仅数据文件）、TURBO_COMPRESS_BUFFER_STATS（10个OUT指标）、GET_INDEX_COMPRESSION_TYPE（i/I/x、小数四舍五入、查不到跨页透明）
- 分区传名限制、ILM前置（set ilm=on、ADVANCED/TURBO策略）、两类压缩口径对比
- 示例基线（高级压缩表GET_COMPRESSION_TYPE=1、RATIO输出1.0/Compress Advanced）
- DBE_DESCRIBE：NUMBER_TABLE/VARCHAR2_TABLE内置类型；DESCRIBE_PROCEDURE全参数语义（overload递增/dataposition函数0起存储过程1起/in_out 0,1,2/default_value/radix）；datatype OID与A差异；九条使用限制（Package报错、无权限报错、DBLINK禁用、bind_procedure_searchpath、%type不保留约束）
- 重载示例基线（三签名TEST_FUNC_OVERLOAD逐个describe与DROP）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_148_oq_runtime` | GET_COMPRESSION_RATIO采样率在0与100边界的行为、TURBO_COMPRESS_BUFFER_STATS回收步长与等待次数的调优含义、DESCRIBE_PROCEDURE对INOUT参数in_out编码（2）在重载签名下的区分需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_148_v1.yaml
generated/core_sql_reference_wave8_148_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_148.py
python scripts/build_core_sql_reference_wave8_148.py --check
python -m unittest tests.test_core_sql_reference_wave8_148 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不评估压缩率或执行describe。
