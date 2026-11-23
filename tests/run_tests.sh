#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -x ./co ]]; then
    echo "ERROR: ./co is missing. Run 'make' first." >&2
    exit 1
fi

TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/co-tests.XXXXXX")"
cleanup() {
    rm -rf -- "$TEST_ROOT"
}
trap cleanup EXIT

PASS=0
FAIL=0

check_exists() {
    local description="$1"
    local path="$2"
    if [[ -e "$path" ]]; then
        printf 'PASS: %s\n' "$description"
        PASS=$((PASS + 1))
    else
        printf 'FAIL: %s (not found: %s)\n' "$description" "$path"
        FAIL=$((FAIL + 1))
    fi
}

check_absent() {
    local description="$1"
    local path="$2"
    if [[ ! -e "$path" ]]; then
        printf 'PASS: %s\n' "$description"
        PASS=$((PASS + 1))
    else
        printf 'FAIL: %s (unexpected path: %s)\n' "$description" "$path"
        FAIL=$((FAIL + 1))
    fi
}

check_output() {
    local description="$1"
    local expected="$2"
    local output="$3"
    if grep -Fq -- "$expected" <<< "$output"; then
        printf 'PASS: %s\n' "$description"
        PASS=$((PASS + 1))
    else
        printf 'FAIL: %s (missing output: %s)\n' "$description" "$expected"
        FAIL=$((FAIL + 1))
    fi
}

check_command_fails() {
    local description="$1"
    shift
    if "$@" >/dev/null 2>&1; then
        printf 'FAIL: %s (command unexpectedly succeeded)\n' "$description"
        FAIL=$((FAIL + 1))
    else
        printf 'PASS: %s\n' "$description"
        PASS=$((PASS + 1))
    fi
}

# Dry-run: it must show the plan without creating folders or moving files.
DRY_DIR="$TEST_ROOT/dry-run"
bash tests/setup_test_dir.sh "$DRY_DIR" >/dev/null
DRY_OUTPUT="$(./co "$DRY_DIR" --dry-run 2>&1)"
check_output "dry-run lists an image destination" '[DRY-RUN] foto.jpg -> Images/foto.jpg' "$DRY_OUTPUT"
check_output "unknown extensions use Others" '[DRY-RUN] aneh.xyz -> Others/aneh.xyz' "$DRY_OUTPUT"
check_exists "dry-run leaves foto.jpg in its original location" "$DRY_DIR/foto.jpg"
check_absent "dry-run does not create Images" "$DRY_DIR/Images"
check_absent "dry-run does not create Others" "$DRY_DIR/Others"

# Real run: check categories, uppercase extensions, hidden files and directories.
MOVE_DIR="$TEST_ROOT/real-run"
bash tests/setup_test_dir.sh "$MOVE_DIR" >/dev/null
MOVE_OUTPUT="$(./co --verbose "$MOVE_DIR" 2>&1)"
check_output "verbose mode reports a successful move" 'moving foto.jpg -> Images/foto.jpg' "$MOVE_OUTPUT"
check_exists "foto.jpg -> Images" "$MOVE_DIR/Images/foto.jpg"
check_exists "FOTO2.JPG -> Images (case-insensitive extension)" "$MOVE_DIR/Images/FOTO2.JPG"
check_exists "tugas.pdf -> Documents" "$MOVE_DIR/Documents/tugas.pdf"
check_exists "catatan.txt -> Documents" "$MOVE_DIR/Documents/catatan.txt"
check_exists "film.mp4 -> Videos" "$MOVE_DIR/Videos/film.mp4"
check_exists "lagu.mp3 -> Audio" "$MOVE_DIR/Audio/lagu.mp3"
check_exists "arsip.zip -> Archives" "$MOVE_DIR/Archives/arsip.zip"
check_exists "arsip.tar.gz -> Archives (last extension)" "$MOVE_DIR/Archives/arsip.tar.gz"
check_exists "kode.C -> Code (case-insensitive extension)" "$MOVE_DIR/Code/kode.C"
check_exists "file with trailing dot -> Others" "$MOVE_DIR/Others/file."
check_exists "aneh.xyz -> Others" "$MOVE_DIR/Others/aneh.xyz"
check_exists "file without extension -> Others" "$MOVE_DIR/Others/Makefile"
check_exists "hidden file remains untouched" "$MOVE_DIR/.hidden"
check_exists "existing directory remains untouched" "$MOVE_DIR/folder_lama"
check_absent "original foto.jpg path is empty after moving" "$MOVE_DIR/foto.jpg"

# Existing destination: the current file must not replace the existing one.
COLLISION_DIR="$TEST_ROOT/collision"
mkdir -p "$COLLISION_DIR/Images"
printf 'source file\n' > "$COLLISION_DIR/foto.jpg"
printf 'keep this file\n' > "$COLLISION_DIR/Images/foto.jpg"
COLLISION_OUTPUT="$(./co "$COLLISION_DIR" 2>&1)"
check_output "existing destination is reported as skipped" 'SKIP: foto.jpg already exists in Images' "$COLLISION_OUTPUT"
check_exists "source remains when destination already exists" "$COLLISION_DIR/foto.jpg"
if grep -Fq 'keep this file' "$COLLISION_DIR/Images/foto.jpg"; then
    printf 'PASS: existing destination content is preserved\n'
    PASS=$((PASS + 1))
else
    printf 'FAIL: existing destination content was changed\n'
    FAIL=$((FAIL + 1))
fi

# Argument and path validation.
check_command_fails "missing folder argument is rejected" ./co
check_command_fails "unknown option is rejected" ./co --not-a-real-option
NOT_A_DIR="$TEST_ROOT/not-a-directory"
touch "$NOT_A_DIR"
check_command_fails "a regular file is rejected as a folder" ./co "$NOT_A_DIR"

printf '\nResult: %d passed, %d failed\n' "$PASS" "$FAIL"
[[ "$FAIL" -eq 0 ]]
