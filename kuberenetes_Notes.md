# ☸️ Kubernetes Architecture & Components

---

## 🧠 What is Kubernetes?

Kubernetes (K8s) is an **open-source container orchestration platform** that automates deployment, scaling, and management of containerized applications.

---

## 📐 Kubernetes Architecture Overview

Kubernetes follows a **master-worker architecture** with multiple loosely coupled components, grouped into:

- **Control Plane Components** (Master)
- **Node Components** (Worker)
- **Cluster Store** (etcd)

---

## 🗺️ High-Level Architecture Diagram (Textual)
```pgsql
                +-------------------------------+
                |        Control Plane          |
                |-------------------------------|
                | API Server  | Controller      |
                |             | Manager         |
                |-------------|-----------------|
                | Scheduler   | etcd (Database) |
                +-------------------------------+
                          |
            ----------------------------------
            |                |               |
      +-----------+   +-----------+   +-----------+
      |  Worker 1 |   |  Worker 2 |   |  Worker 3 |
      +-----------+   +-----------+   +-----------+
      | Kubelet   |   | Kubelet   |   | Kubelet   |
      | Kube-proxy|   | Kube-proxy|   | Kube-proxy|
      | Container |   | Container |   | Container |
      +-----------+   +-----------+   +-----------+
```

---

## 🧭 Control Plane Components (Master Node)

| Component | Description |
|-----------|-------------|
| **kube-apiserver** | Central management entity. All interactions with the cluster go through this. |
| **etcd** | Distributed key-value store used as Kubernetes' backing store for all cluster data. |
| **kube-scheduler** | Assigns newly created pods to nodes based on resource needs, policies, and affinity rules. |
| **kube-controller-manager** | Runs all core controllers such as Node Controller, Replication Controller, etc. |
| **cloud-controller-manager** | Interacts with underlying cloud providers (e.g., Azure, AWS) for load balancers, volumes, etc. |

---

## 🛠️ Node Components (Worker Node)

| Component | Description |
|-----------|-------------|
| **kubelet** | Agent that ensures containers are running in a pod on the node. Talks to the API server. |
| **kube-proxy** | Maintains network rules for pod communication inside and outside the cluster using iptables/IPVS. |
| **Container Runtime** | Software like Docker or containerd that runs the containers. |

---

## 📦 Add-ons (Optional But Common)

| Add-on | Description |
|--------|-------------|
| **CoreDNS** | Resolves services and pod names into IPs. |
| **Ingress Controller** | Manages external access to services using routes or load balancers. |
| **Dashboard** | Web-based UI to monitor and manage cluster. |
| **Metrics Server** | Provides resource usage metrics (CPU/memory) for autoscaling. |

---

## 🔄 Workflow Summary

1. **User** sends a deployment request to the **API Server**.
2. **etcd** stores the desired state.
3. **Scheduler** places the pod on the appropriate **Worker Node**.
4. **kubelet** runs the container via the **Container Runtime**.
5. **kube-proxy** handles networking so the pod can be accessed.

---

## 💡 Example: Pod Deployment Flow

1. `kubectl apply -f pod.yaml`
2. API Server validates and stores in etcd.
3. Scheduler selects a node.
4. kubelet on the node pulls the image and starts the container.
5. kube-proxy enables communication.

---

## ⚙️ Key Concepts

| Term | Meaning |
|------|---------|
| **Pod** | Smallest unit; wraps one or more containers. |
| **Service** | Stable IP for accessing pods. |
| **Deployment** | Manages replica sets and updates. |
| **Namespace** | Logical partition of resources in a cluster. |

---

## 📚 References

- Official Docs: https://kubernetes.io/docs/concepts/architecture/
- CNCF Project: https://www.cncf.io/projects/kubernetes/

---

_This file provides a foundational understanding of Kubernetes architecture. Use it as a reference when building or troubleshooting your K8s clusters._ 🚀


---

# Kubernetes Pod Scaling Types

Kubernetes offers several ways to scale your applications to ensure they can handle varying loads efficiently. Pod scaling in Kubernetes can be done in a few different ways, including **manual scaling**, **horizontal pod autoscaling (HPA)**, and **vertical pod autoscaling (VPA)**. Below is an explanation of each scaling type.

---

### 🔹 1. **Manual Pod Scaling**

#### What is it?
Manual scaling involves manually changing the number of pods in a deployment or replica set. This method is useful when you want to control the exact number of pods for your application.

#### Example:

To manually scale the number of replicas in a deployment:

```bash
kubectl scale deployment <deployment-name> --replicas=<number-of-replicas>
```

- For example, to scale a deployment called my-app to 5 replicas:

