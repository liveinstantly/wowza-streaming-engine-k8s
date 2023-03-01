#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

echo "==> Creating Azure AKS Cluster: ${K8S_CLUSTER}"
az aks create \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --location ${AKS_LOCATION} \
    --name ${K8S_CLUSTER} \
    --node-count 1 --node-vm-size "Standard_B2ms" \
    --nodepool-name "systempool" \
    --load-balancer-sku basic \
    --auto-upgrade-channel patch \
    --node-resource-group ${AKS_NODE_RESOURCE_GROUP} \
    --generate-ssh-keys

# Enable POD Identity
echo "==> Enable POD Identity in AKS Cluster: ${K8S_CLUSTER}"
az aks update \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_CLUSTER} \
     --enable-pod-identity --enable-pod-identity-with-kubenet

# Enable Workload Identity
echo "==> Enable Workload Identity in AKS Cluster: ${K8S_CLUSTER}"
az aks update \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_CLUSTER} \
    --enable-oidc-issuer --enable-workload-identity

echo "==> Get credentials for AKS Cluster: ${K8S_CLUSTER}"
az aks get-credentials \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${K8S_CLUSTER} \
    --admin
