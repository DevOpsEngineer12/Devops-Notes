# Kubernetes kubectl Commands – Basic to Advanced

A categorized list of `kubectl` commands from basic to advanced for managing Kubernetes clusters, pods, deployments, and other resources.

---

## 🔹 Basic Commands

| Command | Description |
|--------|-------------|
| `kubectl version` | Show kubectl and cluster version info |
| `kubectl cluster-info` | Display endpoint info for master and services |
| `kubectl config view` | Show kubeconfig settings |
| `kubectl get nodes` | List all nodes |
| `kubectl get pods` | List all pods |
| `kubectl get deployments` | List all deployments |
| `kubectl get services` | List all services |
| `kubectl get all` | Show all resources in current namespace |
| `kubectl describe pod <name>` | Detailed pod info |
| `kubectl logs <pod-name>` | View logs of a pod |

---

## 🔹 Create & Apply Resources

| Command | Description |
|--------|-------------|
| `kubectl apply -f <file>.yaml` | Apply resource from a YAML file |
| `kubectl create -f <file>.yaml` | Create resource from a YAML file |
| `kubectl create deployment <name> --image=<image>` | Create deployment |
| `kubectl create namespace <name>` | Create a new namespace |

---

## 🔹 Edit, Delete & Scale

| Command | Description |
|--------|-------------|
| `kubectl edit deployment <name>` | Edit a running deployment |
| `kubectl delete pod <name>` | Delete a pod |
| `kubectl delete -f <file>.yaml` | Delete resource from YAML |
| `kubectl scale deployment <name> --replicas=<n>` | Scale a deployment up/down |
| `kubectl rollout restart deployment <name>` | Restart a deployment |

---

## 🔹 Namespace Operations

| Command | Description |
|--------|-------------|
| `kubectl get namespaces` | List namespaces |
| `kubectl config set-context --current --namespace=<ns>` | Set default namespace |
| `kubectl get pods -n <namespace>` | Get pods in specific namespace |

---

## 🔹 Resource Explanation & YAML

| Command | Description |
|--------|-------------|
| `kubectl explain pod` | Show pod spec fields |
| `kubectl explain deployment.spec` | Dive into deployment fields |
| `kubectl get pod <name> -o yaml` | Output pod manifest in YAML |
| `kubectl get deployment <name> -o json` | Output JSON |

---

## 🔹 Exec & Port Forwarding

| Command | Description |
|--------|-------------|
| `kubectl exec -it <pod> -- bash` | SSH into a pod |
| `kubectl cp <pod>:<path> <local-path>` | Copy files from pod to local |
| `kubectl port-forward <pod> <local-port>:<pod-port>` | Forward pod port locally |

---

## 🔹 Labeling & Annotation

| Command | Description |
|--------|-------------|
| `kubectl label pod <pod> env=dev` | Add label to a pod |
| `kubectl annotate pod <pod> owner=team-a` | Add annotation |

---

## 🔹 Rollout Management

| Command | Description |
|--------|-------------|
| `kubectl rollout status deployment/<name>` | Check rollout status |
| `kubectl rollout history deployment/<name>` | View rollout history |
| `kubectl rollout undo deployment/<name>` | Roll back to previous revision |

---

## 🔹 Logs, Events & Monitoring

| Command | Description |
|--------|-------------|
| `kubectl logs <pod>` | View pod logs |
| `kubectl logs <pod> -c <container>` | View logs from specific container |
| `kubectl get events` | Get events in cluster |
| `kubectl top pod` | CPU/Memory usage per pod (requires Metrics Server) |

---

## 🔹 Advanced & Debugging

| Command | Description |
|--------|-------------|
| `kubectl auth can-i <verb> <resource>` | Check user permissions |
| `kubectl get pod <name> -o wide` | Show pod node and IP details |
| `kubectl describe node <node>` | Node info including running pods |
| `kubectl get endpoints` | Show service endpoints |
| `kubectl api-resources` | List all supported resource types |
| `kubectl get crds` | List Custom Resource Definitions |

---

## 🔹 Taints & Tolerations (Node Scheduling)

| Command | Description |
|--------|-------------|
| `kubectl taint nodes <node> key=value:NoSchedule` | Prevent pods from scheduling |
| `kubectl describe node <node>` | View taints/tolerations |

---

## 🔹 Helm Related (if Helm is used)

| Command | Description |
|--------|-------------|
| `helm list` | List installed Helm charts |
| `helm install <name> <chart>` | Install Helm chart |
| `helm upgrade <name> <chart>` | Upgrade release |
| `helm uninstall <name>` | Remove release |
| `helm template <chart>` | Render YAML without installing |

---

## 🔹 Kustomize Support

| Command | Description |
|--------|-------------|
| `kubectl apply -k ./<folder>` | Apply Kustomize directory |
| `kubectl kustomize ./<folder>` | View generated manifest |

---

## 🔹 ArgoCD (GitOps Tool)

| Command | Description |
|--------|-------------|
| `argocd app list` | List Argo apps |
| `argocd app sync <app-name>` | Sync app from Git |
| `argocd app rollback <app-name> <revision>` | Rollback to revision |
| `argocd login <argocd-server>` | Login to Argo CD CLI |

---
