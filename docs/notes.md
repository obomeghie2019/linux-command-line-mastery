# Detailed Notes

All output below was produced by running the commands in a Linux sandbox (Debian/Ubuntu-style, running as `root`). Raw logs are in `../artifacts/`.

## 1. File Management

Session log: `artifacts/task1_2_session.log`

| Command | What I did | Observation |
|---|---|---|
| `mkdir -p project/{src,docs,logs}` | Created three sibling directories in one command | Brace expansion is done by the shell, not by `mkdir` |
| `touch project/src/a.txt` | Created empty files | `touch` also updates timestamps on existing files |
| `cp a.txt docs/a_copy.txt` | Copied a file | Original remains; `cp -r` is needed for directories |
| `mv b.txt renamed_b.txt` | Renamed a file | `mv` renames and moves with the same command |
| `rm file` / `rm -r dir` | Deleted a file, then an empty directory tree | No recycle bin: deletion is permanent |
| `rm -i file` | Prompted before deleting | The prompt appeared (`remove regular empty file ...?`) and I answered `y` |
| `cat`, `head -n 2`, `tail -n 2` | Viewed whole file, first and last lines | `less` is interactive, so it is not captured in a log; use `q` to quit |
| `grep -n ERROR a.txt` | Found matching lines with numbers | Matched lines 2 and 4 |
| `find project -name "*.txt"` | Located files by name | Lists recursively; output order is not sorted |

## 2. Directory Navigation

- `pwd` prints the current directory.
- **Relative path:** `cd a/b/c` resolves from the current directory (`/tmp/lab/a/b/c`).
- **Absolute path:** `cd /etc` starts at `/` and works from anywhere.
- `mkdir -p a/b/c/d` created the whole nested chain at once; without `-p` it fails if a parent is missing.
- Standard directories explored: `/etc` (configuration), `/var` (variable data: logs, spool, cache), `/tmp` (temporary files).
- `ls -ld /tmp` showed `drwxrwxrwt`. The trailing `t` is the **sticky bit**: anyone can create files, but only the owner can delete their own.

## 3. System Monitoring and Administration

Session log: `artifacts/task3_4_5_session.log`

- `ps aux`: lists all processes (user, PID, CPU%, MEM%, command). PID 1 is the init process.
- `top -b -n 1`: batch-mode snapshot of load, tasks (65 total) and memory; `-b -n 1` makes it log-friendly.
- `df -h`: disk usage in human-readable units. Root filesystem `/` was 29% used.
- `free -m`: memory in MB. About 8 GB total, with about 7.5 GB free and no swap.
- `uptime`: time, uptime and load averages (all near 0, so the machine was idle).

**Users, groups, permissions** (created temporary `labuser` and `labgroup`, then removed them):

```
groupadd labgroup
useradd -m -G labgroup labuser     # -m home dir, -G supplementary group
chmod 640 lab_file.txt             # rw- r-- ---
chmod u+x,o-r lab_file.txt         # symbolic mode: add execute for owner, remove read for others
chown labuser:labgroup lab_file.txt
userdel -r labuser ; groupdel labgroup
```

Permission progression seen in `ls -l`: `-rw-r--r--` -> `-rw-r-----` -> `-rwxr-----` -> owner changed to `labuser labgroup`.

**Note on `sudo`:** the sandbox runs as root, so `sudo` was not needed. It exists at `/usr/bin/sudo`. On a normal machine, prefix the admin commands above with `sudo`.

## 4. Networking Basics

Session log: `artifacts/task4_network_session.log`

### Troubleshooting (important)

`ip`, `ss`, `netstat` and `ping` were **not installed** in the sandbox (`command not found`), and `apt-get install iproute2 iputils-ping net-tools` failed with `Unable to locate package`: the sandbox has no access to the apt package lists.

So I could not demonstrate these four commands here. What I did instead:

| Intended command | Fallback used | Result |
|---|---|---|
| `ip addr` | `cat /proc/net/dev` | Interfaces `lo`, `eth0` (plus `ifb0`, `ifb1`) with byte/packet counters |
| `ss -tuln` / `netstat -tuln` | `head /proc/net/tcp` | Raw listening sockets (state `0A` = LISTEN) in hex |
| `ping` | none available | Not demonstrated |

**What you should do on your own machine** (I recommend re-running these and replacing `screenshots/03_...png`):

```bash
ip addr                 # interfaces and IP addresses
ping -c 4 8.8.8.8       # connectivity test, 4 packets
ping -c 4 google.com    # also tests DNS
ss -tuln                # listening TCP/UDP ports (modern replacement for netstat)
netstat -tuln           # older equivalent
```

If missing: `sudo apt install iproute2 iputils-ping net-tools` (Debian/Ubuntu).

## 5. Pipes and Redirection

Test data: `artifacts/people.txt` (name, age, city).

| Command | Result |
|---|---|
| `echo first > out.txt` | `>` overwrites |
| `echo second >> out.txt` | `>>` appends; file has two lines |
| `ls /nonexistent 2> err.txt` | `2>` sends only errors to a file |
| `ls /nonexistent people.txt > both.txt 2>&1` | Stdout and stderr both go to one file |
| `grep NY people.txt \| sort -k2 -n` | Filter then sort numerically by column 2 |
| `awk '{print $3}' people.txt \| sort \| uniq -c \| sort -rn` | City counts: NY 3, SF 1, LA 1 |
| `awk '{s+=$2} END {print s/NR}'` | Average age = 29 |
| `cut -d' ' -f2 people.txt \| sort -n \| uniq -d` | Duplicated ages: 25, 30 |

Key lesson: `uniq` only collapses **adjacent** duplicates, so always `sort` first.

## 6. Shell Script

File: `scripts/make_workspace.sh` (executable, `chmod +x`). Test log: `artifacts/script_run.log`.

Concepts used: variables, an array (`SUBDIRS`), a function (`log`), conditionals (`if`/`-z`/`-d`), nested `for` loops, counters, exit codes, and logging with `>>`.

Tests run:
1. Fresh run, two projects: 6 directories created.
2. Re-run with one repeated project: 3 skipped, 3 created. The script is idempotent.
3. No arguments: prints usage and exits with code 1.

## General observations

- The shell resets the working directory between tool calls in this environment, so I used full paths and ran related commands in one block.
- `rm -r` and `chown` are the commands with the least forgiveness; check the path first.
