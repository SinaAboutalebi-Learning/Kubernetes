# Container Storage Interface

Kubernetes abstracts storage using **CSI**.

CSI enables Kubernetes to connect to ANY storage backend — block, file, cloud, SAN, Ceph, etc.

### Examples of CSI Drivers

- **CephFS / RBD**
- **vSphere CSI**
- **AWS EBS CSI**
- **GCE PD CSI**
- **OpenEBS**
- **Longhorn**

### What CSI Does

- Creates volumes
- Attaches/detaches volumes to nodes
- Mounts volumes into pods
- Extends volumes
- Snapshots & restores (if supported)

### Diagram
```
    [ Kubelet ]
         |
  CSI gRPC Calls
         |
         v
   [ CSI Driver ]
         |
         v
  [ Storage Backend ]
(ceph / SAN / cloud / ...)

```