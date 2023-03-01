#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

echo "==> Creating Azure Resource Group: ${AKS_RESOURCE_GROUP}"
az group create \
    --resource-group ${AKS_RESOURCE_GROUP} --location ${AKS_LOCATION}
