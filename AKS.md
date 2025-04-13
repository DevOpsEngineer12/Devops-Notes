# Azure Kubernetes Service (AKS) Setup Guide

This guide provides step-by-step instructions for creating an **Azure Kubernetes Service (AKS)** cluster, configuring nodes, setting up a Virtual Network (VNet), enabling Ingress controllers, configuring load balancers, monitoring the cluster, and setting up DNS.

---

## 🔹 1. **Create AKS Cluster**

### Using Azure CLI:

```bash
# Variables
RESOURCE_GROUP=myResourceGroup
AKS_CLUSTER_NAME=myAKSCluster
LOCATION=eastus

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create AKS cluster
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count 3 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

## Explanation:
- --node-count: Number of nodes in the cluster.

- --enable-addons monitoring: Enables monitoring (via Azure Monitor) for the AKS cluster.

- --generate-ssh-keys: Automatically generates SSH keys for nodes.

# 🔹 2. Configure AKS Nodes
## Scaling Node Pool:
To scale the number of nodes in your AKS cluster:

```bash

az aks scale \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count 5

```
## Adding a New Node Pool:
You can add additional node pools to run workloads with specific requirements:

```bash

az aks nodepool add \
  --resource-group $RESOURCE_GROUP \
  --cluster-name $AKS_CLUSTER_NAME \
  --name mynodepool \
  --node-count 2 \
  --enable-node-public-ip
```

## Explanation:

- --nodepool: Defines a specific pool for specialized workloads (e.g., GPU workloads).

- --enable-node-public-ip: Allows public IPs for nodes (use with caution for production).


#### 🔹 3. Create a Virtual Network (VNet)
- Creating VNet for AKS:
```bash

# Create a VNet and Subnet
az network vnet create \
  --name myVnet \
  --resource-group $RESOURCE_GROUP \
  --subnet-name myAKSSubnet
  ```
- Associate AKS Cluster with VNet:
  - When creating an AKS cluster, you can specify the VNet:

```bash
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --vnet-subnet-id /subscriptions/<subscription-id>/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/myAKSSubnet \
  --node-count 3 \
  --enable-addons monitoring
```

### 🔹 4. Configure Ingress Controller
- Installing NGINX Ingress Controller:
- Add the NGINX ingress controller Helm repository:

```bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```
- Install the NGINX Ingress controller:

```bash

helm install ingress-nginx ingress-nginx/ingress-nginx --namespace kube-system
```
- Verify installation:

```bash

kubectl get pods -n kube-system
```
###🔹 5. Configure Load Balancer (Internal & External)
#### External Load Balancer:
Azure will automatically provision an external load balancer when you expose services with LoadBalancer type.

- Example YAML for an external load balancer:

```yaml

apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```
#### Internal Load Balancer:
To configure an internal load balancer, use internal as the loadBalancerIP.

- Example YAML for an internal load balancer:

```yaml

apiVersion: v1
kind: Service
metadata:
  name: internal-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```
### 🔹 6. Monitoring with Azure Monitor
Azure Monitor can be enabled during AKS cluster creation using --enable-addons monitoring.

- Viewing Cluster Metrics:
```bash
# View metrics from Azure portal or Azure CLI
az monitor metrics list --resource $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP
```

### 🔹 7. DNS Configuration for AKS Cluster
You can set up DNS for your services in AKS using either an external DNS solution or Azure's built-in DNS management.

- Configuring External DNS in AKS:
- Install the external-dns using Helm:

```bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install external-dns bitnami/external-dns
Configure External DNS with Azure DNS:
```

```bash

az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
kubectl apply -f external-dns.yaml
```

### 🔹 8. Configure DNS Records (Azure DNS)

If you have a custom domain, you can configure it with Azure DNS by creating DNS records.

#### Example: Create DNS A Record for AKS Service
```bash

az network dns record-set a add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name mydomain.com \
  --record-set-name aks \
  --ipv4-address <load-balancer-ip>
```
  
## 🔹 9. Access AKS Cluster

- Once the AKS cluster is created and configured, access it using the following commands:

- Get credentials to access the AKS cluster:

```bash

az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
Verify the connection:
```

```bash

kubectl get nodes
```
### 🔹 10. Upgrade AKS Cluster
To upgrade an AKS cluster to a newer version:

```bash

az aks upgrade --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --kubernetes-version <new-version>
```

## 🔹 Additional Configuration
### 🔹 Set Up Autoscaling for Nodes:
```bash
az aks update \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 5
```
  
## Conclusion
###  With these steps, you’ve learned how to:

1. Create and configure an AKS cluster.

2. Set up node pools and scale as required.

3. Set up VNet for network isolation.

4. Deploy Ingress controllers.

5. Configure internal and external load balancers.

6. Enable Azure Monitor for insights and monitoring.

7. Configure DNS settings for external access.

Now you’re ready to deploy, manage, and scale your applications using AKS with advanced networking, security, and monitoring configurations.
