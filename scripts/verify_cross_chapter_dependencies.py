#!/usr/bin/env python3
"""Validate a real PDF chapter batch and inject dependency faults in a copy.

No database connection. Real queue results and simulated freshness probes are
reported separately; a probe never promotes a real package to static_complete.
"""
from __future__ import annotations

import argparse
import copy
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from scripts.manage_extraction_queue import (
    QueueError, dependency_verification_snapshot, factor_package_sha256,
    inventory_state, refresh_task_dependencies, select_pending_task, sha256_file,
    static_completion_freshness, task_topological_order, utc_now,
    verification_toolchain_sha256, verify_task, write_state, supplemental_verification_snapshot,
)

DEFAULT_CONFIG = ROOT / "tests/data/cross_chapter_batch.json"
DEFAULT_OUTPUT = ROOT / "work/doc2spec/batches/cross_chapter_18"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load_inputs(config, specs_root):
    registry = FactorPackageRegistry(specs_root)
    registry.load_all()
    selected = set(config["factors"])
    require(10 <= len(selected) <= 20, "batch must contain 10-20 distinct chapters")
    require(len(selected) == len(config["factors"]), "duplicate chapter")
    catalogs = {}
    for name in config["catalogs"]:
        path = ROOT / name
        catalog = json.loads(path.read_text(encoding="utf-8"))
        for chapter in catalog["chapters"]:
            catalogs[chapter["source_relpath"]] = (path, catalog, chapter)
    inputs = {}
    for factor_id in sorted(selected):
        factor = registry.factors[factor_id]
        ref = factor.source.catalog_chapter_ref
        require(ref is not None, f"{factor_id}: PDF catalog ref required")
        path, catalog, chapter = catalogs[ref.source_relpath]
        source = path.parent / ref.source_relpath
        digest = sha256_file(source)
        require(digest == factor.source.artifact_sha256 == chapter["chapter_sha256"],
                f"{factor_id}: source/catalog/package hash mismatch")
        require(factor.source.parent_pdf_sha256 == catalog["parent_pdf_sha256"],
                f"{factor_id}: parent PDF mismatch")
        inputs[factor_id] = {
            "source_path": str(source.resolve()), "chapter": chapter,
            "parent_pdf_path": str((path.parent / catalog["parent_pdf_path"]).resolve()),
            "parent_pdf_sha256": catalog["parent_pdf_sha256"],
        }
    require(len({i["parent_pdf_sha256"] for i in inputs.values()}) == 1,
            "batch must use one PDF version")
    pdf = Path(next(iter(inputs.values()))["parent_pdf_path"])
    require(sha256_file(pdf) == next(iter(inputs.values()))["parent_pdf_sha256"],
            "actual PDF hash mismatch")
    return registry, inputs


def fact_evidence(registry, inputs, owner, fact_id):
    factor = registry.factors[owner]
    fact = next(f for f in factor.facts if f.id == fact_id)
    ledger = registry.source_ledgers[factor.source_ledger_ref]
    units = [u for u in ledger.units if fact_id in u.fact_refs]
    require(units, f"{owner}::{fact_id}: missing source units")
    lines = Path(inputs[owner]["source_path"]).read_text(encoding="utf-8").splitlines()
    return {
        "fact_ref": f"{owner}::{fact_id}", "type": fact.type,
        "status": fact.status, "statement": fact.statement,
        "source_path": inputs[owner]["source_path"],
        "section": inputs[owner]["chapter"]["section_number"],
        "units": [{
            "id": u.id, "line_start": u.line_start, "line_end": u.line_end,
            "source_text": "\n".join(lines[u.line_start - 1:u.line_end]),
        } for u in units],
    }


