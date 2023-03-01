#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

echo "==> Create POD Managed Identity: ${K8S_AZURE_DNS_ZONE_POD_IDENTITY}"
az identity create \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_AZURE_DNS_ZONE_POD_IDENTITY}

export K8S_AZURE_DNS_ZONE_POD_IDENTITY_ID=$(az identity show --resource-group ${AKS_RESOURCE_GROUP} --name "${K8S_AZURE_DNS_ZONE_POD_IDENTITY}" --query 'clientId' -o tsv)
export DOMAIN_ZONE_RESOURCE_ID=$(az network dns zone show --resource-group ${AKS_RESOURCE_GROUP} --name ${DOMAIN_NAME} -o tsv --query id)

echo "==> Assign DNS Zone Contributor role to POD Managed Identity: ${K8S_AZURE_DNS_ZONE_POD_IDENTITY}"
az role assignment create \
    --role "DNS Zone Contributor" \
    --assignee ${K8S_AZURE_DNS_ZONE_POD_IDENTITY_ID} \
    --scope "${DOMAIN_ZONE_RESOURCE_ID}"
