#!/usr/bin/env zsh

wd=`dirname $(realpath $0)`

echo Install the Dagster project
pip install -e ".[dev]"

echo Start Demo in 'DEV'
echo \(output to current terminal session\)
pushd $wd/demo

dagster dev

popd