def source_input_closure(config, registry, inputs):
    """Include declared evidence bodies, not just executable factor DAG nodes."""
    catalogs = {}
    for name in config['catalogs']:
        path = ROOT / name
        catalog = json.loads(path.read_text(encoding='utf-8'))
        for chapter in catalog['chapters']:
            catalogs[chapter['source_relpath']] = (path, catalog, chapter)
    bodies = {i['chapter']['source_relpath']: dict(i) for i in inputs.values()}
    for factor_id in config['factors']:
        factor = registry.factors[factor_id]
        ledger = registry.source_ledgers[factor.source_ledger_ref]
        for source in ledger.supplemental_sources:
            ref = source.catalog_chapter_ref
            require(ref is not None, f'{factor_id}: supplemental source outside frozen PDF')
            require(ref.source_relpath in catalogs, f'{factor_id}: supplemental catalog entry missing: {ref.source_relpath}')
            path, catalog, chapter = catalogs[ref.source_relpath]
            require(ref.document_id == catalog['document_id'], f'{factor_id}: supplemental document mismatch')
            require(catalog['parent_pdf_sha256'] == inputs[factor_id]['parent_pdf_sha256'],
                    f'{factor_id}: supplemental PDF mismatch')
            body_path = path.parent / ref.source_relpath
            require(sha256_file(body_path) == ref.chapter_sha256 == chapter['chapter_sha256'],
                    f'{factor_id}: supplemental source/catalog/package hash mismatch: {ref.source_relpath}')
            bodies[ref.source_relpath] = {
                'source_path': str(body_path.resolve()), 'chapter': chapter,
                'parent_pdf_path': inputs[factor_id]['parent_pdf_path'],
                'parent_pdf_sha256': catalog['parent_pdf_sha256'],
            }
    return bodies


def select_batch_tasks(state, factors):
    """Retain the reviewed factor scope; preserve all bodies in its catalog."""
    selected = [t for t in state['tasks'] if t['factor_id'] in factors]
    require(len(selected) == len(set(factors)) and {t['factor_id'] for t in selected} == set(factors),
            'requested tasks missing or duplicated in source inventory')
    excluded = [t for t in state['tasks'] if t['factor_id'] not in factors]
    state['tasks'] = selected
    return excluded


def review_links(config, registry, inputs):
    facts, fixtures = [], []
    for link in config["fact_links"]:
        entity_path = registry.source_paths[link["entity"]]
        import yaml
        raw = yaml.safe_load(entity_path.read_text(encoding="utf-8"))
        references = raw[link["field"]]
        if "profile_id" in link:
            require(link["field"] == "profiles" and "gate_key" not in link,
                    "profile selector requires profiles without a gate selector")
            profiles = [p for p in references if p["id"] == link["profile_id"]]
            require(len(profiles) == 1, f"missing/duplicate reviewed profile: {link}")
            references = profiles[0].get("fact_refs", [])
        if "gate_key" in link:
            require(link["field"] == "environment_requirements", "gate selector requires environment_requirements")
            gates = [gate for gate in references if gate["key"] == link["gate_key"]]
            require(len(gates) == 1, f"missing/duplicate reviewed environment gate: {link}")
            references = gates[0]["fact_refs"]
        require(link["provider"] in references, f"missing import: {link}")
        require(raw.get("factor_ref") == link["consumer"], f"wrong consumer: {link}")
        phase = link.get('dependency_phase', 'package')
        require(phase in ('package', 'source'), f"unknown dependency phase: {link}")
        source_only = link['provider'] in registry.factors[link['consumer']].source_only_fact_refs
        require(source_only == (phase == 'source'), f"dependency phase drift: {link}")
        provider, fact_id = link["provider"].split("::")
        resolved = registry.resolve_fact_ref(link["consumer"], link["provider"])
        require(resolved is not None and resolved.status == "confirmed",
                f"unresolved/unconfirmed fact: {link}")
        facts.append({
            **link, "consumer_file": str(entity_path),
            "consumer_evidence": fact_evidence(registry, inputs, link["consumer"], link["local_fact"]),
            "provider_evidence": fact_evidence(registry, inputs, provider, fact_id),
        })
    for link in config["fixture_links"]:
        consumer = registry.fixtures[link["consumer"]]
        provider = registry.fixtures[link["provider"]]
        require(link["provider"] in consumer.requires_fixture_refs, f"missing fixture link: {link}")
        require(provider.factor_ref != consumer.factor_ref, "fixture must cross packages")
        fixtures.append({
            **link, "consumer_factor": consumer.factor_ref, "provider_factor": provider.factor_ref,
            "consumer_evidence": fact_evidence(registry, inputs, consumer.factor_ref, link["local_fact"]),
            "setup_order": registry.fixture_topological_order([consumer.id]),
        })
    return {"facts": facts, "fixtures": fixtures,
            "fixture_closures": review_fixture_closures(config, registry)}