```bash

kubectl scale deployment my-app --replicas=5
```
- Use Case:
Best for predictable traffic patterns.

- Manual scaling is straightforward but requires intervention for changes.

### 🔹 2. Horizontal Pod Autoscaling (HPA)
#### What is it?
The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of pod replicas in a deployment based on observed CPU utilization or custom metrics.

#### Key Points:
- HPA scales pods horizontally (increasing or decreasing replicas).

- It can scale based on CPU utilization or custom application metrics (e.g., request rate).

#### Example:
To create a Horizontal Pod Autoscaler for a deployment:

```bash

kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
```
#### In this example:

--cpu-percent=50: The target CPU utilization.

--min=1: The minimum number of replicas.

--max=10: The maximum number of replicas.

This command sets HPA to maintain an average CPU utilization of 50%, scaling the number of pods between 1 and 10.

#### Use Case:
- Best for applications with unpredictable or varying loads.

- Ensures efficient resource utilization based on real-time metrics.

- Viewing the HPA:
```bash

kubectl get hpa
```

### 🔹 3. Vertical Pod Autoscaling (VPA)
#### What is it?
- Vertical Pod Autoscaler (VPA) automatically adjusts the CPU and memory resource requests/limits for pods based on usage patterns.

- Unlike HPA, VPA adjusts the resources of existing pods rather than the number of replicas.

#### Key Points:
- VPA scales the resources of a pod vertically (e.g., increasing memory or CPU).

- It does not increase the number of pods.

- VPA works by adjusting the resource requests of running pods.

#### Example:
To create a Vertical Pod Autoscaler for a deployment:

```bash

kubectl apply -f vpa.yaml
vpa.yaml:
```
```yaml

apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
  namespace: default
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"
```

#### Use Case:
- Best for workloads that need resource adjustments without changing pod count.

- Helpful when resource needs vary over time but without fluctuating traffic volumes.

- Viewing VPA:
```bash

kubectl get vpa
```
### 🔹 4. Cluster Autoscaler
#### What is it?
The Cluster Autoscaler automatically adjusts the number of nodes in a Kubernetes cluster when there are unscheduled pods due to insufficient resources, or when nodes are underutilized and can be removed.

#### Key Points:
It works at the node level rather than the pod level.

It is used in conjunction with HPA or other autoscaling methods to ensure sufficient compute resources.

#### Example:
Cluster Autoscaler is typically configured via the Azure or AWS infrastructure settings and is not directly managed by kubectl. You need to configure the autoscaler based on your cloud provider.

### 🔹 5. Scaling Based on Custom Metrics (Custom HPA)
### What is it?
Kubernetes HPA can also scale based on custom metrics such as queue length, request count, or latency. This requires additional setup, including metrics server or custom metrics adapters.

#### Example:
First, you would need to set up a custom metric server, like the Prometheus Adapter for Kubernetes.

Then, create an HPA based on a custom metric:

```bash

kubectl autoscale deployment my-app --metric-name=my_custom_metric --metric-target-value=100 --min=2 --max=10
```
#### Use Case:
Ideal for highly customized workloads where metrics other than CPU or memory are the driving factors for scaling.

### 🔹 6. ReplicaSets and Deployments with Scaling
Kubernetes ReplicaSets and Deployments allow for scaling to a specific number of pods. Both can be combined with HPA for dynamic scaling based on metrics.

#### Example of scaling a Deployment:
```bash

kubectl scale deployment my-app --replicas=4
```
This scales the my-app deployment to 4 replicas. With HPA enabled, Kubernetes will scale this number automatically based on CPU usage or custom metrics.

### 🔹 7. Best Practices for Pod Scaling
| Scaling Type	| Best Practice |
|---------------|---------------|
| Manual Scaling |	Use for predictable traffic, requiring no automatic scaling. |
| Horizontal Scaling (HPA) |	Ideal for web applications and services with fluctuating loads. |
| Vertical Scaling (VPA)	| Use when your application requires larger resources without increasing replicas. |
| Cluster Autoscaler	| Use when your cluster is running at capacity, but you need automatic scaling of nodes. |

## Conclusion
- Kubernetes provides powerful scaling options to meet the demands of your applications:

- Manual scaling is useful when you have predictable workloads.

- Horizontal Pod Autoscaling (HPA) helps adjust the number of replicas based on real-time metrics.

- Vertical Pod Autoscaling (VPA) allows you to adjust the CPU and memory requests of pods.

- Cluster Autoscaler ensures that your Kubernetes cluster can scale nodes based on pod needs.

By combining these different scaling mechanisms, you can ensure that your application remains performant, cost-effective, and resilient to traffic fluctuations.



