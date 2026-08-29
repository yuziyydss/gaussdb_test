"""SQL 生成引擎：因子定义 + 覆盖策略 + fixture 链 + 上下文叠加 -> 测试用例。"""
from itertools import product
from typing import Dict, List, Optional, Any

from .combinator import generate
from .factor_model import FactorDef
from .constraint_solver import ConstraintSolver


class GeneratedCase:
    """一条生成的 SQL 测试用例。"""

    def __init__(self, factor_id: str, case_id: str, strategy: str,
                 params: Dict[str, str], sql: str,
                 expected: str = "success",
                 expected_sqlstate: str = "",
                 expected_sqlstates: List[str] = None,
                 expected_error_category: str = "",
                 expected_error_regex: str = "",
                 setup_sqls: List[str] = None,
                 teardown_sqls: List[str] = None,
                 context: str = "default",
                 preconditions: List[str] = None):
        self.factor_id = factor_id
        self.case_id = case_id
        self.strategy = strategy
        self.params = params
        self.sql = sql
        self.expected = expected
        
        # 归一化 expected_sqlstates 与 expected_sqlstate
        if expected_sqlstates:
            self.expected_sqlstates = list(expected_sqlstates)
            self.expected_sqlstate = expected_sqlstate or self.expected_sqlstates[0]
        elif expected_sqlstate:
            self.expected_sqlstate = expected_sqlstate
            self.expected_sqlstates = [expected_sqlstate]
        else:
            self.expected_sqlstate = ""
            self.expected_sqlstates = []

        self.expected_error_category = expected_error_category
        self.expected_error_regex = expected_error_regex
        self.setup_sqls = setup_sqls or []
        self.teardown_sqls = teardown_sqls or []
        self.context = context
        # 保留 fixture ID 以便报告追溯；setup/teardown 已编译进本用例。
        self.preconditions = preconditions or []

    def to_dict(self) -> dict:
        return {
            "factor_id": self.factor_id,
            "case_id": self.case_id,
            "strategy": self.strategy,
            "params": self.params,
            "sql": self.sql,
            "expected": self.expected,
            "expected_sqlstate": self.expected_sqlstate,
            "expected_sqlstates": self.expected_sqlstates,
            "expected_error_category": self.expected_error_category,
            "expected_error_regex": self.expected_error_regex,
            "setup_sqls": self.setup_sqls,
            "teardown_sqls": self.teardown_sqls,
            "context": self.context,
            "preconditions": self.preconditions,
        }


def _clean_sql(sql: str) -> str:
    """压缩多余空格, 不影响单引号内的字符串。"""
    out = []
    in_string = False
    for ch in sql:
        if ch == "'":
            in_string = not in_string
            out.append(ch)
        elif ch == " " and not in_string:
            if out and out[-1] != " ":
                out.append(ch)
        else:
            out.append(ch)
    return "".join(out).strip()




def validate_sql_syntax(sql: str) -> tuple:
    """SQL 语法基础预检。返回 (is_valid, issues列表)。"""
    issues = []

    # 1. 括号配对 (忽略单引号内的)
    depth = 0
    in_str = False
    for ch in sql:
        if ch == "'":
            in_str = not in_str
        elif not in_str:
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
                if depth < 0:
                    issues.append("括号不匹配: 多余的 ')'")
                    break
    if depth > 0:
        issues.append(f"括号不匹配: {depth} 个 '(' 未关闭")

    # 2. 重复关键字检测
    upper = ' '.join(sql.upper().split())
    for dup in ['CREATE CREATE', 'SELECT SELECT', 'TABLE TABLE',
                'INSERT INSERT', 'UPDATE UPDATE', 'DELETE DELETE',
                'WHERE WHERE', 'FROM FROM']:
        if dup in upper:
            issues.append(f"重复关键字: {dup}")

    # 3. 空语句
    if not sql.strip():
        issues.append("空 SQL 语句")

    # 4. 未解析的占位符 (模板渲染遗漏)
    if '{' in sql or '}' in sql:
        issues.append("SQL 含未解析的占位符 { 或 }")

    return (len(issues) == 0, issues)



def _is_excluded(combo: Dict[str, str], exclusions: list) -> tuple:
    """检查组合是否被排除规则跳过。返回 (excluded, reason)。"""
    for rule in exclusions:
        when = rule.get("when", {})
        match = all(str(combo.get(k, "")) == str(v) for k, v in when.items())
        if match:
            return True, rule.get("reason", "excluded")
    return False, ""

def _render_sql(factor: FactorDef, param_values: Dict[str, str],
                override_constants: dict = None) -> str:
    """渲染 SQL 并清理空白。"""
    raw = factor.render_sql(param_values, override_constants)
    return _clean_sql(raw)


