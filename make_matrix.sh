#!/usr/bin/env bash

set +x

# In case of long running hold update
HOLDUPDATE=()

# Create json object
json_output(){
    local lastl=$(echo "${1}" | wc -l)
    local line=0
    printf '{\"include\":['
    while read env; do
        line=$(($line + 1))
        local b=$(printf ${env})
        local e=$(printf ${env} | sed -r 's:./envs/(.*)/flux-system:\1:g;s:/:-:g')
        local v=$(sed -n '3p' ${env}/gotk-components.yaml| awk '{print $4}')
        local x=$(sed -n '4p' ${env}/gotk-components.yaml | grep -q "image-reflector-controller" && echo "true" || echo "false")
        printf '{\"base\":\"%s\",\"env\":\"%s\",\"ver\":\"%s\",\"extra-component\":\"%s\"}' $b $e $v $x
        [[ $line -ne $lastl ]] && printf ","
    done <<< ${1}
    printf "]}"
}

# Loop across the envs
loop(){
    for env in ./high/envs/*/flux-system; do
        if [[ ! "${HOLDUPDATE[*]}" =~ "${env}" ]]; then
            echo ${env}
        fi
    done
}

env_list=$(loop packages)
json_output "${env_list}"