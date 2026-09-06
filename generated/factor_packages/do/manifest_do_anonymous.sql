-- generated_from: manifest_do_anonymous
-- static_only: true
-- case_count: 4

-- case_id: manifest_do_anonymous_f6bccb012b09
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"code": "do_code_empty", "language": "do_language_default"}
-- test_sql:
DO 'BEGIN NULL; END;';

-- case_id: manifest_do_anonymous_05f578ef1928
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"code": "do_code_scalar", "language": "do_language_default"}
-- test_sql:
DO 'DECLARE n INTEGER; BEGIN n := 1 + 2; END;';

-- case_id: manifest_do_anonymous_4c6218f9a3dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"code": "do_code_empty", "language": "do_language_explicit"}
-- test_sql:
DO LANGUAGE plpgsql 'BEGIN NULL; END;';

-- case_id: manifest_do_anonymous_989efe5f403c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"code": "do_code_scalar", "language": "do_language_explicit"}
-- test_sql:
DO LANGUAGE plpgsql 'DECLARE n INTEGER; BEGIN n := 1 + 2; END;';
