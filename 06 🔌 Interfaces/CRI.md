# Container Runtime Interface

Kubernetes **does NOT ship with its own container runtime**.  
Instead, it uses a standard interface — **CRI** — to communicate with external runtimes.

CRI defines _how kubelet talks to container runtimes_.

### Examples of CRI Implementations

- **containerd** (modern default for most distros)
- **CRI-O** (designed specifically for Kubernetes)
- **Docker** (_deprecated as a runtime_, but still usable via dockershim replacement shims)


### Why CRI exists?

To allow Kubernetes to plug into _any_ container runtime without re-writing kubelet.

### Simple Diagram
```
           [ Kubelet ]
               |
       --------|---------
       |                 |
  [ CRI API ]      (Plugins)
       |
       v
   [ Runtime ]
  (containerd / CRI-O / …)
       |
       v
   [ Containers ]

```