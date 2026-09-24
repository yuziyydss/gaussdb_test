#!/usr/bin/env python3
"""GaussDB spec-driven SQL test system - automated validation runner.

Usage:
  python3 auto_validate.py --host HOST --port PORT --db DB --user USER
  Execution is a separate, explicitly invoked phase; this is not a coverage audit.
"""
import argparse, json, os, re, subprocess, sys, uuid
from datetime import datetime
from pathlib import Path

VERSION = "1.1"
RESULTS = []
START_TIME = None
ENVIRONMENT = {}

def run_sql(host, port, db, user, password, sql, client="gsql", timeout=30):
    cmd = [client, "-X", "-A", "-t", "-F", "\t", "-P", "null=\\N",
           "-v", "ON_ERROR_STOP=1", "-v", "VERBOSITY=verbose",
           "-h", host, "-p", str(port), "-d", db, "-U", user, "-c", sql]
    env = dict(os.environ)
    if password:
        env["PGPASSWORD"] = password
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, env=env)
        return r.returncode, r.stdout.rstrip("\r\n"), r.stderr.strip()
    except FileNotFoundError:
        return -2, "", f"Client not found: {client}"
    except subprocess.TimeoutExpired:
        return -1, "", f"Timeout after {timeout}s"
    except Exception as e:
        return -3, "", str(e)

def evaluate_result(rc, out, err, oracle, *, stage="target"):
    """Finite machine-output Oracles. Never infer success from rc alone.

    Result rows are ordered textual cells, not a general typed SQL comparator.
    SQLSTATEs must come from a verbose ERROR line, never from echoed SQL.
    """
    kind = oracle.get("kind")
    if kind == "target_error":
        states = oracle.get("sqlstates", [])
        if not states or not all(re.fullmatch(r"[0-9A-Z]{5}", s) for s in states):
            return "FAIL", "missing or invalid target SQLSTATE Oracle"
        actual = re.findall(r"^\s*(?:.*?:\d+:\s*)?ERROR:\s+([0-9A-Z]{5}):", err, re.M)
        ok = stage == "target" and rc > 0 and len(actual) == 1 and actual[0] in states
        return ("PASS", "") if ok else ("FAIL", "target stage/SQLSTATE mismatch")
    if rc != 0 or re.search(r"\b(?:ERROR|FATAL|PANIC):", err):
        return "FAIL", "client or SQL execution failed"
    lines = out.splitlines()
    if kind == "command":
        expected = oracle.get("tags")
    elif kind == "affected_rows":
        command, count = oracle.get("command"), oracle.get("count")
        if command not in ("INSERT", "UPDATE", "DELETE") or type(count) is not int or count < 0:
            return "FAIL", "invalid affected-row Oracle"
        expected = [f"INSERT 0 {count}" if command == "INSERT" else f"{command} {count}"]
    elif kind == "result_set":
        rows = oracle.get("rows")
        if not isinstance(rows, list) or not rows or any(not isinstance(row, list) or not row for row in rows):
            return "FAIL", "invalid result-set Oracle"
        expected = list(oracle.get("prefix_tags", []))
        for row in rows:
            if any(cell is not None and (not isinstance(cell, str) or
                   any(c in cell for c in "\t\r\n") or cell in ("", "\\N")) for cell in row):
                return "FAIL", "unsupported cell encoding"
            expected.append("\t".join("\\N" if cell is None else cell for cell in row))
    else:
        return "FAIL", "missing or unsupported Oracle"
    if expected is None or (kind == "command" and not expected):
        return "FAIL", "empty command Oracle"
    return ("PASS", "") if lines == expected else ("FAIL", "Oracle output mismatch")


def add_result(tid, desc, sql, expected, actual, status, error="", stage="target", returncode=None):
    RESULTS.append({"id": tid, "desc": desc, "sql": sql, "expected": expected,
                    "actual": actual, "status": status, "error": error,
                    "stage": stage, "returncode": returncode})
    icon = "OK" if status == "PASS" else "FAIL"
    print(f"  [{icon}] {tid}: {desc}")
    if status != "PASS":
        print(f"       Expected: {expected}")
        print(f"       Actual: {actual[:200]}")
        if error:
            print(f"       Error: {error[:200]}")

def test_connection(host, port, db, user, password, client):
    rc, out, err = run_sql(host, port, db, user, password, "SELECT 1;", client)
    if evaluate_result(rc, out, err, {"kind": "result_set", "rows": [["1"]]})[0] == "PASS":
        print(f"  OK: {host}:{port}/{db}")
        return True
    print(f"  FAIL: {err[:200]}")
    return False

