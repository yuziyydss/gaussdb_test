# SQL Reference Wave 8-201 Extraction V1

## 目标

抽取 Oracle兼容PL/SQL静态SQL/动态SQL/Trigger/子程序：`4.3.10.5 静态SQL` + `4.3.10.6 动态SQL` + `4.3.10.7 Trigger` + 子程序（表4-69~4-88，页 3196–3206）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整节合并） |
| 物理页 | 10 |
| 结构化 facts | 14 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 静态SQL（表4-69~4-76）：INSERT/INSERT ALL目标列多于子查询差异/TCL SET TRANSACTION不支持语法/伪列ROWNUM JOIN风险/隐式游标commit后刷新差异/显式游标CLOSE exception差异/FORALL BULK COLLECT INTO差异/自治事务支持
- 动态SQL（表4-77）：EXECUTE IMMEDIATE（dynamic_sql_compat/匿名块绑定/RETURNING不支持）；OPEN FOR FETCH CLOSE
- Trigger（表4-78~4-82）：类型不支持Compound/System；CREATE TRIGGER不支持子句/schema/trigger_body限制/INSTEAD OF限制；ALTER/DROP TRIGGER差异/视图差异
- 子程序（表4-82~4-88）：nested subprogram不支持重载/自治事务/SETOF；DETERMINISTIC→IMMUTABLE/PARALLEL_ENABLE/PIPELINED/RESULT_CACHE不支持；CREATE/ALTER/DROP FUNCTION/PACKAGE/PROCEDURE/TRIGGER/TYPE/LIBRARY差异
