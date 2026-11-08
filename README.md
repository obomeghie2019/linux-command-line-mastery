# Linux Command Line Mastery

Hands-on practice with the Linux command line: files, navigation, system monitoring, permissions, networking, pipes and a reusable Bash script.

## Repository Structure

```
linux-command-line-mastery/
├── README.md          # this file
├── docs/notes.md      # detailed outputs, observations, troubleshooting
├── scripts/           # make_workspace.sh (commented, executable)
├── screenshots/       # terminal captures of the sessions
└── artifacts/         # raw session logs and sample data
```

## Command List

| Area | Commands |
|---|---|
| Files | `touch` `cp` `mv` `rm` `rm -i` `rm -r` `cat` `less` `head` `tail` `find` `grep` |
| Navigation | `pwd` `cd` (absolute/relative) `mkdir -p` `ls` ; `/etc` `/var` `/tmp` |
| Monitoring | `ps aux` `top` `df -h` `free -m` `uptime` |
| Admin | `useradd` `groupadd` `userdel` `groupdel` `chmod` `chown` `sudo` |
| Networking | `ping` `ip addr` `ss` `netstat` (see note below) |
| Pipes/redirection | `>` `>>` `2>` `2>&1` `\|` `grep` `awk` `sort` `uniq` `cut` |
| Scripting | variables, arrays, functions, `if`, `for`, exit codes, logging |

## Completion Checklist

- [x] 1. File management (create, copy, move, delete, view, search)
- [x] 2. Directory navigation (absolute vs relative, `mkdir -p`, `/etc` `/var` `/tmp`)
- [x] 3. System monitoring (`ps`, `top`, `df`, `free`, `uptime`)
- [x] 3. Users, groups, permissions (`chmod`, `chown`, `sudo` availability)
- [ ] 4. Networking: `ping`, `ip addr`, `ss`/`netstat` **(not available in my sandbox: re-run on your own machine, see `docs/notes.md`)**
- [x] 5. Pipes and redirection (`>`, `>>`, `2>`, `\|`, `awk`, `sort`, `uniq`)
- [x] 6. Shell script with variables, conditionals, loops, logging; made executable
- [x] Documentation, artifacts and screenshots

## Running the Script

```bash
chmod +x scripts/make_workspace.sh
./scripts/make_workspace.sh ~/lab project1 project2
cat ~/lab/workspace.log
```

## Notes on Evidence

- Outputs in `artifacts/` are real command output captured from a Linux session.
- Images in `screenshots/` are **rendered from those logs** into terminal-style PNGs. For your submission, replace or add real screenshots from your own terminal, especially for networking commands.
- Networking tools were missing in the environment where I ran these (no `ip`, `ss`, `netstat`, `ping`, and no apt access). I documented the failure and used `/proc/net` fallbacks; details in `docs/notes.md`.

## Learning Summary

- **Everything is text and streams.** Redirection and pipes let small tools (`grep`, `sort`, `uniq`, `awk`) combine into powerful one-liners. Remember to `sort` before `uniq`.
- **Paths matter.** Absolute paths work from anywhere; relative paths depend on `pwd`. `mkdir -p` and brace expansion save a lot of typing.
- **Permissions are three triplets** (owner, group, others). `chmod` changes who can do what; `chown` changes who owns it. The sticky bit on `/tmp` shows how permissions protect shared space.
- **Deletion is permanent.** Use `rm -i` when unsure and double-check `rm -r` targets.
- **Monitoring is quick:** `uptime` for load, `free -m` for memory, `df -h` for disk, `ps`/`top` for processes.
- **Troubleshooting is part of the skill.** When commands were missing, I checked `which`, tried installing, and fell back to `/proc` instead of stopping.
- **Scripts should be idempotent and log what they do.** `make_workspace.sh` skips existing directories and records every action with a timestamp.

