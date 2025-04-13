# Kubernetes Manifest Types and Their Uses

This document lists common Kubernetes manifest types, their purposes, and example YAML structures.

---

## 1. Deployment

**Use:** Manages stateless applications with replicas and rolling updates.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx
        ports:
        - containerPort: 80
```

---

### 2. Service

**Use:** Exposes Pods to internal or external traffic (ClusterIP, NodePort, LoadBalancer).

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

## 3. ConfigMap

**Use:** Use: Stores non-sensitive config data as key-value pairs.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_MODE: production
  TIMEOUT: "30"
```

## 4. Secret

**Use:** Use: Stores sensitive data (base64-encoded) like passwords, tokens, etc.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  password: cGFzc3dvcmQ=   # "password" base64 encoded
```

## 5. PersistentVolume (PV)

**Use:** Use: Represents a piece of storage in the cluster.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data/pv1
```

## 6. PersistentVolumeClaim (PVC)

**Use:** Use: Requests storage resources from a PV.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```


## 7. Namespace

**Use:** Use: Isolates resources in the cluster.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev-environment
```

## 8. Ingress

**Use:** Use: Exposes HTTP(S) routes from outside the cluster to Services.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

## 9. Job

**Use:** Use: Runs a one-time task to completion (e.g., batch job).

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
```

## 10. CronJob

**Use:** Use: Schedules recurring jobs using cron syntax.

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-cron
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from Kubernetes CronJob
          restartPolicy: OnFailure
```

## 11. StatefulSet
**Use:** Use: Manages stateful applications with persistent identity (e.g., databases).

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

## 12. DaemonSet

**Use:** Use: Ensures a pod runs on all (or specific) nodes (e.g., log collectors, monitoring agents).

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd
```

## 13. HorizontalPodAutoscaler (HPA)

**Use:** Use: Automatically scales pods based on CPU or custom metrics.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## 14. ReplicaSet

**➤ Use:** Ensures a specified number of pod replicas are running. Often managed by a Deployment.

➤ Example:
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx
```
