#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Getting Sources"
echo "= = ="

cmd="gem install --force --no-document --install-dir ./sources --bindir ./sources/bin --no-user-install test_bench"

echo $cmd
($cmd)

echo
echo "Done ($(basename "$0"))"
