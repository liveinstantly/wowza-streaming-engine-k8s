#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

export K8S_CM_MANAGED_IDENTITY_FEDERATION_NAME="cert-manager"
# This is the default name for service account of Cert Manager.
export K8S_CM_SERVICE_ACCOUNT_NAME="cert-manager"
export K8S_CM_SERVICE_ACCOUNT_NAMESPACE="cert-manager"

echo "==> Create Workload Managed Identity: ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}"
az identity create \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}

export K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY_ID=$(az identity show --resource-group ${AKS_RESOURCE_GROUP} --name "${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}" --query 'clientId' -o tsv)
export DOMAIN_ZONE_RESOURCE_ID=$(az network dns zone show --resource-group ${AKS_RESOURCE_GROUP} --name ${DOMAIN_NAME} -o tsv --query id)

echo "==> Assign DNS Zone Contributor role to Workload Managed Identity: ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}"
az role assignment create \
    --role "DNS Zone Contributor" \
    --assignee ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY_ID} \
    --scope "${DOMAIN_ZONE_RESOURCE_ID}"

export AKS_ISSUER=$(az aks show --resource-group ${AKS_RESOURCE_GROUP} --name ${K8S_CLUSTER} --query "oidcIssuerProfile.issuerUrl" -o tsv)

echo "==> Configure federation (system:serviceaccount:${K8S_CM_SERVICE_ACCOUNT_NAMESPACE}:${K8S_CM_SERVICE_ACCOUNT_NAME}) to Workload Managed Identity: ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}"
az identity federated-credential create \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_CM_MANAGED_IDENTITY_FEDERATION_NAME} \
    --identity-name ${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY} \
    --issuer "${AKS_ISSUER}" \
    --subject "system:serviceaccount:${K8S_CM_SERVICE_ACCOUNT_NAMESPACE}:${K8S_CM_SERVICE_ACCOUNT_NAME}"
