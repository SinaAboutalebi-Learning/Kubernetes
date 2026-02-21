Used for **stateful**, ordered, stable applications like:

- Databases
- Message queues
- Storage clusters

### Key Features

- Provides **stable, predictable Pod names**:
    `app-0 app-1 app-2`
    
- Scaling follows order:
    - scale up → adds app-N
    - scale down → removes highest index first

### Important

- Kubernetes doesn't handle clustering for you →  
    Your **application must support clustering**.
- Typically paired with **PersistentVolumeClaims**.