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
      echo "------"
      echo $p
      kustomize build . | kubeconform -summary -ignore-missing-schemas -schema-location default -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' -schema-location https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json
      popd
    fi
  done
  popd
done