def review_fixture_closures(config, registry):
    """Check explicit expected owners against real profile imports and fixture DAGs."""
    import yaml
    results = []
    for link in config.get("fixture_closures", []):
        consumer, fixture_id = link["consumer"], link["fixture"]
        if "matrix" in link:
            path = registry.source_paths[link["matrix"]]
            raw = yaml.safe_load(path.read_text(encoding="utf-8"))
            require(raw["factor_ref"] == consumer, f"wrong profile owner: {link}")
            profile = next(p for p in raw["profiles"] if p["id"] == link["profile"])
            require(fixture_id in profile.get("fixture_refs", []), f"missing profile fixture: {link}")
        else:
            require(registry.fixtures[fixture_id].factor_ref == consumer,
                    f"wrong fixture owner: {link}")
        order = registry.fixture_topological_order([fixture_id])
        owners = {registry.fixtures[fid].factor_ref for fid in order} - {consumer}
        require(owners == set(link["expected_external_owners"]), f"fixture owner closure drift: {link}")
        results.append({**link, "setup_order": order, "passed": True})
    return results


def expected_graph(config, *, scheduling=False):
    graph = {factor: set() for factor in config["factors"]}
    for link in config["fact_links"]:
        if scheduling and link.get('dependency_phase') == 'source':
            continue
        graph[link["consumer"]].add(link["provider"].split("::")[0])
    # Fixture owners are asserted separately from the derived registry graph.
    graph["insert"].add("create_table")
    graph["drop_table"].add("create_table")
    for link in config.get("fixture_closures", []):
        require(set(link["expected_external_owners"]) <= set(graph), "fixture provider outside batch")
        graph[link["consumer"]].update(link["expected_external_owners"])
    return graph


def descendants(graph, provider):
    affected = {provider}
    while True:
        expanded = affected | {node for node, deps in graph.items() if deps & affected}
        if expanded == affected:
            return affected
        affected = expanded


def verify_claim_order(state, graph):
    simulated = copy.deepcopy(state)
    for task in simulated["tasks"]:
        task["status"] = "pending"
    order = []
    for _ in simulated["tasks"]:
        task = select_pending_task(simulated)
        require(graph[task["factor_id"]] <= set(order), "consumer claimed before dependency")
        order.append(task["factor_id"])
        task["status"] = "generated"
    blocked = copy.deepcopy(state)
    for task in blocked["tasks"]:
        task["status"] = "blocked" if task["factor_id"] == "select" else "pending"
    allowed = []
    while True:
        try:
            task = select_pending_task(blocked)
        except QueueError as exc:
            require("没有符合过滤条件" in str(exc), str(exc))
            break
        allowed.append(task["factor_id"])
        task["status"] = "generated"
    expected_allowed = set(graph) - descendants(graph, "select")
    require(set(allowed) == expected_allowed, "blocked provider did not isolate its descendants")
    return {"simulation": True, "claim_order": order, "blocked_provider": "select",
            "unblocked_claims": allowed, "passed": True}


def load_fault_probes(registry):
    """Mutate registry copies, then exercise the real reference validation."""
    results = []
    def probe(name, mutate, expected_message):
        trial = copy.deepcopy(registry)
        mutate(trial)
        errors = []
        trial._validate_references(errors)
        matching = [e for e in errors if expected_message in e]
        require(matching, f"{name}: fault not detected; errors={errors}")
        results.append({"name": name, "detected": True, "evidence": matching})

    def imported_syntax(trial, ref):
        trial.syntaxes["syntax_insert_v1"].source_fact_refs.append(ref)

    probe("missing_fact", lambda r: imported_syntax(r, "select::missing_probe_fact"), "missing_probe_fact")
    probe("unexported_fact", lambda r: imported_syntax(r, "select::select_fact_purpose"), "select_fact_purpose")
    probe("wrong_fact_type", lambda r: imported_syntax(r, "create_view::cv_fact_read_only_behavior"), "不能由 syntax 消费")
    def factor_cycle(trial):
        trial.factors["create_view"].exported_fact_refs.append("cv_fact_query_select_or_values")
        trial.syntaxes[trial.factors["select"].syntax_ref].source_fact_refs.append(
            "create_view::cv_fact_query_select_or_values")
    probe("factor_cycle", factor_cycle, "因子依赖存在环")
    probe("missing_fixture", lambda r: r.fixtures["fixture_insert_view_target"].requires_fixture_refs.append("missing_probe_fixture"), "missing_probe_fixture")
    probe("fixture_cycle", lambda r: r.fixtures["fixture_create_table_insert_view_base"].requires_fixture_refs.append("fixture_insert_view_target"), "fixture 依赖存在环")
    return results


