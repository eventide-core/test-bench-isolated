#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Importing lib/ Directory"
echo "= = ="

rm -rf lib

mkdir -p lib/test_bench_isolated

for gem_dir in sources/gems/*; do
  for input_file in $(find $gem_dir -type f); do
    file=${input_file/#$gem_dir\//}
    file=${file/#lib/lib\/test_bench_isolated}

    mkdir -p $(dirname $file)

    ed --quiet --verbose --extended-regexp $input_file <<ED
#
## Update require statements
,g/^require '.*'$/s/^require '(.*)'$/require 'test_bench_isolated\/\1'/
#
## Find all outermost module and class declarations, then indent every line, ...
,g/^(module|class)/,s/^/  /\\
## ..., then prepend 'module TestBenchIsolated', ...\\
0i\\
module TestBenchIsolated\\
.\\
## ..., then append 'end'\\
\$a\\
end
#
## Replace TestBench::CLI with TestBenchIsolated::TestBench::CLI
,g/^TestBench::CLI\.\(\)$/c\\
TestBenchIsolated::TestBench::CLI.()
#
## Write file
w $file
ED

    if [ -f $file ]; then
      echo $file
    else
      echo -e "\e[1;31mError: couldn't write $file\e[39;22m"
      false
    fi
  done
done

echo
echo "Testing CLI"
echo "- - -"
ruby --disable-gems -r./init.rb -e 'TestBenchIsolated::TestBench::CLI.()' || true

echo "Done ($(basename "$0"))"
