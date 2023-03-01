#!/bin/bash
_script_name=$(realpath $0)
_script_dir=$(dirname ${_script_name})
_root_dir=$(realpath ${_script_dir}/..)
_common_dir=${_root_dir}/common
export $(cat ${_root_dir}/.env | grep -v "^#" | xargs)

helm repo add jetstack https://charts.jetstack.io
helm repo update

echo "==> Install cert-manager"
helm upgrade cert-manager jetstack/cert-manager \
    --install --create-namespace --namespace ${K8S_CM_NAMESPACE} \
    --set installCRDs=true --wait

echo "==> Update cert-manager to enable Workload Identity"
helm upgrade cert-manager jetstack/cert-manager \
    --namespace ${K8S_CM_NAMESPACE} \
    --reuse-values --values ${_script_dir}/managed-identity-values.yaml
