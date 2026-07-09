#!/bin/bash -ex

UXN_PATH="${UXN_PATH:-$HOME/Programs/uxn}"

mkdir -p "$UXN_PATH"
cd "$UXN_PATH"

[[ -d uxn2 ]] || git clone --depth=1 'https://git.sr.ht/~rabbits/uxn2'
cd uxn2

make PREFIX="$UXN_PATH" install
make bin/drifblim.rom
cp bin/drifblim.rom "$UXN_PATH/bin/drifblim.rom"
