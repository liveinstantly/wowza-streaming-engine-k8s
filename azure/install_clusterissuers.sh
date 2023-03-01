#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

export K8S_CM_MANAGED_IDENTITY_ID=$(az identity show --resource-group ${AKS_RESOURCE_GROUP} --name "${K8S_AZURE_DNS_ZONE_WORKLOAD_IDENTITY}" --query 'clientId' -o tsv)

echo "==> Create ClusterIssuer: letsencrypt-staging"
envsubst < ${_script_dir}/clusterissuer-lets-encrypt-staging.yaml | kubectl apply -f  -

echo "==> Create ClusterIssuer: letsencrypt-production"
envsubst < ${_script_dir}/clusterissuer-lets-encrypt-production.yaml | kubectl apply -f  -
