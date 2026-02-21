## **Vertical Pod Autoscaler (VPA)**

Used for **stateful workloads** (databases, queue systems) where scaling replicas doesn’t help.

### Components:

VPA runs as 3 pods:

1. **Recommender**
    - Analyzes resource usage
    - Suggests CPU/memory changes
2. **Updater**
    - Decides when to evict Pods to apply recommendations
3. **Admission Controller**
    - Injects recommendations into Pod specs

---

### 4 Update Modes:

|Mode|Description|
|---|---|
|**Off**|Only provides recommendations|
|**Initial**|Applies recommendations when Pod starts|
|**Recreate**|Deletes Pods to apply new values|
|**Auto**|Fully automated vertical scaling|

---

### Combine HPA + VPA?

Yes — recommended.
- [[HPA]] handles scaling **number of pods**
- [[VPA]] handles **resources per pod**