#!/usr/bin/env bash
set -e

TEST_DIR="${1:-$HOME/test-downloads}"

rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

touch "$TEST_DIR/foto.jpg"
touch "$TEST_DIR/FOTO2.JPG"
touch "$TEST_DIR/tugas.pdf"
touch "$TEST_DIR/catatan.txt"
touch "$TEST_DIR/film.mp4"
touch "$TEST_DIR/lagu.mp3"
touch "$TEST_DIR/arsip.zip"
touch "$TEST_DIR/aneh.xyz"
touch "$TEST_DIR/Makefile"
touch "$TEST_DIR/.hidden"
mkdir -p "$TEST_DIR/folder_lama"

echo "Test dir ready in $TEST_DIR"
