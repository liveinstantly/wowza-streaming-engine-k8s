#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

export WSE_MANAGER_LB_DNS_NAME="wsem-$(cat /dev/urandom | base64 | tr -dc a-z0-9 | fold -w 8 | head -n 1)"
export WSE_STREAMING_LB_DNS_NAME="wse-$(cat /dev/urandom | base64 | tr -dc a-z0-9 | fold -w 8 | head -n 1)"

kubectl apply -f ${_common_dir}/wowza-linux-deployment.yaml
envsubst < wowza-streaming-service.yaml | kubectl apply -f -
envsubst < wowza-manager-service.yaml | kubectl apply -f -
