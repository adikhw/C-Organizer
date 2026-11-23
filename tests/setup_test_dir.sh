#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="${1:-$HOME/test-downloads}"

# Never delete or overwrite an existing directory: it may contain real files.
if [[ -e "$TEST_DIR" ]]; then
    printf 'Refusing to use an existing path: %s\n' "$TEST_DIR" >&2
    printf 'Choose a new test path, or remove that test directory yourself first.\n' >&2
    exit 1
fi

mkdir -p -- "$TEST_DIR"

touch -- \
    "$TEST_DIR/foto.jpg" \
    "$TEST_DIR/FOTO2.JPG" \
    "$TEST_DIR/tugas.pdf" \
    "$TEST_DIR/catatan.txt" \
    "$TEST_DIR/film.mp4" \
    "$TEST_DIR/lagu.mp3" \
    "$TEST_DIR/arsip.zip" \
    "$TEST_DIR/arsip.tar.gz" \
    "$TEST_DIR/kode.C" \
    "$TEST_DIR/file." \
    "$TEST_DIR/aneh.xyz" \
    "$TEST_DIR/Makefile" \
    "$TEST_DIR/.hidden"
mkdir -- "$TEST_DIR/folder_lama"

printf 'Test directory created: %s\n' "$TEST_DIR"