def fixture_sql_probes(registry, config):
    generator = FactorPackageSQLGenerator(registry)
    results = []
    for link in config["fixture_links"]:
        consumer = registry.fixtures[link["consumer"]]
        provider = registry.fixtures[link["provider"]]
        table = provider.provides.tables[0].name
        view = consumer.provides.tables[0].name
        matched = []
        for manifest_id in registry.factors[consumer.factor_ref].manifest_refs:
            cases, _ = generator.generate_with_report(registry.manifests[manifest_id])
            for case in cases:
                if consumer.id not in case.preconditions:
                    continue
                require(case.preconditions.index(provider.id) < case.preconditions.index(consumer.id), "bad fixture order")
                creates_table = [i for i,s in enumerate(case.setup_sqls) if s.startswith(f"CREATE TABLE {table} ")]
                creates_view = [i for i,s in enumerate(case.setup_sqls) if s.startswith(f"CREATE VIEW {view} ")]
                require(len(creates_table) == len(creates_view) == 1, "missing/duplicate object creation")
                require(creates_table[0] < creates_view[0], "view created before table")
                drops_table = [i for i,s in enumerate(case.teardown_sqls) if s.startswith(f"DROP TABLE IF EXISTS {table}")]
                drops_view = [i for i,s in enumerate(case.teardown_sqls) if s.startswith(f"DROP VIEW IF EXISTS {view}")]
                require(len(drops_table) == len(drops_view) == 1, "missing/duplicate teardown")
                require(drops_view[0] < drops_table[0], "table cleaned before view")
                matched.append({"case_id": case.case_id, "setup": case.setup_sqls,
                                "sql": case.sql, "teardown": case.teardown_sqls})
        require(matched, f"fixture {consumer.id} has no generated consumers")
        results.append({**link, "case_count": len(matched), "passed": True, "cases": matched})
    return results


