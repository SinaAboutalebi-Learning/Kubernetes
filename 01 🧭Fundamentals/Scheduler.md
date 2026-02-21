Scheduler decides _where_ to run a Pod.

### Decision Flow

1. **Filtering**  
    Excludes nodes that cannot run the pod  
    (resource constraints, taints, nodeSelector, volume requirements...)
2. **Scoring**  
    Ranks remaining nodes with scoring algorithms  
    Highest score → chosen node

### Diagram

```
        [ Pending Pod ]
              |
              v
        [ Filtering ]
   Remove nodes that can't host
              |
              v
        [ Scoring ]
   Choose best candidate
              |
              v
         [ Bind Pod ]
```
