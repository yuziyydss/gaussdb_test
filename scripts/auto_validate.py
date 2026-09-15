#!/usr/bin/env python3
"""GaussDB spec-driven SQL test system - automated validation runner.

Usage:
  python3 auto_validate.py --host HOST --port PORT --db DB --user USER
  python3 auto_validate.py --host HOST --port PORT --db DB --user USER --phase 2
"""
import argparse, json, os, subprocess, sys, time
from datetime import datetime
from pathlib import Path

VERSION = "1.0"
RESULTS = []
START_TIME = None

def run_sql(host, port, db, user, password, sql, client="gsql", timeout=30):
    cmd = [client, "-h", host, "-p", str(port), "-d", db, "-U", user, "-c", sql]
    env = dict(os.environ)
    if password:
        env["PGPASSWORD"] = password
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, env=env)
        return r.returncode, r.stdout.strip(), r.stderr.strip()
    except FileNotFoundError:
        return -2, "", f"Client not found: {client}"
    except subprocess.TimeoutExpired:
        return -1, "", f"Timeout after {timeout}s"
    except Exception as e:
        return -3, "", str(e)

def add_result(tid, desc, sql, expected, actual, status, error=""):
    RESULTS.append({"id": tid, "desc": desc, "sql": sql, "expected": expected, "actual": actual, "status": status, "error": error})
    icon = "OK" if status == "PASS" else "FAIL"
    print(f"  [{icon}] {tid}: {desc}")
    if status != "PASS":
        print(f"       Expected: {expected}")
        print(f"       Actual: {actual[:200]}")
        if error:
            print(f"       Error: {error[:200]}")

def test_connection(host, port, db, user, password, client):
    rc, out, err = run_sql(host, port, db, user, password, "SELECT 1;", client)
    if rc == 0:
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

def phase1(host, port, db, user, password, client):
    print("\n" + "="*60)
    print("Phase 1: Core Validation (10 tests)")
    print("="*60)
    tests = [
        ("CREATE TABLE",
         "DROP SCHEMA IF EXISTS v_test CASCADE; CREATE SCHEMA v_test; SET current_schema=v_test; CREATE TABLE t1(id INT PRIMARY KEY, name VARCHAR(100))",
         "CREATE TABLE"),
        ("INSERT",
         "INSERT INTO v_test.t1 VALUES(1,'a'),(2,'b'),(3,'c')",
         "INSERT 0 3"),
        ("SELECT",
         "SELECT id,name FROM v_test.t1 ORDER BY id",
         "3 rows"),
        ("UPDATE",
         "UPDATE v_test.t1 SET name='upd' WHERE id=1",
         "UPDATE 1"),
        ("DELETE",
         "DELETE FROM v_test.t1 WHERE id=3",
         "DELETE 1"),
        ("CREATE INDEX",
         "CREATE INDEX idx_p1 ON v_test.t1(name)",
         "CREATE INDEX"),
        ("GRANT",
         "GRANT SELECT ON v_test.t1 TO PUBLIC",
         "GRANT"),
        ("BEGIN/COMMIT",
         "BEGIN; INSERT INTO v_test.t1 VALUES(99,'x'); COMMIT",
         "COMMIT"),
        ("GUC:leading_zero",
         "SET behavior_compat_options='display_leading_zero'; SELECT LENGTH(0.123); SET behavior_compat_options=''",
         "5"),
        ("GUC:end_month",
         "SET behavior_compat_options='end_month_calculate'; SELECT ADD_MONTHS('2018-02-28',3); SET behavior_compat_options=''",
         "2018-05-31"),
    ]
    for i, (desc, sql, expected) in enumerate(tests, 1):
        rc, out, err = run_sql(host, port, db, user, password, sql, client)
        status = "PASS" if rc == 0 else "FAIL"
        actual = out if rc == 0 else err[:200]
        add_result(f"P1-{i:03d}", desc, sql, expected, actual, status, err[:200])
    cleanup(host, port, db, user, password, client)

def cleanup(host, port, db, user, password, client):
    run_sql(host, port, db, user, password, "DROP SCHEMA IF EXISTS v_test CASCADE", client, timeout=60)

def generate_report(host, port, db, user):
    end = datetime.now()
    passed = sum(1 for r in RESULTS if r["status"] == "PASS")
    failed = sum(1 for r in RESULTS if r["status"] == "FAIL")
    duration = (end - START_TIME).total_seconds() if START_TIME else 0

    report = {
        "summary": {
            "total": len(RESULTS), "passed": passed, "failed": failed,
            "pass_rate": f"{passed*100//len(RESULTS)}%" if RESULTS else "N/A",
            "database": f"{host}:{port}/{db}", "user": user,
            "start": START_TIME.isoformat() if START_TIME else "",
            "end": end.isoformat(), "duration_sec": round(duration, 1),
        },
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
    return failed

def main():
    global START_TIME
    p = argparse.ArgumentParser()
    p.add_argument("--host", required=True)
    p.add_argument("--port", type=int, required=True)
    p.add_argument("--db", required=True)
    p.add_argument("--user", required=True)
    p.add_argument("--password", default="")
    p.add_argument("--client", default="gsql")
    p.add_argument("--phase", type=int, choices=[1], default=1)
    a = p.parse_args()

    START_TIME = datetime.now()
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
    print("\nEnvironment:")
    for k, v in env.items():
        print(f"  {k}: {v}")

    if a.phase == 1:
        phase1(a.host, a.port, a.db, a.user, a.password, a.client)

    failed = generate_report(a.host, a.port, a.db, a.user)
    sys.exit(1 if failed else 0)

if __name__ == "__main__":
    main()
