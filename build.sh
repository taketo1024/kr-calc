#!/usr/bin/env bash

set -x

swift build -c release
[ $? -eq 0 ]  || exit 1

dir=`swift build -c release --show-bin-path`
cp "${dir}/kr-calc" .
