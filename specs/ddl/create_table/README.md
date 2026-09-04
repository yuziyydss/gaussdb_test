# CREATE TABLE V1 bounded package

This package is deliberately `needs_review`. Its source ledger accounts for all 1,351 extracted lines, while executable generation is limited to the ordinary-table core that this chapter demonstrates directly: deterministic table names, one or two `INTEGER`/`VARCHAR` columns, optional `IF NOT EXISTS`, and permanent, `UNLOGGED`, `TEMP`, or `TEMPORARY` prefixes.

The package does not claim complete CREATE TABLE coverage. Constraints, `LIKE`, table options, storage parameters, identity/generated/on-update expressions, `GLOBAL`/`LOCAL` and `ON COMMIT`, ILM, HTAP, TDE, encrypted columns, partitioning, unbounded repetitions, compatibility modes, and cross-chapter domains remain explicit `needs_profile` features and planned scenarios. No database execution or SQLSTATE inference was performed.
