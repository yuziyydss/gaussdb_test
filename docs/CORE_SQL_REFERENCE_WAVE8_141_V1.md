# SQL Reference Wave 8-141 Extraction V1

## 目标

抽取 PL/SQL 控制语句收官批：`3.8 控制语句`（返回/条件/循环/分支/空语句/错误捕获/GOTO）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 返回：RETURN与RETURN NEXT/RETURN QUERY双方式（NEXT/QUERY仅函数）、SETOF、RETURN QUERY EXECUTE+USING；fun_for_return_next/query示例基线
- 条件：IF五种形式（THEN/ELSE/嵌套/ELSIF/ELSEIF别名）与END IF配对规则、proc_control_structure基线
- 循环：LOOP必须配EXIT、WHILE条件判定时机、FOR integer（自动变量/REVERSE边界）、FOR查询（target自动类型/EXECUTE+USING动态）、FORALL（index自动、SAVE EXCEPTIONS与%BULK_EXCEPTIONS、BULK COLLECT单条返回、仅DML）
- 分支：CASE WHEN参数与ELSE兜底（proc_case_branch基线333/999）
- 空语句：NULL占位符语义
- 错误捕获：EXCEPTION匹配/回滚/OTHERS/QUERY_CANCELED/handler新错误/局部变量原值等完整语义、三类不可捕获场景与隐式子事务、开销提示、division_by_zero与unique_violation upsert示例
- 诊断：GET STACKED DIAGNOSTICS五诊断项（22P02基线）、GET [CURRENT] DIAGNOSTICS（ROW_COUNT/RESULT_OID基线）
- GOTO：无条件跳转/Label唯一、六条限制场景（IF/CASE/LOOP内跳转、跨子句、内外块、异常部分、NULL语句占位）

## Open questions

| ID | 内容 |
|---|---|
| `sp_ctrl_wave8_141_oq_runtime` | SAVE EXCEPTIONS场景SQL%BULK_EXCEPTIONS的异常集合顺序与子事务回滚边界、EXCEPTION隐式子事务在内存管控异常下的回滚范围、GOTO跳转与EXIT WHEN组合在多层嵌套循环下的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_141_v1.yaml
generated/core_sql_reference_wave8_141_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_141.py
python scripts/build_core_sql_reference_wave8_141.py --check
python -m unittest tests.test_core_sql_reference_wave8_141 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行控制语句或异常捕获场景。
