# 🗺️ EKV Project Roadmap

## v0.7 - v0.9 (Current prerelease) — Core & Persistence
- [x] In-memory `EKV_STORE` based on `HASH_TABLE`
- [x] Interactive CLI REPL (`set`, `get`, `del`, `exit`)
- [x] Append-Only WAL (`EKV_WAL`) for writing on disk
- [x] Support of Tombstone-markers for deleting
- [x] Precondition and postcondition verification via Design by Contract

## v1.0 - Log Compaction & Maintenance
- [ ] **Compaction** mechanism (cleaning `ekv.log` from tombstones and old keys duplicates)
- [ ] command `stats` in CLI (viewing count of elements in memory and size of log on disk)
- [ ] command `keys` (displaying all active keys)

## v1.2 - Performance & Integrity
- [ ] Checksums (CRC32) in WAL to protect against corruption during power failures
- [ ] Configurable disk flushing policy (`fsync` / `buffered`)