def _resolve_setup(factor: FactorDef, registry, setup_list: list = None,
                      _visited: set = None) -> List[str]:
    """解析 fixture 链, 返回按顺序排列的 setup SQL 列表。

    _visited 跟踪已解析的因子 ID, 防止:
    1. 循环依赖 (A->B->A) 导致无限递归
    2. 重复 fixture (D 被两个分支引用) 导致重复建表
    """
    if _visited is None:
        _visited = set()
    if setup_list is not None:
        setups = setup_list
    else:
        setups = factor.setup
    sqls = []
    for setup_def in setups:
        if hasattr(setup_def, "factor"):
            fid = setup_def.factor
            strat = setup_def.strategy
            ctx = setup_def.context
        else:
            fid = setup_def.get("factor")
            strat = setup_def.get("strategy", "equivalence")
            ctx = setup_def.get("context", {})

        # 环检测: 跳过已解析或正在解析的因子
        if fid in _visited:
            continue
        _visited.add(fid)

        ffactor = registry.get(fid) if registry else None
        if not ffactor:
            continue

        vals = ffactor.values_for_strategy(strat)
        for k, v in ctx.items():
            if k in vals:
                vals[k] = [v]

        keys = list(vals.keys())
        combo = {k: vals[k][0] for k in keys} if keys else {}
        sqls.append(_render_sql(ffactor, combo))
        sqls.extend(_resolve_setup(ffactor, registry, None, _visited))
    return sqls


def _generate_matrix(factor: FactorDef, strat: str,
                     target_combos: List[Dict[str, str]],
                     matrix_setups: list, registry) -> List[GeneratedCase]:
    """fixture 矩阵: target 的所有组合 x fixture 的所有组合。"""
    cases = []
    setup_def = matrix_setups[0]
    fid = setup_def.factor
    ffactor = registry.get(fid) if registry else None
    if not ffactor:
        return []

    fvals = ffactor.values_for_strategy(setup_def.strategy)
    # 应用 context 覆盖: 固定某些 fixture 参数
    ctx = setup_def.context if hasattr(setup_def, "context") else setup_def.get("context", {})
    for k, v in ctx.items():
        if k in fvals:
            fvals[k] = [v]
    fkeys = list(fvals.keys())
    fvalue_lists = [fvals[k] for k in fkeys]
    fcombos = [dict(zip(fkeys, c)) for c in product(*fvalue_lists)]

    expected_matrix = factor.expected_matrix
    case_num = 0

    for fcombo in fcombos:
        # 检查 fixture 自身的排除规则
        f_excluded, _ = _is_excluded(fcombo, ffactor.exclusions)
        if f_excluded:
            case_num += 1
            cases.append(GeneratedCase(
                factor_id=factor.id,
                case_id=f"{factor.id}_{case_num:04d}",
                strategy=strat,
                params=dict(fcombo),
                sql=_render_sql(ffactor, fcombo),
                expected="skipped",
                context=f"fixture={fcombo} (excluded)",
            ))
            continue
        fixture_sql = _render_sql(ffactor, fcombo)
        f_expected, _ = ffactor.merge_expected(fcombo)

        # fixture 自身预期失败 -> 跳过该配置
        if f_expected == "error":
            case_num += 1
            cases.append(GeneratedCase(
                factor_id=factor.id,
                case_id=f"{factor.id}_{case_num:04d}",
                strategy=strat,
                params=dict(fcombo),
                sql=fixture_sql,
                expected="skipped",
                context=f"fixture={fcombo}",
            ))
            continue

        matrix_solver = ConstraintSolver(factor.constraints) if factor.constraints else None
        for tcombo in target_combos:
            # 合并 fixture + target 参数, 检查跨因子排除与约束求解
            combined = dict(tcombo)
            for k, v in fcombo.items():
                combined[f"fixture.{k}"] = v
            if matrix_solver:
                is_valid, _ = matrix_solver.is_valid(combined)
                if not is_valid:
                    continue
            t_excluded, _ = _is_excluded(combined, factor.exclusions)
            if t_excluded:
                continue
            tsql = _render_sql(factor, tcombo)
            expected, sqlstates = factor.merge_expected(tcombo)
            sqlstate = sqlstates[0] if sqlstates else ""

            # 应用 expected_matrix 跨因子预期规则
            for rule in expected_matrix:
                when_f = rule.get("when_fixture", {})
                when_p = rule.get("when_param", {})
                f_match = all(str(fcombo.get(k, "")) == str(v)
                              for k, v in when_f.items())
                p_match = all(str(tcombo.get(k, "")) == str(v)
                              for k, v in when_p.items())
                if f_match and p_match:
                    then = rule.get("then", {})
                    expected = then.get("expected", expected)
                    if "sqlstates" in then:
                        sqlstates = list(then["sqlstates"])
                        sqlstate = sqlstates[0] if sqlstates else ""
                    elif "sqlstate" in then:
                        sqlstate = then["sqlstate"]
                        sqlstates = [sqlstate] if sqlstate else []
                    break

            params_out = dict(tcombo)
            for k, v in fcombo.items():
                params_out[f"fixture.{k}"] = v

            cases.append(GeneratedCase(
                factor_id=factor.id,
                case_id=f"{factor.id}_{case_num:04d}",
                strategy=strat,
                params=params_out,
                sql=tsql,
                expected=expected,
                expected_sqlstate=sqlstate,
                expected_sqlstates=sqlstates,
                setup_sqls=[fixture_sql],
                context=f"fixture={fcombo}",
            ))

    return cases


