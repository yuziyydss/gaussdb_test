# SQL Reference Wave 8-138 Extraction V1

## 目标

抽取 存储过程基础与声明语法批：`3.1 存储过程`、`3.2 数据类型（SUBTYPE）`、`3.3 数据类型转换` 与 `3.5 声明语法`（2.4.2 语句章收官后进入第 3 章的第一批；3.4/3.6-3.8 留待后续波次）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- 存储过程定位：SQL+PL/SQL组合、代码复用、与PL/SQL语言函数应用方法相同（3.1）
- XML类型入参/出参/自定义变量/返回值、自治事务存储过程
- SUBTYPE子类型：出入参/%type/%rowtype/嵌套更新约束/基类型类型构造器；A兼容限制、字符集不支持、升级未提交禁用
- SUBTYPE约束：typmod校验、RANGE仅int族且上限INT64、NOT NULL必须初始化；五组示例基线
- 隐式类型转换表：字符族、NUMBER/DATE/RAW/CLOB、INT4↔BOOLEAN、DATEA双向转换与nls_date_format约束、DATE效限范围
- PL/SQL块结构（DECLARE/AS等同、BEGIN必选、EXCEPTION可选、连续Tab禁用）
- 匿名块语法与分类、执行DDL的临时内存（SessionTempMemoryContext/ExecutorTopMemoryContext、max_dynamic_memory）
- 匿名块JDBC绑定参数：A兼容+Oracle风格、enable_ce=3/1差异、命名冲突、自治事务禁用、32767/1664上限、版本兼容矩阵（507.0.0/503.1.0、升级观察期）
- 子程序三类（独立/包内/嵌套）与嵌套子程序全量限制（max_subpro_nested_layers=3、无重载/SETOF/自治事务/PERFORM、修饰符白名单、单限定符、record返回列访问报错、声明位置、debugger限制）
- 嵌套子程序语法与调用/变量作用域规则（递归、上层/下层调用、变量查找顺序）

## Open questions

| ID | 内容 |
|---|---|
| `sp_decl_wave8_138_oq_runtime` | SUBTYPE RANGE约束与typmod变量级再约束的赋值校验边界、嵌套子程序max_subpro_nested_layers层数计算在深层嵌套下的行为、匿名块JDBC绑定参数在自治事务与全密态enable_ce组合场景需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_138_v1.yaml
generated/core_sql_reference_wave8_138_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_138.py
python scripts/build_core_sql_reference_wave8_138.py --check
python -m unittest tests.test_core_sql_reference_wave8_138 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行存储过程、匿名块或JDBC绑定参数场景。
