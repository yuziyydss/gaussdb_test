-- generated_from: manifest_begin_anonymous_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_begin_anonymous_positive_7663635f0581
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_absent", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_anonymous_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
BEGIN dbe_output.print_line('Hello'); END;

-- case_id: manifest_begin_anonymous_positive_a3be01ebc811
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_keyword_only", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_anonymous_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
DECLARE BEGIN dbe_output.print_line('Hello'); END;

-- case_id: manifest_begin_anonymous_positive_554ea44ce4ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"declare_clause": "begin_declare_one_integer", "execution_profile": "begin_exec_print_hello", "statement_form": "begin_anonymous_form", "transaction_characteristics": "begin_txn_characteristics_none", "transaction_keyword": "begin_txn_keyword_absent"}
-- test_sql:
DECLARE sales_cnt int; BEGIN dbe_output.print_line('Hello'); END;
