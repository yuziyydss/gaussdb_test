"""Read-only runtime preflight for GaussDB connection and GUC visibility.

This module never executes target SQL, changes GUC values, or creates objects.
It is intentionally separate from the runtime validation pilot.
"""
from __future__ import annotations

from typing import Dict, List, Protocol

from pydantic import BaseModel, ConfigDict, Field, field_validator


class StrictRuntimePreflightModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class RuntimePreflightQueryDef(StrictRuntimePreflightModel):
    key: str
    sql: str
    description: str

    @field_validator("key")
    @classmethod
    def ensure_key(cls, value: str) -> str:
        if not value or not value.replace("_", "").isalnum():
            raise ValueError("preflight query key 必须是安全标识")
        return value


class RuntimePreflightTransport(Protocol):
    def run(self, sql: str):
        ...


PREFLIGHT_QUERIES: List[RuntimePreflightQueryDef] = [
    RuntimePreflightQueryDef(
        key="server_version",
        sql="SELECT version() AS value;",
        description="数据库版本",
    ),
    RuntimePreflightQueryDef(
        key="sql_compatibility",
        sql="SELECT current_setting('sql_compatibility', true) AS value;",
        description="SQL兼容模式",
    ),
    RuntimePreflightQueryDef(
        key="enable_seqscan",
        sql="SELECT current_setting('enable_seqscan', true) AS value;",
        description="顺序扫描GUC",
    ),
    RuntimePreflightQueryDef(
        key="default_transaction_read_only",
        sql="SELECT current_setting('default_transaction_read_only', true) AS value;",
        description="事务只读GUC",
    ),
    RuntimePreflightQueryDef(
        key="behavior_compat_options",
        sql="SELECT current_setting('behavior_compat_options', true) AS value;",
        description="兼容行为选项",
    ),
]


class RuntimePreflightResult(StrictRuntimePreflightModel):
    kind: str = "runtime_preflight"
    schema_version: int = 1
    connected: bool
    metadata_read: bool = False
    target_sql_executed: bool = False
    guc_changed: bool = False
    object_created: bool = False
    queries: List[Dict[str, object]] = Field(default_factory=list)
    errors: List[str] = Field(default_factory=list)
    limits: List[str] = Field(default_factory=lambda: [
        "This preflight only reads metadata and current GUC values.",
        "It does not execute runtime pilot SQL.",
        "It does not prove advanced package behavior or runtime verification.",
    ])


class ScriptedPreflightTransport:
    def __init__(self, responses):
        self.responses = list(responses)
        self.calls: List[str] = []

    def run(self, sql: str):
        self.calls.append(sql)
        if not self.responses:
            raise AssertionError(f"unexpected SQL call: {sql}")
        return self.responses.pop(0)


def run_preflight(transport: RuntimePreflightTransport) -> RuntimePreflightResult:
    queries = []
    errors = []
    connected = False

    for query in PREFLIGHT_QUERIES:
        try:
            response = transport.run(query.sql)
        except Exception as exc:  # transport should normally return a result
            queries.append({
                "key": query.key,
                "sql": query.sql,
                "status": "error",
                "value": None,
                "error": str(exc),
            })
            errors.append(f"{query.key}: {exc}")
            continue

        if not getattr(response, "success", False):
            queries.append({
                "key": query.key,
                "sql": query.sql,
                "status": "error",
                "value": None,
                "error": getattr(response, "error", ""),
            })
            errors.append(f"{query.key}: {getattr(response, 'error', '')}")
            continue

        rows = getattr(response, "rows", []) or []
        value = rows[0][0] if rows and rows[0] else None
        queries.append({
            "key": query.key,
            "sql": query.sql,
            "status": "success",
            "value": value,
            "error": "",
        })
        connected = True

    return RuntimePreflightResult(
        connected=connected,
        metadata_read=connected and not errors,
        queries=queries,
        errors=errors,
    )
