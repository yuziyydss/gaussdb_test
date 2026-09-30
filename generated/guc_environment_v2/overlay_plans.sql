-- GaussDB GUC Environment V2 session overlay plans
-- Static plan export; this file is not an execution receipt.

-- parameter: a_format_enable_copy_empty_lobs
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('a_format_enable_copy_empty_lobs', true) AS value;

-- apply
SET a_format_enable_copy_empty_lobs = 'off';

-- verify_target
SELECT current_setting('a_format_enable_copy_empty_lobs', true) AS value;

-- restore
SET a_format_enable_copy_empty_lobs = 'on';

-- verify_restore
SELECT current_setting('a_format_enable_copy_empty_lobs', true) AS value;

-- parameter: b_format_behavior_compat_options
-- original: ''
-- target: 'enable_set_variables'
-- capture_original
SELECT current_setting('b_format_behavior_compat_options', true) AS value;

-- apply
SET b_format_behavior_compat_options = 'enable_set_variables';

-- verify_target
SELECT current_setting('b_format_behavior_compat_options', true) AS value;

-- restore
SET b_format_behavior_compat_options = '';

-- verify_restore
SELECT current_setting('b_format_behavior_compat_options', true) AS value;

-- parameter: behavior_compat_options
-- original: ''
-- target: 'display_leading_zero'
-- capture_original
SELECT current_setting('behavior_compat_options', true) AS value;

-- apply
SET behavior_compat_options = 'display_leading_zero';

-- verify_target
SELECT current_setting('behavior_compat_options', true) AS value;

-- restore
SET behavior_compat_options = '';

-- verify_restore
SELECT current_setting('behavior_compat_options', true) AS value;

-- parameter: default_transaction_isolation
-- original: 'read committed'
-- target: 'repeatable read'
-- capture_original
SELECT current_setting('default_transaction_isolation', true) AS value;

-- apply
SET default_transaction_isolation = 'repeatable read';

-- verify_target
SELECT current_setting('default_transaction_isolation', true) AS value;

-- restore
SET default_transaction_isolation = 'read committed';

-- verify_restore
SELECT current_setting('default_transaction_isolation', true) AS value;

-- parameter: default_transaction_read_only
-- original: 'off'
-- target: 'on'
-- capture_original
SELECT current_setting('default_transaction_read_only', true) AS value;

-- apply
SET default_transaction_read_only = 'on';

-- verify_target
SELECT current_setting('default_transaction_read_only', true) AS value;

-- restore
SET default_transaction_read_only = 'off';

-- verify_restore
SELECT current_setting('default_transaction_read_only', true) AS value;

-- parameter: enable_copy_case_sensitive
-- original: 'off'
-- target: 'on'
-- capture_original
SELECT current_setting('enable_copy_case_sensitive', true) AS value;

-- apply
SET enable_copy_case_sensitive = 'on';

-- verify_target
SELECT current_setting('enable_copy_case_sensitive', true) AS value;

-- restore
SET enable_copy_case_sensitive = 'off';

-- verify_restore
SELECT current_setting('enable_copy_case_sensitive', true) AS value;

-- parameter: enable_copy_when_filler
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_copy_when_filler', true) AS value;

-- apply
SET enable_copy_when_filler = 'off';

-- verify_target
SELECT current_setting('enable_copy_when_filler', true) AS value;

-- restore
SET enable_copy_when_filler = 'on';

-- verify_restore
SELECT current_setting('enable_copy_when_filler', true) AS value;

-- parameter: enable_hashjoin
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_hashjoin', true) AS value;

-- apply
SET enable_hashjoin = 'off';

-- verify_target
SELECT current_setting('enable_hashjoin', true) AS value;

-- restore
SET enable_hashjoin = 'on';

-- verify_restore
SELECT current_setting('enable_hashjoin', true) AS value;

-- parameter: enable_indexonlyscan
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_indexonlyscan', true) AS value;

-- apply
SET enable_indexonlyscan = 'off';