def get_env_info(host, port, db, user, password, client):
    queries = [
        ("version", "SELECT version();"),
        ("compatibility", "SHOW sql_compatibility;"),
        ("behavior_compat", "SHOW behavior_compat_options;"),
        ("m_format", "SHOW m_format_behavior_compat_options;"),
        ("current_db", "SELECT current_database();"),
        ("current_user", "SELECT current_user;"),
    ]
    info = {}
    for name, sql in queries:
        rc, out, err = run_sql(host, port, db, user, password, sql, client)
        info[name] = out if rc == 0 else f"ERROR"
    return info

def build_phase1_tests():
    """Return the ten Phase 1 target definitions without executing them."""
    return [
        ("CREATE TABLE",
         "CREATE TABLE v_test.t1(id INT PRIMARY KEY, name VARCHAR(100))",
         {"kind": "command", "tags": ["CREATE TABLE"]}),
        ("INSERT",
         "INSERT INTO v_test.t1 VALUES(1,'a'),(2,'b'),(3,'c')",
         {"kind": "affected_rows", "command": "INSERT", "count": 3}),
        ("SELECT",
         "SELECT id,name FROM v_test.t1 ORDER BY id",
         {"kind": "result_set", "rows": [["1", "a"], ["2", "b"], ["3", "c"]]}),
        ("UPDATE",
         "UPDATE v_test.t1 SET name='upd' WHERE id=1",
         {"kind": "affected_rows", "command": "UPDATE", "count": 1}),
        ("DELETE",
         "DELETE FROM v_test.t1 WHERE id=3",
         {"kind": "affected_rows", "command": "DELETE", "count": 1}),
        ("CREATE INDEX",
         "CREATE INDEX idx_p1 ON v_test.t1(name)",
         {"kind": "command", "tags": ["CREATE INDEX"]}),
        ("GRANT",
         "GRANT SELECT ON v_test.t1 TO PUBLIC",
         {"kind": "command", "tags": ["GRANT"]}),
        ("BEGIN/COMMIT",
         "BEGIN; INSERT INTO v_test.t1 VALUES(99,'x'); COMMIT",
         {"kind": "command", "tags": ["BEGIN", "INSERT 0 1", "COMMIT"]}),
        ("GUC:leading_zero",
         "SET behavior_compat_options='display_leading_zero'; SELECT LENGTH(0.123)",
         {"kind": "result_set", "prefix_tags": ["SET"], "rows": [["5"]]}),
        ("GUC:end_month",
         "SET behavior_compat_options='end_month_calculate'; SELECT ADD_MONTHS('2018-02-28',3)::date",
         {"kind": "result_set", "prefix_tags": ["SET"], "rows": [["2018-05-31"]]}),
    ]


def build_phase1_dry_run():
    """Build a non-executing Phase 1 plan for review and later execution."""
    tests = build_phase1_tests()
    units = []
    for index, (description, sql, oracle) in enumerate(tests, 1):
        units.append({
            "id": f"P1-{index:03d}",
            "description": description,
            "sql": sql,
            "oracle": oracle,
            "status": "ready_for_authorized_execution",
            "database_executed": False,
            "runtime_verified": False,
        })
    return {
        "kind": "phase1_runtime_dry_run",
        "schema_version": 1,
        "profile": "phase1_core_validation_v1",
        "status": "ready_for_authorized_execution",
        "database_executed": False,
        "execution_authorized": False,
        "runtime_verified": 0,
        "schema_placeholder": "v_test",
        "setup": {
            "sql": "CREATE SCHEMA v_test",
            "oracle": {"kind": "command", "tags": ["CREATE SCHEMA"]},
            "status": "ready_for_authorized_execution",
            "database_executed": False,
        },
        "units": units,
        "cleanup": {
            "sql": "DROP SCHEMA v_test CASCADE",
            "oracle": {"kind": "command", "tags": ["DROP SCHEMA"]},
            "status": "ready_for_authorized_execution",
            "database_executed": False,
            "requires_owned_schema": True,
        },
        "limits": [
            "This dry run does not open a database connection or execute SQL.",
            "A planned target is not runtime evidence.",
            "Cleanup may run only for a schema proven created by the same run.",
            "GUC overlays are session-local and must be restored after execution.",
        ],
    }


