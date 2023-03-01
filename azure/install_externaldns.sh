#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

export AKS_TENANT_ID=$(az account show --subscription ${AKS_SUBSCRIPTION_ID} --query tenantId -o tsv)
export K8S_AZURE_DNS_ZONE_POD_IDENTITY_ID=$(az identity show --resource-group ${AKS_RESOURCE_GROUP} --name "${K8S_AZURE_DNS_ZONE_POD_IDENTITY}" --query 'clientId' -o tsv)
export K8S_AZURE_DNS_ZONE_POD_IDENTITY_RID=$(az identity show --resource-group ${AKS_RESOURCE_GROUP} --name "${K8S_AZURE_DNS_ZONE_POD_IDENTITY}" --query 'id' -o tsv)
export SECRET_FILENAME=azure.json


echo "==> Creating Pod Identity Binding with ${K8S_EXTDNS_NAMESPACE}:external-dns and ${K8S_AZURE_DNS_ZONE_POD_IDENTITY}"
az aks pod-identity add --resource-group ${AKS_RESOURCE_GROUP}  \
  --cluster-name ${K8S_CLUSTER} --namespace "${K8S_EXTDNS_NAMESPACE}" \
  --name "external-dns" --identity-resource-id "${K8S_AZURE_DNS_ZONE_POD_IDENTITY_RID}"

if [ ! ${K8S_EXTDNS_NAMESPACE} = "default" ]; then
    echo "==> Creating Namespace (${K8S_EXTDNS_NAMESPACE}) for external-dns"
    kubectl create namespace ${K8S_EXTDNS_NAMESPACE}
fi

echo "==> Install Pod Identity secret for external-dns: ${K8S_AZURE_DNS_ZONE_POD_IDENTITY}"
envsubst < external-dns-azure-template.json > ./${SECRET_FILENAME}
kubectl create secret generic ${K8S_AZURE_DNS_ZONE_POD_IDENTITY_SECRET_NAME} --namespace "${K8S_EXTDNS_NAMESPACE}" --from-file ./${SECRET_FILENAME}
rm -f ./${SECRET_FILENAME}

echo "==> Install external-dns"
envsubst < external-dns-deployment-pod-identity.yaml | kubectl create --namespace "${K8S_EXTDNS_NAMESPACE}" -f -
kubectl patch deployment external-dns \
    --namespace "${K8S_EXTDNS_NAMESPACE}" \
    --patch '{"spec": {"template": {"metadata": {"labels": {"aadpodidbinding": "external-dns"}}}}}'