-- verify_target
SELECT current_setting('enable_indexonlyscan', true) AS value;

-- restore
SET enable_indexonlyscan = 'on';

-- verify_restore
SELECT current_setting('enable_indexonlyscan', true) AS value;

-- parameter: enable_indexscan
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_indexscan', true) AS value;

-- apply
SET enable_indexscan = 'off';

-- verify_target
SELECT current_setting('enable_indexscan', true) AS value;

-- restore
SET enable_indexscan = 'on';

-- verify_restore
SELECT current_setting('enable_indexscan', true) AS value;

-- parameter: enable_log_copy_illegal_chars
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_log_copy_illegal_chars', true) AS value;

-- apply
SET enable_log_copy_illegal_chars = 'off';

-- verify_target
SELECT current_setting('enable_log_copy_illegal_chars', true) AS value;

-- restore
SET enable_log_copy_illegal_chars = 'on';

-- verify_restore
SELECT current_setting('enable_log_copy_illegal_chars', true) AS value;

-- parameter: enable_material
-- original: 'off'
-- target: 'on'
-- capture_original
SELECT current_setting('enable_material', true) AS value;

-- apply
SET enable_material = 'on';

-- verify_target
SELECT current_setting('enable_material', true) AS value;

-- restore
SET enable_material = 'off';

-- verify_restore
SELECT current_setting('enable_material', true) AS value;

-- parameter: enable_nestloop
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_nestloop', true) AS value;

-- apply
SET enable_nestloop = 'off';

-- verify_target
SELECT current_setting('enable_nestloop', true) AS value;

-- restore
SET enable_nestloop = 'on';

-- verify_restore
SELECT current_setting('enable_nestloop', true) AS value;

-- parameter: enable_seqscan
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_seqscan', true) AS value;

-- apply
SET enable_seqscan = 'off';

-- verify_target
SELECT current_setting('enable_seqscan', true) AS value;

-- restore
SET enable_seqscan = 'on';

-- verify_restore
SELECT current_setting('enable_seqscan', true) AS value;

-- parameter: enable_sort
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_sort', true) AS value;

-- apply
SET enable_sort = 'off';

-- verify_target
SELECT current_setting('enable_sort', true) AS value;

-- restore
SET enable_sort = 'on';

-- verify_restore
SELECT current_setting('enable_sort', true) AS value;

-- parameter: enable_tidscan
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('enable_tidscan', true) AS value;

-- apply
SET enable_tidscan = 'off';

-- verify_target
SELECT current_setting('enable_tidscan', true) AS value;

-- restore
SET enable_tidscan = 'on';

-- verify_restore
SELECT current_setting('enable_tidscan', true) AS value;

-- parameter: plan_cache_mode
-- original: 'auto'
-- target: 'force_custom_plan'
-- capture_original
SELECT current_setting('plan_cache_mode', true) AS value;

-- apply
SET plan_cache_mode = 'force_custom_plan';

-- verify_target
SELECT current_setting('plan_cache_mode', true) AS value;

-- restore
SET plan_cache_mode = 'auto';

-- verify_restore
SELECT current_setting('plan_cache_mode', true) AS value;

-- parameter: sql_beta_feature
-- original: 'none'
-- target: 'sel_expr_instr'
-- capture_original
SELECT current_setting('sql_beta_feature', true) AS value;

-- apply
SET sql_beta_feature = 'sel_expr_instr';

-- verify_target
SELECT current_setting('sql_beta_feature', true) AS value;

-- restore
SET sql_beta_feature = 'none';

-- verify_restore
SELECT current_setting('sql_beta_feature', true) AS value;

-- parameter: track_procedure_sql
-- original: 'on'
-- target: 'off'
-- capture_original
SELECT current_setting('track_procedure_sql', true) AS value;

-- apply
SET track_procedure_sql = 'off';

-- verify_target
SELECT current_setting('track_procedure_sql', true) AS value;

-- restore
SET track_procedure_sql = 'on';

-- verify_restore
SELECT current_setting('track_procedure_sql', true) AS value;
