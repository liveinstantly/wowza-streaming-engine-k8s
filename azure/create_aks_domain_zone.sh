#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

echo "==> Creating Azure DNS Zore: ${DOMAIN_NAME}"
az network dns zone create \
    --resource-group ${AKS_RESOURCE_GROUP} --name ${DOMAIN_NAME}
