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
