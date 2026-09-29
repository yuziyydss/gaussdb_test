# Core Other System Internal Functions Wave 7-10 Extraction V1

## 目标

抽取 `1.6.60 其他系统函数` 第二阶段：页1076开始的实现内部功能函数，完成该章静态抽取。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 1076–1114，共39页 |
| 结构化 facts | 38 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 38 / 38 |

## 覆盖内容

按函数族覆盖实现内部功能的函数：

- 云负载、locktag、smgr和4字节xid函数
- SQL job、FDW校验、nvarchar typmod和正则辅助函数
- 枚举比较、边界、输入函数
- 节点信息、buffer cache和xid limit检查
- 线程池、流线程池、外部监听和libcomm FD/内存函数
- 通信延迟、收发流、通信状态和日志状态
- CLOG解析、连接池探测和备份标志
- Psort和xid比较函数
- 跨region walsender、DBLink事务状态、xmin/relname查询
- COPY summary创建
- int1/int2/int4/int8/int16/numeric跨类型Btree比较与hash
- timestamp I/O
- datea比较、加法、减法、取大/取小和I/O
- rowid比较与I/O
- 关系/列可更新性、依赖源转换、hash分区命中
- 在线DDL清理
- nesttable和indexbytable的I/O、计数、删除、比较、集合运算、扩展、导航和裁剪
- 分区临时表filenode修复与反斜杠处理

关键边界：

- 这些函数属于实现内部功能的函数，不推荐使用。
- `pv_compute_pool_workload`当前版本已不再支持。
- `mq_sync`等同步函数不在本批；仅覆盖本批页范围内的内部函数族。
- 不推断未在源文给出的权限、返回矩阵和实机行为。

## Open questions

| ID | 内容 |
|---|---|
| `internal_wave7_10_oq_comm_threadpool_matrix` | 锁标签、通信、监听、线程池和流线程池在不同节点角色、负载和异常状态下的输出矩阵 |
| `internal_wave7_10_oq_type_collection_matrix` | 跨类型Btree比较、datea/rowid运算、nesttable和indexbytable在类型边界、NULL、下标和并发下需实机验证 |

## 产物

```text
docs/compat_facts/core_other_system_internal_wave7_10_v1.yaml
generated/core_other_system_internal_wave7_10_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_other_system_internal_wave7_10.py
python scripts/build_core_other_system_internal_wave7_10.py --check
python -m pytest -q tests/test_core_other_system_internal_wave7_10.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不调用内部函数、不修改线程池、不解析锁/CLOG、不执行集合运算。
- 不宣称目标环境行为验证通过。