def invalidation_probes(state, graph, providers, body_consumers=None):
    """Use real files in a temporary copy, including raw source edits without inventory."""
    results = []
    body_consumers = body_consumers or {}
    toolchain = verification_toolchain_sha256()
    with tempfile.TemporaryDirectory(prefix="gauss-dependency-probe-") as tmp:
        root = Path(tmp)
        shutil.copytree(state["specs_root"], root / "specs")
        shutil.copytree(state["corpus_root"], root / "corpus")
        trial = copy.deepcopy(state)
        trial["specs_root"] = str(root / "specs")
        trial["corpus_root"] = str(root / "corpus")
        tasks = {t["factor_id"]: t for t in trial["tasks"]}
        for task in tasks.values():
            task["output_dir"] = str(root / "specs" / Path(task["output_dir"]).relative_to(state["specs_root"]))
            task["source_catalog_path"] = str(root / "corpus/catalog.json")
        for task in tasks.values():
            # This is a freshness unit simulation, not a real audit pass.
            task["status"] = "static_complete"
            task["verification_snapshot"] = {
                "factor_package_sha256": factor_package_sha256(Path(task["output_dir"])),
                "source_sha256": task["source_sha256"],
                "toolchain_sha256": toolchain,
                "catalog_sha256": sha256_file(root / "corpus/catalog.json"),
                "parent_pdf_sha256": task["parent_pdf_sha256"],
                "dependencies": dependency_verification_snapshot(trial, task),
                "supplemental_sources": supplemental_verification_snapshot(
                    Path(task['output_dir']), root / 'corpus/catalog.json', root / 'corpus'),
            }

        def freshness():
            # source_path in dependency snapshots enables precise offline checks
            # without rebuilding the entire registry for every task.
            return {fid: static_completion_freshness(t, corpus_root=root / "corpus",
                       toolchain_sha256=toolchain) for fid,t in tasks.items()}
        require(all(ok for ok,_ in freshness().values()), "simulation baseline is not fresh")
        for provider in providers:
            package = Path(tasks[provider]["output_dir"])
            files = {
                "package_change": next(package.glob("*.factor.yaml")),
                "source_change_without_inventory": root / "corpus" / tasks[provider]["source_relpath"],
            }
            for kind, path in files.items():
                original = path.read_bytes()
                try:
                    path.write_bytes(original + b"\n# dependency fault injection\n")
                    observed = freshness()
                    actual = {fid for fid,(ok,_) in observed.items() if not ok}
                    expected = descendants(graph, provider)
                    if kind == 'source_change_without_inventory':
                        for consumer in body_consumers.get(tasks[provider]['source_relpath'], []):
                            expected |= descendants(graph, consumer)
                    require(actual == expected, f"{provider}/{kind}: expected={expected}, actual={actual}")
                    results.append({"provider": provider, "kind": kind,
                                    "expected_stale": sorted(expected), "actual_stale": sorted(actual),
                                    "unaffected": sorted(set(graph)-actual),
                                    "reasons": {f: reasons for f,(_,reasons) in observed.items()},
                                    "passed": True})
                finally:
                    path.write_bytes(original)
                require(all(ok for ok,_ in freshness().values()), "restore did not restore freshness")
            print(f"invalidation {provider}: package/source changes correctly isolated", flush=True)
        for relpath, consumers in body_consumers.items():
            path = root / 'corpus' / relpath
            original = path.read_bytes()
            expected = set().union(*(descendants(graph, c) for c in consumers))
            # A primary chapter also invalidates its owning package.
            for fid, task in tasks.items():
                if task['source_relpath'] == relpath:
                    expected |= descendants(graph, fid)
            try:
                path.write_bytes(original + b'\n# body-only fault injection\n')
                observed = freshness()
                actual = {fid for fid, (ok, _) in observed.items() if not ok}
                require(actual == expected, f'{relpath}: expected={expected}, actual={actual}')
                results.append({'kind': 'supplemental_body_change_without_inventory',
                    'source_relpath': relpath, 'expected_stale': sorted(expected),
                    'actual_stale': sorted(actual), 'unaffected': sorted(set(graph) - actual), 'passed': True})
            finally:
                path.write_bytes(original)
            require(all(ok for ok, _ in freshness().values()), 'body restore did not restore freshness')
    return {"simulation": True, "mutated_original_files": False, "checks": results}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--pdf-python", default=sys.executable,
                        help="Python with pypdf installed, used only for PDF extraction")
    args = parser.parse_args()
    config = json.loads(args.config.read_text(encoding="utf-8"))
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    report = {"batch_id": config["id"], "started_at": utc_now(), "passed": False,
              "database_executed": False, "known_limits": config["known_limits"]}
    try:
        registry, inputs = load_inputs(config, ROOT / "specs")
        body_inputs = source_input_closure(config, registry, inputs)
        report['source_body_closure'] = {
            'factor_chapters': len(inputs), 'body_chapters': len(body_inputs),
            'source_relpaths': sorted(body_inputs),
            'body_only_relpaths': sorted(set(body_inputs) - {i['chapter']['source_relpath'] for i in inputs.values()}),
        }
        baseline_path = ROOT / "generated/factor_packages/generation_report.json"
        baseline = json.loads(baseline_path.read_text(encoding="utf-8"))
        selected_manifests = {mid for fid in config["factors"] for mid in registry.factors[fid].manifest_refs}
        baseline_targets = {case["case_id"]: case["sql"]
                            for mid,entry in baseline["manifests"].items() if mid in selected_manifests
                            for case in entry["cases"]}
        report["links"] = review_links(config, registry, inputs)
        graph = {f: deps for f,deps in registry.factor_dependency_graph().items() if f in config["factors"]}
        require(graph == expected_graph(config), "actual dependencies differ from reviewed batch links")
        report["graph"] = {f: sorted(v) for f,v in sorted(graph.items())}
        scheduling_graph = {f: deps for f,deps in registry.factor_scheduling_graph().items() if f in config['factors']}
        require(scheduling_graph == expected_graph(config, scheduling=True), 'scheduling dependencies differ from reviewed phases')
        report['scheduling_graph'] = {f: sorted(v) for f,v in sorted(scheduling_graph.items())}
        require(set(registry.factor_topological_order(config["factors"])) == set(config["factors"]), "batch is not dependency closed")
        print(f"Reviewed {len(inputs)} chapters and all cross-package source anchors", flush=True)
        command = [args.pdf_python, str(ROOT / "scripts/extract_pdf_sections.py"),
                   "--pdf", next(iter(inputs.values()))["parent_pdf_path"],
                   "--output-root", str(out / "corpus")]
        for item in body_inputs.values():
            command += ["--section", item["chapter"]["section_number"]]
        extraction = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        report["pdf_reextraction"] = {"command": command, "returncode": extraction.returncode,
                                      "output": extraction.stdout + extraction.stderr}
        require(extraction.returncode == 0, report["pdf_reextraction"]["output"])
        for source_relpath, item in body_inputs.items():
            require(sha256_file(out / "corpus" / item["chapter"]["source_relpath"]) == item["chapter"]["chapter_sha256"],
                    f"{source_relpath}: fresh PDF extraction drift")
        print(f"Fresh PDF extraction: {len(body_inputs)}/{len(body_inputs)} body hashes match ({len(inputs)} factor chapters)", flush=True)
        state = inventory_state(out / "corpus", ROOT / "specs", source_catalog_path=out / "corpus/catalog.json")
        excluded = select_batch_tasks(state, config['factors'])
        report['source_body_closure']['evidence_only_tasks_not_executed'] = [t['factor_id'] for t in excluded]
        refresh_task_dependencies(state, strict=True)
        report["queue_simulation"] = verify_claim_order(state, scheduling_graph)
        report["load_faults"] = load_fault_probes(registry)
        report["fixture_sql"] = fixture_sql_probes(registry, config)
        print("Queue order, 6 invalid-reference probes and fixture SQL order passed", flush=True)
        report["tasks"] = {}
        all_case_ids = set()
        for task in task_topological_order(state):
            verify_task(state, task, out / "generated")
            checks = task["checks"]
            require(all(checks.get(n, {}).get("returncode") == 0 for n in ("task_envelope", "lint", "generate")),
                    f"{task['factor_id']}: generation/envelope/lint failed: {checks}")
            # Check audit ran and wrote a valid report, not merely returncode 1.
            audit_path = out / "generated" / task["factor_id"] / "coverage_audit.json"
            audit = json.loads(audit_path.read_text(encoding="utf-8"))
            require(checks["audit"]["returncode"] in (0, 1), "audit tool failed")
            generated = json.loads((out / "generated/generation_report.json").read_text(encoding="utf-8"))
            manifests = generated["manifests"]
            cases = [case for m in manifests.values() for case in m["cases"]]
            ids = {case["case_id"] for case in cases}
            require(len(ids) == len(cases) and not ids & all_case_ids, "duplicate batch case id")
            all_case_ids.update(ids)
            snapshots = dependency_verification_snapshot(state, task)
            report["tasks"][task["factor_id"]] = {
                "status": task["status"], "case_count": len(cases),
                "manifest_count": len(manifests), "checks": checks,
                "audit_conclusions": audit["conclusions"],
                "dependency_input_snapshot": snapshots,
                "manifest_reports": {m: data["report"] for m,data in manifests.items()},
            }
            write_state(out / "queue.json", state)
            print(f"{task['factor_id']}: {len(cases)} cases; queue={task['status']}", flush=True)
        command = [sys.executable, str(ROOT / "scripts/generate_factor_package_sql.py"),
                   "--output-dir", str(out / "generated")]
        for manifest_id in sorted(selected_manifests):
            command += ["--manifest", manifest_id]
        generation = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        require(generation.returncode == 0, generation.stdout + generation.stderr)
        aggregate = json.loads((out / "generated/generation_report.json").read_text(encoding="utf-8"))
        actual_targets = {c["case_id"]: c["sql"] for m in aggregate["manifests"].values() for c in m["cases"]}
        require(actual_targets == baseline_targets, "dependency changes altered target SQL/case identities")
        report["target_sql_regression"] = {
            "baseline_path": str(baseline_path), "baseline_cases": len(baseline_targets),
            "actual_cases": len(actual_targets), "unchanged": True,
            "batch_generation_report": str(out / "generated/generation_report.json"),
        }
        report["invalidation"] = invalidation_probes(
            state, graph, config["mutation_providers"], config.get('supplemental_body_consumers'))
        report["factor_count"] = len(state["tasks"])
        report["unique_case_count"] = len(all_case_ids)
        report["passed"] = True
    except Exception as exc:
        report["error"] = f"{type(exc).__name__}: {exc}"
        print(report["error"], file=sys.stderr, flush=True)
    finally:
        report["finished_at"] = utc_now()
        (out / "dependency_report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    print(f"passed={report['passed']} report={out / 'dependency_report.json'}", flush=True)
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
