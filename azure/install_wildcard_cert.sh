#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

echo "==> Creating Wildcard Certificate: *.${DOMAIN_NAME}"
envsubst < ${_common_dir}/certificate-wildcard-domain.yaml | kubectl apply -f  -
