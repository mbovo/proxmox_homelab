#!/usr/bin/env bash

set -e

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

export pushd popd

root=$(pwd)
for i in $(ls -1 high/envs); do
  pushd ./high/envs/$i
  for f in $(ls .); do
    if [[ ! -f $f ]]; then
      continue
    fi
    p=$(cat $f | grep path | cut -d: -f 2 | tr -d ' ')
    if [[ -e "$root/$p" ]]; then
      pushd "../../../$p"
      echo $p
      kustomize build . > /dev/null
      popd
    fi
  done
  popd
done