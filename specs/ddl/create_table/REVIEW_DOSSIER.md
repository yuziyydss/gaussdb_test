# CREATE TABLE PDF-first review dossier

This dossier is a bounded-progress checkpoint for
`doc2spec_general_ddl_create_table`. It is not a substitute for executable
Factor Package YAML and makes no database-execution claim.

## Verified envelope

- Source: `work/doc2spec/batches/batch_02/corpus/general/ddl/create_table.txt`
- Source SHA-256: `72695d2ef4e74ead050103c403da14ae56d378333a41f421336d5e64a3215bc6`
- Source lines: `1351`
- Parent PDF SHA-256: `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`
- Document: `gaussdb_v2_0_10_0_0_centralized_reference_01`
- Product version: `V2.0-10.0.0`
- Section: `1.13.9.48 CREATE TABLE`
- Physical pages: `1532-1558`; printed pages: `1483-1509`
- Extraction rule: `gaussdb-pdf-outline-v1`

## Frozen page/line segmentation

| Physical page | Printed page | Source lines | Main content |
| --- | --- | ---: | --- |
| 1532 | 1483 | 1-28 | purpose, cautions, permission and global limits |
| 1533 | 1484 | 29-97 | main grammar, table/HTAP/column/table constraint grammars |
| 1534 | 1485 | 98-144 | LIKE/index/identity grammars, UNLOGGED and temporary tables |
| 1535 | 1486 | 145-189 | temporary-table restrictions, IF NOT EXISTS, names |
| 1536 | 1487 | 190-241 | constraint/index names, method and sort compatibility |
| 1537 | 1488 | 242-295 | expression, data type, character set/collation catalogue |
| 1538 | 1489 | 296-345 | remaining collations and LIKE copy options |
| 1539 | 1490 | 346-395 | LIKE edge cases, AUTO_INCREMENT and COMMENT |
| 1540 | 1491 | 396-444 | COMMENT limits, ENGINE, COLVIEW and FILLFACTOR |
| 1541 | 1492 | 445-492 | ORIENTATION, STORAGE_TYPE, TOAST, INIT_TD, COMPRESSLEVEL |
| 1542 | 1493 | 493-537 | segment, TDE and parallel_workers |
| 1543 | 1494 | 538-581 | hasuids, internal collate/statistics and autovacuum |
| 1544 | 1495 | 582-621 | autovacuum ages, vacuum_truncate and hasrowid |
| 1545 | 1496 | 622-672 | hasrowid restrictions, OIDS, ON COMMIT and ILM |
| 1546 | 1497 | 673-719 | ILM, TABLESPACE and base constraint semantics |
| 1547 | 1498 | 720-771 | ON UPDATE, generated columns and identity start |
| 1548 | 1499 | 772-820 | identity modes/options/restrictions |
| 1549 | 1500 | 821-868 | AUTO_INCREMENT and table charset/collation |
| 1550 | 1501 | 869-915 | UNIQUE, PRIMARY KEY and foreign-key matching/actions |
| 1551 | 1502 | 916-966 | FK actions, deferral, encryption and basic examples |
| 1552 | 1503 | 967-1035 | storage/TDE/temp/charset/IF NOT EXISTS examples |
| 1553 | 1504 | 1036-1105 | duplicate-name, tablespace, AUTO_INCREMENT and LIKE examples |
| 1554 | 1505 | 1106-1173 | LIKE, NOT NULL and UNIQUE examples |
| 1555 | 1506 | 1174-1240 | primary-key and CHECK examples; FK introduction |
| 1556 | 1507 | 1241-1300 | FK example, related links and UNLOGGED guidance |
| 1557 | 1508 | 1301-1347 | optimization recap of TEMP/LIKE options |
| 1558 | 1509 | 1348-1351 | ORIENTATION ROW guidance |

## Planned source-ledger decomposition

The ledger is divided at headings, bullets, individual storage parameters,
individual constraint semantics, and example phases. The current plan has
approximately 230 units; ordinary units stay within twelve source lines.
Long examples are split into setup, operation, observed result, and cleanup.
Enumerated independent claims use grouped atomicity with one fact per claim.

## Bounded V1 model

The executable syntax model will cover only the chapter-confirmed core:

- `CREATE TABLE`, optional `IF NOT EXISTS`, and a generated table name;
- permanent, `UNLOGGED`, and finite `TEMP`/`TEMPORARY` spellings;
- one-column and small multi-column definition profiles drawn from examples;
- a structured AST repeat for the finite column list;
- separate manifests for ordinary, temporary, and unlogged syntax.

The following remain explicit `open_question`/`needs_profile` domains rather
than being guessed into executable SQL:

- unbounded table-element and per-column constraint repetitions;
- complete data-type and expression languages;
- `LIKE` inheritance options and their partition/ROWID/sequence interactions;
- column/table constraints, FK actions, deferral and encryption setup;
- the full storage-parameter catalogue and environment-dependent ranges;
- HTAP/COLVIEW, ILM whitelist expressions and TDE key-service prerequisites;
- identity and AUTO_INCREMENT cross-mode combinations;
- partition syntax referenced by prose but absent from this chapter's main
  production;
- cross-chapter method, partition-mode, system-column and function details;
- target SQLSTATE/error identities not printed by this chapter.

All behavior, permission, compatibility-mode, lifecycle and metadata claims
will be routed to planned scenarios. The expected queue state is
`needs_review`.
