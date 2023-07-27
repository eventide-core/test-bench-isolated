#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Updating lib/ Directory"
echo "= = ="

rm -rf lib

mkdir -p lib/test_bench_isolated

for input_file in $(find sources/gems/*/lib -type f); do
  file=${input_file/#sources\/gems\/*\/lib/lib\/test_bench_isolated}

  mkdir -p $(dirname $file)

  ed --quiet --verbose --extended-regexp --loose-exit-status $input_file <<ED
#
# Update require statements
,g/^require '.*'$/s/^require '(.*)'$/require 'test_bench_isolated\/\1'/
#
# Find all outermost module and class declarations, then indent every line, ...
,g/^(module|class)/,s/^/  /\\
# ..., then prepend 'module TestBenchIsolated', ...\\
0i\\
module TestBenchIsolated\\
.\\
# ..., then append 'end'\\
\$a\\
end
#
# Write file
w $file
ED

  if [ -f $file ]; then
    echo $file
  else
    echo -e "\e[1;31mError: couldn't write $file\e[39;22m"
    false
  fi
done
