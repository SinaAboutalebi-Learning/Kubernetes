Probes let Kubernetes actively check the health and readiness of a container. 
They help the Control Plane decide **when a pod is healthy**, **when it should receive traffic**, and **when it should be restarted**.

---

## Liveness Probe
Checks whether the container is *alive*.  
If this probe fails, Kubernetes restarts the container.

Useful when:
- The app has a deadlock.
- The app is running but stuck.
- The app fails internally but never exits.

---

## Readiness Probe
Checks whether the pod is ready to receive traffic.  
If it fails, the pod is *removed from Service load-balancing* but **not restarted**.

This is extremely helpful when:
- The app needs warm-up time.
- The pod is overloaded — you can intentionally fail the readiness probe to tell Kubernetes:  
  *“Stop sending traffic; I need a breather.”*

---

## Types of Probes
Probes support three mechanisms:

### HTTP Probe
Kubernetes performs an HTTP GET request to a defined path and expects a status code ≥ 200 and < 400.

### TCP Socket Probe
Kubernetes checks if the TCP port is accepting connections.

### Exec Probe
Runs a command inside the container. If the exit code is non-zero, the probe fails.

---

## Crash Philosophy
In Kubernetes, failure is not a tragedy. It's part of the design.

Developers should avoid huge try/catch fortresses and instead embrace the “**let it crash**” mindset.  
If the app dies, Kubernetes handles the restart via liveness probes and automatic pod replacement.

---

## Related
- [[Deployment]]
- [[ReplicaSet]]
- [[Kubelet]]