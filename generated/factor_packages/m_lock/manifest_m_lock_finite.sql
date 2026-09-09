-- generated_from: manifest_m_lock_finite
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_lock_finite_984735f081ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_none", "mode": "m_lock_mode_default", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK m_lock_one;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_9f44ca966c35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_two", "keyword": "m_lock_keyword_none", "mode": "m_lock_mode_read", "nowait": "m_lock_nowait_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK m_lock_one READ, m_lock_two READ NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_6b8935dff162
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_table", "mode": "m_lock_mode_write", "nowait": "m_lock_nowait_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLE m_lock_one WRITE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_6964d4539dff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_two", "keyword": "m_lock_keyword_table", "mode": "m_lock_mode_access", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLE m_lock_one IN ACCESS SHARE MODE, m_lock_two IN ACCESS SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_4c933723f24b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_tables", "mode": "m_lock_mode_read", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLES m_lock_one READ;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_49b9cbcad034
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_two", "keyword": "m_lock_keyword_tables", "mode": "m_lock_mode_default", "nowait": "m_lock_nowait_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLES m_lock_one , m_lock_two NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_2e4c83c3aaed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_none", "mode": "m_lock_mode_access", "nowait": "m_lock_nowait_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK m_lock_one IN ACCESS SHARE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_41cd03f494ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_two", "keyword": "m_lock_keyword_none", "mode": "m_lock_mode_write", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK m_lock_one WRITE, m_lock_two WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_2b474a3c6c47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_table", "mode": "m_lock_mode_default", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLE m_lock_one;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_5484e20055f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_table", "mode": "m_lock_mode_read", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLE m_lock_one READ;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_9d74272e0d79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_tables", "mode": "m_lock_mode_write", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLES m_lock_one WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;

-- case_id: manifest_m_lock_finite_de531803d4a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_tables", "mode": "m_lock_mode_access", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK TABLES m_lock_one IN ACCESS SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;
