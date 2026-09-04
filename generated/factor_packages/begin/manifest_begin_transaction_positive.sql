-- generated_from: manifest_begin_transaction_positive
-- static_only: true
-- case_count: 27

-- case_id: manifest_begin_transaction_positive_03c70eb7c856
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN;

-- case_id: manifest_begin_transaction_positive_bed5cf805376
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_begin_transaction_positive_4c2d14197c07
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_uncommitted", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_begin_transaction_positive_eb1796ec063f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_repeatable_read", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_begin_transaction_positive_df11c41ba14d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_serializable", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_begin_transaction_positive_c70d7cfbf724
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_write", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN READ WRITE;

-- case_id: manifest_begin_transaction_positive_237e4e9ceaf6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN READ ONLY;

-- case_id: manifest_begin_transaction_positive_a9789424312d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed_read_write", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED, READ WRITE;

-- case_id: manifest_begin_transaction_positive_f7ab3885a802
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only_repeatable", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN READ ONLY, ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_begin_transaction_positive_72c55d5124d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_begin_transaction_positive_30398c1915be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_uncommitted", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_begin_transaction_positive_db6d58190fed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK;

-- case_id: manifest_begin_transaction_positive_62849bee11a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_uncommitted", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_begin_transaction_positive_ae6f80620b0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_repeatable_read", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_begin_transaction_positive_00e2ca692789
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_serializable", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_begin_transaction_positive_5245faac25d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_write", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK READ WRITE;

-- case_id: manifest_begin_transaction_positive_4944f6ce9bcc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK READ ONLY;

-- case_id: manifest_begin_transaction_positive_0b66585b257c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed_read_write", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED, READ WRITE;

-- case_id: manifest_begin_transaction_positive_b0b2f2018809
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only_repeatable", "transaction_keyword": "begin_txn_keyword_work"}
-- test_sql:
BEGIN WORK READ ONLY, ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_begin_transaction_positive_297fc6967863
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION;

-- case_id: manifest_begin_transaction_positive_b4d4b0886bf0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_begin_transaction_positive_75aa2bddddbc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_repeatable_read", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_begin_transaction_positive_8e328eca5952
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_serializable", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_begin_transaction_positive_7e959abb8585
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_write", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION READ WRITE;

-- case_id: manifest_begin_transaction_positive_4a2733126d00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION READ ONLY;

-- case_id: manifest_begin_transaction_positive_9456a8f9e635
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_committed_read_write", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED, READ WRITE;

-- case_id: manifest_begin_transaction_positive_39afa83a6044
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_transaction_form", "transaction_characteristics": "begin_txn_read_only_repeatable", "transaction_keyword": "begin_txn_keyword_transaction"}
-- test_sql:
BEGIN TRANSACTION READ ONLY, ISOLATION LEVEL REPEATABLE READ;
