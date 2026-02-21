A **DaemonSet** ensures **one Pod per [[Nodes]]** (or one per selected node group).

### Common Uses

- Logging agents (FluentD, Filebeat)
- Monitoring agents (Node Exporter, Prometheus agent)
- [[CNI]] plugins
- Storage drivers
- Security agents

### Behavior

- Whenever a new node joins → Pod is created automatically.
- If a node is removed → Pods on that node are removed.