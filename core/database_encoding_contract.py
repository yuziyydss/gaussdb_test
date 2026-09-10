"""Finite server encoding / template / locale agreement, never execution approval."""


def check_server_encoding_context(factor, manifest, encoding, values, sql, setup, teardown):
    def require(condition, message):
        if not condition:
            raise ValueError('server_encoding_context: ' + message)

    chapter = factor.source.catalog_chapter_ref
    require(chapter is not None and chapter.source_relpath == 'general/ddl/create_database.txt',
            'reviewed general CREATE DATABASE source required')
    require(manifest.expected.default == 'success' and manifest.expected.scope == 'syntax_only',
            'finite positive syntax candidate only')
    props = encoding.attributes
    require(props.get('encoding.properties.encoding_contract') == 'server_c_template0_pg',
            'explicit finite encoding contract required')
    original = values.get(props.get('encoding.properties.original_value_ref'))
    require(original is not None and original.validity == 'conditional', 'original conditional capability required')
    require(original.attributes.get('encoding.properties.server_supported') is True
            and props.get('encoding.properties.server_supported') is True
            and original.render == encoding.render, 'render must match original server-supported encoding')
    facts = {fact.id: fact for fact in factor.facts}
    server_facts = [facts[ref] for ref in original.fact_refs if ref.endswith('_server') and ref in facts]
    require(len(server_facts) == 1 and server_facts[0].status == 'confirmed'
            and server_facts[0].statement == original.render.strip("'") + '服务端支持：true。',
            'confirmed server table fact required')
    require({server_facts[0].id, 'create_database_fact_c_posix', 'create_database_fact_template_locale'}
            <= set(encoding.fact_refs), 'encoding and context provenance required')
    required_gates = {'createdb_authorized': ['true'], 'autocommit_no_transaction_block': ['true'],
                      'template_upgrade_in_progress': ['false'], 'isolated_database_name_available': ['b8_database'],
                      'locale_available': ['C'], 'database_recyclebin': ['off'], 'target_database_connections': ['none']}
    gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
    require(len(gates) == len(manifest.environment_requirements), 'duplicate or conflicting environment gates')
    require(all(gates.get(key) == value for key, value in required_gates.items()), 'complete finite environment gates required')
    expected_sql = ("CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = " + encoding.render
                    + " LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;")
    require(sql == expected_sql, 'SQL outside the reviewed C/template0/PG shape')
    require(setup == ["SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';"],
            'read-only absent-name preflight required')
    require(teardown == ['DROP DATABASE b8_database;'], 'owned-name cleanup without blind IF EXISTS/PURGE required')
    return {'status': 'checked', 'scope': 'finite_encoding_context', 'runtime_proven': False,
            'cleanup_ownership_proven': False, 'original_value_ref': original.id}
