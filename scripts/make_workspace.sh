#!/usr/bin/env bash

set -uo pipefail

# ---------- Variables ----------
BASE_DIR="${1:-}"                      
SUBDIRS=("src" "docs" "logs")          
LOG_FILE=""                            
created=0                              
skipped=0                              

# ---------- Functions ----------
# log: print a timestamped message to the screen and append it to the log file
log() {
    local msg
    msg="$(date '+%Y-%m-%d %H:%M:%S') - $*"
    echo "$msg"
    if [ -n "$LOG_FILE" ]; then
        echo "$msg" >> "$LOG_FILE"
    fi
}

usage() {
    echo "Usage: $0 <base_dir> <name1> [name2 ...]" >&2
}

# ---------- Conditionals: validate input ----------
if [ -z "$BASE_DIR" ] || [ "$#" -lt 2 ]; then
    usage
    exit 1
fi

shift   # remove BASE_DIR so "$@" now holds only the project names

# Create the base directory if it does not exist yet
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR" || { echo "Cannot create $BASE_DIR" >&2; exit 2; }
fi

LOG_FILE="$BASE_DIR/workspace.log"
log "START: building workspace in $BASE_DIR for $# project(s)"

# ---------- Loops ----------
# Outer loop: each project name given on the command line
for name in "$@"; do
    # Inner loop: each standard subdirectory
    for sub in "${SUBDIRS[@]}"; do
        target="$BASE_DIR/$name/$sub"
        if [ -d "$target" ]; then
            log "SKIP: $target already exists"
            skipped=$((skipped + 1))
        else
            if mkdir -p "$target"; then
                log "CREATED: $target"
                created=$((created + 1))
            else
                log "ERROR: could not create $target"
            fi
        fi
    done
done

log "DONE: $created created, $skipped skipped"
exit 0
