#!/usr/bin/env bash

set -eu -o pipefail

echo
echo "Stage Package"
echo "= = ="
echo

if [ -z ${VERSION:-} ]; then
  version=0
  echo "(VERSION isn't set; $version will be used)"
else
  version=$VERSION
fi

if [ -z ${CLEAN:-} ]; then
  clean=on
  echo "(CLEAN isn't set; $clean will be used)"
else
  clean=$CLEAN
fi

echo "Version: $version"
echo "Clean: $clean"

if [ $clean = "on" ]; then
  rm -rf stage
fi

mkdir -v stage

ruby_api_version=$(ruby -rrbconfig -e "puts RbConfig::CONFIG['ruby_version']")

stage_file() {
  file=$1

  if [[ $file =~ "/controls/" ]]; then
    target_file=stage/lib/test_bench/isolated/controls.rb
  else
    target_file=stage/lib/test_bench/isolated.rb
  fi

  source=${file#gems/ruby/$ruby_api_version/gems/}
  
  mkdir -p stage/lib/test_bench/isolated

  ed --quiet $file <<ED >/dev/null || true
# Remove require statements
,s/^\(require ['"][^'"]\{1,\}['"][[:space:]]*\)/#\1/
# Indent all text
,s/^/  /
# Prepend 'module TestBenchIsolated'
1i
module TestBenchIsolated # $source
.
# Append 'end'
\$a
end # TestBenchIsolated # $source
.
W $target_file
q
ED
}

stage_files() {
  lib_name=$1
  lib_dir=$2

  loader_file=$lib_dir/$lib_name.rb

  lib_name_pattern=${lib_name//\//\\/}

  require_pattern="s/^[[:space:]]*require[[:space:]]+['\"]($lib_name_pattern\/[^'\"]+)['\"][[:space:]]*$/\1.rb/p"

  for file in $(sed -n -E $require_pattern $loader_file); do
    if [ -s $lib_dir/$file ]; then
      stage_file $lib_dir/$file
    fi
  done
}

stage_lib() {
  lib_dir=gems/ruby/$ruby_api_version/gems/$1-*/lib
  lib_name=${1/-/\/}
  controls_lib_name=$lib_name/controls

  stage_files $lib_name $lib_dir
  stage_files $controls_lib_name $lib_dir
}

stage_lib test_bench-random
stage_lib test_bench-telemetry
stage_lib test_bench-output
stage_lib test_bench-session
stage_lib test_bench-fixture
stage_lib test_bench-run
stage_lib test_bench

mkdir stage/script
cat > stage/script/bench <<TEXT
#!/usr/bin/env ruby
require 'test_bench/isolated'
TestBenchIsolated::TestBench::CLI.()
TEXT
chmod 755 stage/script/bench

gem -C stage build ../test_bench-isolated.gemspec

echo
echo "(done)"
echo "- - -"
echo
tree stage