def load_phase1_plan(path):
    """Load and validate a Phase 1 dry-run plan for execution."""
    try:
        plan = json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot load Phase 1 plan {path}: {exc}") from exc

    required = {
        "kind": "phase1_runtime_dry_run",
        "profile": "phase1_core_validation_v1",
        "status": "ready_for_authorized_execution",
    }
    for key, expected in required.items():
        if plan.get(key) != expected:
            raise ValueError(f"invalid Phase 1 plan {key}: {plan.get(key)!r}")
    if plan.get("schema_version") != 1:
        raise ValueError("invalid Phase 1 plan schema_version")
    if plan.get("database_executed") or plan.get("execution_authorized"):
        raise ValueError("Phase 1 plan must remain a non-executed dry run")
    if plan.get("runtime_verified") != 0:
        raise ValueError("Phase 1 plan must not contain runtime verification claims")

    units = plan.get("units")
    if not isinstance(units, list) or len(units) != 10:
        raise ValueError("Phase 1 plan must contain exactly 10 units")
    expected_ids = [f"P1-{index:03d}" for index in range(1, 11)]
    if [unit.get("id") for unit in units] != expected_ids:
        raise ValueError("Phase 1 plan unit IDs do not match P1-001..P1-010")
    if not isinstance(plan.get("setup"), dict) or not isinstance(plan.get("cleanup"), dict):
        raise ValueError("Phase 1 plan must contain setup and cleanup")

    tests = []
    for unit in units:
        if unit.get("status") != "ready_for_authorized_execution":
            raise ValueError(f"Phase 1 unit is not ready: {unit.get('id')}")
        if unit.get("database_executed") or unit.get("runtime_verified"):
            raise ValueError(f"Phase 1 unit contains runtime claims: {unit.get('id')}")
        description = unit.get("description")
        sql = unit.get("sql")
        oracle = unit.get("oracle")
        if not isinstance(description, str) or not description.strip():
            raise ValueError(f"Phase 1 unit has invalid description: {unit.get('id')}")
        if not isinstance(sql, str) or not sql.strip():
            raise ValueError(f"Phase 1 unit has invalid SQL: {unit.get('id')}")
        if not isinstance(oracle, dict) or not oracle:
            raise ValueError(f"Phase 1 unit has invalid Oracle: {unit.get('id')}")
        tests.append((description, sql, oracle))
    return tests


def phase1(host, port, db, user, password, client, tests=None):
    print("\n" + "="*60)
    print("Phase 1: Core Validation (10 tests)")
    print("="*60)
    schema = "v_test_" + uuid.uuid4().hex
    tests = build_phase1_tests()
    setup_sql = f"CREATE SCHEMA {schema}"
    setup_oracle = {"kind": "command", "tags": ["CREATE SCHEMA"]}
    rc, out, err = run_sql(host, port, db, user, password, setup_sql, client)
    status, reason = evaluate_result(rc, out, err, setup_oracle, stage="setup")
    owned = status == "PASS"
    add_result("P1-SETUP", "Create run-owned schema", setup_sql, setup_oracle,
               out, status, err or reason, stage="setup", returncode=rc)
    blocked = not owned
    try:
        for i, (desc, sql, expected) in enumerate(tests, 1):
            sql = sql.replace("v_test.", schema + ".")
            if blocked:
                add_result(f"P1-{i:03d}", desc, sql, expected, "", "BLOCKED", "prior step failed")
                continue
            rc, out, err = run_sql(host, port, db, user, password, sql, client)
            status, reason = evaluate_result(rc, out, err, expected)
            add_result(f"P1-{i:03d}", desc, sql, expected, out, status,
                       err or reason, returncode=rc)
            blocked = status != "PASS"
    finally:
        if owned:
            cleanup(host, port, db, user, password, client, schema)

def cleanup(host, port, db, user, password, client, schema):
    if not re.fullmatch(r"v_test_[0-9a-f]{32}", schema):
        raise ValueError("cleanup requires a run-owned schema name")
    sql = f"DROP SCHEMA {schema} CASCADE"
    expected = {"kind": "command", "tags": ["DROP SCHEMA"]}
    rc, out, err = run_sql(host, port, db, user, password, sql, client, timeout=60)
    status, reason = evaluate_result(rc, out, err, expected, stage="teardown")
    add_result("P1-CLEANUP", "Remove run-owned schema", sql, expected, out,
               status, err or reason, stage="teardown", returncode=rc)

