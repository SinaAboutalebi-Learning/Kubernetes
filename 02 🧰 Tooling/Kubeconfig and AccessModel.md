
This is one of the most important concepts in Kubernetes — every kubeconfig file answers three questions:

1. **Which cluster am I talking to?**
2. **Who am I when I talk to it?**
3. **What’s my default working namespace?**

That’s literally all authentication inside Kubernetes.

The **kubeconfig** file is the configuration that tells `kubectl` _how to connect to a Kubernetes cluster_.

Default path:

`~/.kube/config`

You can override the path with:

- `KUBECONFIG` environment variable (supports multiple files)
  ```bash
  export KUBECONFIG=~/.kube/config:~/kubeconfigs/prod.yaml
  ```
- Tools like **kube-switch**, **kubectx**, or **Lens**

# 🧠 **Conceptual Diagram**

``` 
                   +-----------------------+
                   |       kubeconfig      |
                   +-----------------------+
                      /           |           \
                     /            |            \
                    v             v             v
             +-----------+   +----------+   +-------------+
             |  Cluster  |   |   User   |   |   Context   |
             +-----------+   +----------+   +-------------+
             | apiServer |   | identity |   | clusterRef  |
             |   CA      |   | authMethod|  | userRef     |
             +-----------+   +----------+   | namespace   |
                                             +-------------+
                                                      |
                                                      v
                                           +--------------------+
                                           | kubectl uses this  |
                                           | context by default |
                                           +--------------------+

```

This shows exactly how [[Kubectl]] always picks a target.

---

## The kubeconfig File Structure

kubeconfig has **3 main sections**:

### **1. Clusters**

Contains:

- API server endpoint
- Cluster CA certificate

Defines _where_ the cluster is and how to trust it.

---

### **2. Users**

Defines:

- User identity
- Auth method (token, client cert, exec plugin…)

Meaning: _“Who are you?”_

---

### **3. Contexts**

A context = **Cluster + User + Namespace**  
Defines:

- _Who_ connects
- _To which cluster_
- _Inside which namespace_

Contexts are your way of saying:

> “Use _this_ identity for _this_ cluster.”