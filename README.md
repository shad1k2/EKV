# ⚡ EKV (Eiffel Key-Value Database)

**EKV** is a lightweight, performant Key-Value database written in **Eiffel**. It uses an **Append-Only Write-Ahead Log (WAL)** engine with Tombstone markers for persistence and **Design by Contract (DbC)** for runtime reliability.

---

## Features

* **O(1) Reads & Writes:** All data resides in memory (`HASH_TABLE`) for instant access.
* **Write-Ahead Logging (WAL):** Every mutation (`set`, `del`) is immediately appended to `ekv.log`.
* **Tombstone Deletion:** Key deletion works via append-only tombstone markers (`DEL`) without expensive disk rewrites.
* **State Recovery (Replay):** On startup, the database reconstructs its full state by replaying the log.
* **Design by Contract:** Built-in preconditions (`require`) and postconditions (`ensure`) guarantee state integrity.
* **Interactive CLI:** Built-in REPL for real-time interaction.

---

## Architecture

```
+--------------------------------------------------+
|                   EKV CLI / REPL                 |
+------------------------+-------------------------+
|
+-------------+-------------+
|                           |
v                           v
+---------------------+     +---------------------+
|      EKV_STORE      |     |       EKV_WAL       |
|  (In-Memory Index)  |     |  (Append-Only Log)  |
+---------------------+     +---------------------+
|  HASH_TABLE [K, V]  |     |  file: "ekv.log"    |
+---------------------+     +---------------------+
```

## Build & Installation

### Requirements
* **EiffelStudio** compiler (`ec`)
* `make`

### Building from Source

```bash
# Clone the repository
git clone https://github.com/shad1k2/ekv.git

# Build and run interactive CLI
make run

# (Optional) Install system-wide
sudo make install
```

## CLI Usage
```bash
=== EKV Interactive Shell v0.9 ===
Commands: set <key> <val> | del <key> | get <key> | exit

ekv> set user:1 some_name1
OK

ekv> set user:2 some_name2
OK

ekv> get user:1
=> some_name1

ekv> del user:1
OK

ekv> get user:1
(nil)

ekv> exit
Bye!
```
Upon restart, EKV automatically replays ekv.log to restore all active state.

##  Performance Benchmark

End-to-End benchmark executed via Python process IPC (`stdin`/`stdout` pipes) using Eiffel `F_code` (Finalized release build with `-O3` optimization and contracts disabled):

| Operation | Throughput | Total Time (50,000 ops) | Bottleneck Source |
| :--- | :--- | :--- | :--- |
| **GET** (RAM) | **70,547 ops/sec** | 0.708s | OS IPC Pipe & Python I/O |
| **SET** (Disk WAL) | **4,436 ops/sec** | 11.269s | Unbuffered Sync Disk I/O + IPC |

> **Note:** These numbers represent end-to-end Process IPC throughput. Native C-API (`libekv.so`) and buffered WAL benchmarks will be published in upcoming releases.