def generate_cases(factor: FactorDef, strategy: str = None,
                   registry=None) -> List[GeneratedCase]:
    """主入口: 因子定义 + 策略 + 注册表 -> 测试用例列表。

    无 registry 时行为与旧版完全一致 (不解析 fixture, 不叠加上下文)。
    有 registry 时启用完整增强: fixture 链、矩阵、上下文叠加。
    """
    strat = strategy or factor.default_strategy
    param_values = factor.values_for_strategy(strat)

    # 无参数因子: 只渲染一次 (如固定 fixture)
    if not param_values:
        sql = _render_sql(factor, {})
        setup_sqls = _resolve_setup(factor, registry) if registry else []
        return [GeneratedCase(
            factor_id=factor.id,
            case_id=f"{factor.id}_0001",
            strategy=strat,
            params={},
            sql=sql,
            expected="success",
            setup_sqls=setup_sqls,
            context="default",
        )]

    # 参数组合
    combos = generate(param_values, strat)

    # CSP 约束求解过滤
    if factor.constraints:
        solver = ConstraintSolver(factor.constraints)
        combos = solver.filter_combos(combos)

    # fixture 矩阵检测
    if registry and factor.has_matrix_setup():
        matrix_setups = [s for s in factor.setup if s.matrix]
        return _generate_matrix(factor, strat, combos, matrix_setups, registry)

    # 普通生成
    cases = []
    case_idx = 0
    for combo in combos:
        # 检查旧版排除规则 (向后兼容)
        excluded, reason = _is_excluded(combo, factor.exclusions)
        if excluded:
            continue
        case_idx += 1
        sql = _render_sql(factor, combo)
        expected, sqlstates = factor.merge_expected(combo)
        sqlstate = sqlstates[0] if sqlstates else ""
        setup_sqls = _resolve_setup(factor, registry) if registry else []
        cases.append(GeneratedCase(
            factor_id=factor.id,
            case_id=f"{factor.id}_{case_idx:04d}",
            strategy=strat,
            params=dict(combo),
            sql=sql,
            expected=expected,
            expected_sqlstate=sqlstate,
            expected_sqlstates=sqlstates,
            setup_sqls=setup_sqls,
            context="default",
        ))

    # 上下文叠加: 同一因子在不同上下文下重跑
    if registry:
        for overlay in factor.context_overlays:
            overlay_name = overlay.get("name", "overlay")
            for case in list(cases):
                oc = GeneratedCase(
                    factor_id=factor.id,
                    case_id=f"{case.case_id}[{overlay_name}]",
                    strategy=strat,
                    params=dict(case.params),
                    sql=case.sql,
                    expected=case.expected,
                    expected_sqlstate=case.expected_sqlstate,
                    expected_sqlstates=list(case.expected_sqlstates),
                    setup_sqls=_resolve_setup(factor, registry,
                                             overlay.get("setup")),
                    context=overlay_name,
                )
                # params_override: 改常量, 影响渲染出的 SQL
                overrides = overlay.get("params_override", {})
                if overrides:
                    oc.sql = _render_sql(factor, case.params, overrides)
                # expected_override: 按参数值覆盖预期
                for pname, value_overrides in overlay.get(
                        "expected_override", {}).items():
                    pval = str(case.params.get(pname, ""))
                    if pval in value_overrides:
                        ov = value_overrides[pval]
                        oc.expected = ov.get("expected", oc.expected)
                        if "sqlstates" in ov:
                            oc.expected_sqlstates = list(ov["sqlstates"])
                            oc.expected_sqlstate = oc.expected_sqlstates[0] if oc.expected_sqlstates else ""
                        elif "sqlstate" in ov:
                            oc.expected_sqlstate = ov.get("sqlstate", oc.expected_sqlstate)
                            oc.expected_sqlstates = [oc.expected_sqlstate] if oc.expected_sqlstate else []
                cases.append(oc)

    return cases
