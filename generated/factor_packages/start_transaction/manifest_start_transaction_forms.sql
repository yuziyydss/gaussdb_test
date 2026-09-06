-- generated_from: manifest_start_transaction_forms
-- static_only: true
-- case_count: 92

-- case_id: manifest_start_transaction_forms_223d63ce7c0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_absent", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_750393da61f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_ed06b0c720b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_355426599c0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_fafda6eee832
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_18564cb75123
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_f96d50f13e61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_1cf550edd48e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_ab45e3871c5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ WRITE, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_84b738ecce9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_54cfa3976b94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ ONLY, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_fb6fcc884067
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_332539afd17d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ WRITE, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_9e9a9e599cbd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_2abfa99c35b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ ONLY, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_3b55e796843d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_91d9e2a42a20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ WRITE, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_9046c42bb5c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_07410b1e352e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ ONLY, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_80de018ea0c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_81592257eb1c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ WRITE, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_f81aac25cf02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_0", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_a2d204839654
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_1", "command_form": "start_transaction_command_form_start"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
START TRANSACTION READ ONLY, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_a31704de1327
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_absent", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_2f10e384bf3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_d4eda676370e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_2c4635df3b61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_1e362f1b13ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_237db9453d15
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_82227b0caebd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_7cca3f6b6407
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_869205ed7f5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ WRITE, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_76945da2fdaf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_e7c3dafb94ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ ONLY, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_a79b4615c696
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_68b095a013aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ WRITE, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_3fbedf5a340f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_ec500248944d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ ONLY, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_39c9e04cf084
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_b2fde57ec4cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ WRITE, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_5f7be3848d1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_37a89d56daec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ ONLY, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_f9acc907ea23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_8a7f9047398a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ WRITE, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_b6872b12c1d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_0", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_92a180cf069e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_1", "command_form": "start_transaction_command_form_begin"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN READ ONLY, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_c80f9b17406e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_absent", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_af58a9877145
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_5318076e2043
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_1e2bf15d12d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_93ade2379a5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_902b16848ce5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_7aeabaf14f4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_5acd085054be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_3d94dff4413f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ WRITE, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_2d44e1a82905
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_8a6cd74d7934
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ ONLY, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_b10f2ba0ce52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_637d117eb6f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ WRITE, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_28acaf29e13c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_33e01b475fa1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ ONLY, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_d8949a44a0e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_5e0b1691611e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ WRITE, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_fd67486cf6d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_d4e2443486c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ ONLY, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_4b8584642fd1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_15b8810e325b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ WRITE, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_af0ed690d32e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_0", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_2f6a24b0c64a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_1", "command_form": "start_transaction_command_form_begin_work"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN WORK READ ONLY, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_85c0c9d32bf5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_absent", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_aa0462269120
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_04c902595112
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_d4a64bb40c28
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_73de845ac66e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_aa693e61870f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_93fb3ce4bdda
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_mode_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_f655740c3c42
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_6661e306e566
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_0_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ WRITE, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_3e8d3e0f4949
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_9456dd37dbf5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_0_mode_1_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ ONLY, ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_0d79028276fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_5e58e9a2bcfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_0_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ WRITE, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_4d79ccd71c54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_48dba92cb94b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_1_mode_1_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ ONLY, ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_6b93d183a0dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_c81cf3314298
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_0_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ WRITE, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_4ebc5694b917
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_aca0b2da262e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_2_mode_1_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ ONLY, ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_50e5408136a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_032ef84acecd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_0_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ WRITE, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_782897d082bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_0", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_start_transaction_forms_cc4b96ad445a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristics": "start_transaction_characteristics_iso_3_mode_1_order_1", "command_form": "start_transaction_command_form_begin_transaction"}
-- fixture_setup:
ROLLBACK;
-- test_sql:
BEGIN TRANSACTION READ ONLY, ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;
