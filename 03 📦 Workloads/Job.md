A **Job** runs Pods **until a task completes**.

### Behavior

- Creates Pods that run to **completion**
- If a Pod fails → Job retries based on policy
- When Pod exits successfully → Job ends

### Common Uses

- DB migration scripts
- Batch operations
- One-time automation tasks
- Backup jobs (manual)