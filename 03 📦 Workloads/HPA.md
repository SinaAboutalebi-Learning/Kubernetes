## **Horizontal Pod Autoscaler (HPA)**

Good for **stateless workloads** (e.g., Deployments).

### What HPA does:

- Watches metrics (CPU, memory, custom metrics)
- Calculates recommended number of pods
- Scales ReplicaSet up/down based on:
    - Min replicas
    - Max replicas
    - Utilization percentage

### Notes:

- Uses metrics-server
- Great for frontend apps, microservices, APIs

### Formula:

`desired = currentPods * (currentMetric / targetMetric)`