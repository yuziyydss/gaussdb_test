-- generated_from: manifest_reassign_owned_dedicated_tables
-- static_only: true
-- case_count: 2

-- case_id: manifest_reassign_owned_dedicated_tables_e883070711da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"owners": "reassign_owned_owners_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_roles_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["true"], "fact_refs": ["reassign_owned_fact_privilege"], "key": "both_role_permissions"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_owned_a (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_owned_b (col_1 INTEGER, col_2 INTEGER);
ALTER TABLE b9_owned_a OWNER TO b9_role_a;
ALTER TABLE b9_owned_b OWNER TO b9_role_b;
-- test_sql:
REASSIGN OWNED BY b9_role_a TO b9_role_c;
-- fixture_teardown:
DROP TABLE IF EXISTS b9_owned_b;
DROP TABLE IF EXISTS b9_owned_a;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_reassign_owned_dedicated_tables_7bd3ae622766
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"owners": "reassign_owned_owners_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_roles_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["true"], "fact_refs": ["reassign_owned_fact_privilege"], "key": "both_role_permissions"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_owned_a (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_owned_b (col_1 INTEGER, col_2 INTEGER);
ALTER TABLE b9_owned_a OWNER TO b9_role_a;
ALTER TABLE b9_owned_b OWNER TO b9_role_b;
-- test_sql:
REASSIGN OWNED BY b9_role_a, b9_role_b TO b9_role_c;
-- fixture_teardown:
DROP TABLE IF EXISTS b9_owned_b;
DROP TABLE IF EXISTS b9_owned_a;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
