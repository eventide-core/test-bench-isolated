#!/usr/bin/env bash

set -eEuo pipefail

echo
echo "Installing gems locally"
echo "= = ="
echo

ruby_api_version=$(ruby -rrbconfig -e "puts RbConfig::CONFIG['ruby_version']")

if [ -d gems ]; then
  rm -rf gems

  echo "Removed previously installed gems"
  echo
fi

cmd="gem install --no-document --install-dir ./gems/ruby/$ruby_api_version --bindir ./gems/bin --no-user-install test_bench"

echo $cmd
($cmd)

echo

echo
echo "(done)"
echo "- - -"
echo
