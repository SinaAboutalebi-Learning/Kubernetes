## ConfigMap
A ConfigMap stores *non-sensitive* configuration data in key/value format.

Important notes:
- Distributed to **all nodes** in the cluster.
- Mounted inside pods as environment variables or files.
- Updated ConfigMaps can trigger rolling updates in certain workloads (like [[Deployment]] with `--reload` logic).

---

## Secret
A Secret stores *sensitive* data.  
It is **base64-encoded**, not encrypted. Encoding is for transport, not security.

Distribution rules:
- Secrets are only pushed to *nodes running pods that need them*.
- Kubernetes keeps them in tmpfs (memory) when possible.

For real security:
- Integrate an external secret manager like **HashiCorp Vault**, AWS KMS, GCP KMS, or Sealed Secrets.
- Vault offers encryption-at-rest + access control + dynamic secrets.

---

## Why Encoding Is Not Security
Base64 provides *obfuscation*, not protection.  
Anyone with access to the Secret object can decode it easily.

Use:
- Encryption at rest (KMS provider)
- Vault integration
- RBAC restrictions
- Network policies

---

## Related
- [[Kube-apiserver]]
- [[etcd]]
- [[RBAC]]