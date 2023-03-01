# Deploy Wowza Streaming Engine to a Kubernetes cluster

This repository is to publish our scripts to deploy our Wowza Streaming Engine container image to Kubernetes cluster with some integrations, such as automatic publishing DNS hostnames, automatic issuing SSL/TLS certificates for streaming, REST API, and management endpoints.

## How-Tos

Here are **how-to** documents:

* [Deployment to Azure Kubernetes Services (AKS) cluster](./Deployment-to-AKS.md)
* TO BE ADDED how-to docs for other scenarios...

## References

The following components and articles are referred for this how-to docs.

* [`cert-manager`](https://cert-manager.io/)
  * [Installation with Helm](https://cert-manager.io/docs/installation/helm/)
  * [Configurations - Azure DNS](https://cert-manager.io/docs/configuration/acme/dns01/azuredns/)
  * [The cert-manager Command Line Tool (cmctl)](https://cert-manager.io/docs/reference/cmctl/)
* [`external-dns`](https://github.com/kubernetes-sigs/external-dns)
* Microsoft Azure
  * [Azure Kubernetes Services documentation](https://learn.microsoft.com/en-us/azure/aks/)
  * [Use Azure AD workload identity (preview) with Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview)
  * [Deploy and configure workload identity (preview) on an Azure Kubernetes Service (AKS) cluster](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster)
  * [Modernize application authentication with workload identity (preview)](https://learn.microsoft.com/en-us/azure/aks/workload-identity-migrate-from-pod-identity)
  * [Use Azure Active Directory pod-managed identities in Azure Kubernetes Service (Preview)](https://learn.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity)
  * [Workload identity federation](https://learn.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation)