def generate_report(host, port, db, user):
    end = datetime.now()
    passed = sum(1 for r in RESULTS if r["status"] == "PASS")
    failed = sum(1 for r in RESULTS if r["status"] == "FAIL")
    blocked = sum(1 for r in RESULTS if r["status"] == "BLOCKED")
    duration = (end - START_TIME).total_seconds() if START_TIME else 0

    report = {
        "summary": {
            "total": len(RESULTS), "passed": passed, "failed": failed, "blocked": blocked,
            "executed": sum(r["returncode"] is not None for r in RESULTS),
            "pass_rate": f"{passed*100//len(RESULTS)}%" if RESULTS else "N/A",
            "database": f"{host}:{port}/{db}", "user": user,
            "start": START_TIME.isoformat() if START_TIME else "",
            "end": end.isoformat(), "duration_sec": round(duration, 1),
        },
        "environment": ENVIRONMENT,
        "results": RESULTS,
    }

    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    jpath = Path(f"validation_report_{ts}.json")
    with open(jpath, "w") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)

    tpath = Path(f"validation_report_{ts}.txt")
    with open(tpath, "w") as f:
        f.write("GaussDB Validation Report\n")
        f.write(f"=" * 60 + "\n\n")
        s = report["summary"]
        f.write(f"Database: {s['database']}\n")
        f.write(f"Total: {s['total']} | Pass: {s['passed']} | Fail: {s['failed']}\n")
        f.write(f"Pass Rate: {s['pass_rate']}\n\n")
        for r in RESULTS:
            icon = "[OK]" if r["status"] == "PASS" else "[FAIL]"
            f.write(f"\n{icon} {r['id']}: {r['desc']}\n")
            if r["status"] != "PASS":
                f.write(f"  Expected: {r['expected']}\n")
                f.write(f"  Actual: {r['actual'][:200]}\n")

    print(f"\n{'='*60}")
    print(f"Report saved:")
    print(f"  JSON: {jpath}")
    print(f"  Text: {tpath}")
    print(f"  Pass Rate: {passed}/{len(RESULTS)}")
    return failed + blocked

def main():
    global START_TIME, ENVIRONMENT
    p = argparse.ArgumentParser()
    p.add_argument("--host")
    p.add_argument("--port", type=int)
    p.add_argument("--db")
    p.add_argument("--user")
    p.add_argument("--password", default="")
    p.add_argument("--client", default="gsql")
    p.add_argument("--phase", type=int, choices=[1], default=1)
    p.add_argument("--dry-run", action="store_true", help="write a Phase 1 plan without connecting")
    p.add_argument("--output", type=Path, default=None, help="dry-run output path")
    p.add_argument("--plan", type=Path, default=None, help="execute a generated Phase 1 dry-run plan")
    a = p.parse_args()

    if a.dry_run and a.plan:
        p.error("--dry-run and --plan cannot be used together")
    if a.dry_run:
        if not a.output:
            p.error("--output is required with --dry-run")
        if a.output.exists():
            raise SystemExit(f"output already exists: {a.output}")
        plan = build_phase1_dry_run()
        a.output.parent.mkdir(parents=True, exist_ok=True)
        a.output.write_text(json.dumps(plan, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"Phase 1 dry-run plan written: {a.output}")
        return

    plan_tests = None
    if a.plan:
        try:
            plan_tests = load_phase1_plan(a.plan)
        except ValueError as exc:
            raise SystemExit(str(exc)) from exc

    missing = [name for name, value in (
        ("--host", a.host), ("--port", a.port), ("--db", a.db), ("--user", a.user)
    ) if value in (None, "")]
    if missing:
        p.error("the following arguments are required unless --dry-run is used: " + ", ".join(missing))

    START_TIME = datetime.now()
    RESULTS.clear()
    print(f"GaussDB Auto-Validation v{VERSION}")
    print(f"Target: {a.host}:{a.port}/{a.db} (user: {a.user})")
    print(f"\nTesting connection...")

    if not test_connection(a.host, a.port, a.db, a.user, a.password, a.client):
        print("\nCannot connect. Check:")
        print(f"  Host: {a.host}:{a.port}")
        print(f"  Database: {a.db}")
        print(f"  User: {a.user}")
        sys.exit(1)

    env = get_env_info(a.host, a.port, a.db, a.user, a.password, a.client)
    ENVIRONMENT = env
    print("\nEnvironment:")
    for k, v in env.items():
        print(f"  {k}: {v}")

    if a.phase == 1:
        phase1(a.host, a.port, a.db, a.user, a.password, a.client, tests=plan_tests)

    failed = generate_report(a.host, a.port, a.db, a.user)
    sys.exit(1 if failed else 0)

if __name__ == "__main__":
    main()
