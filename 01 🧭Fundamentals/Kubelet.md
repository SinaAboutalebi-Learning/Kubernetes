Runs on every worker node.

### Responsibilities

1. **Node Registration** → tells API-server “hi, I exist”
2. **Monitor** → checks pods & node health
3. **Pod Lifecycle** → creates/updates/deletes pods via [[CRI]] (container runtime)


### Kubelet is the agent
```
[ Kubelet ] <--> [ API Server ]
     |
     v
[ Container Runtime ]

```
