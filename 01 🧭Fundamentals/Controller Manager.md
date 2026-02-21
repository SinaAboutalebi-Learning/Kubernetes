Controller Manager = the **automation brain**.  
It continuously watches the cluster state and tries to make actual state match desired state.

This is where Kubernetes gets its “self-healing” superpower.

### Examples of Controllers:

- Node controller
- Job controller
- Deployment/RS controller
- Endpoint controller
- Service account token controller

### 🌱 Core Idea

`Observe → Compare → Act`