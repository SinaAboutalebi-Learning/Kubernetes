# Admission Control

Admission control is the stage *after* authentication and authorization but *before* objects are stored in etcd.  
It decides whether a request should be modified, allowed, or denied.

Flow:
Authentication → Authorization → **Admission** → API action

Admission controllers are plugins in the API server.  
They enforce cluster-wide policies without modifying workloads themselves.

---

## Types of Admission Controllers

### Mutating Admission
Modifies requests before validation.
Examples:
- Inject default values
- Add sidecars
- Apply labels/annotations
- Enforce pod defaults (runtimeClass, tolerations, limits)

Runs **before** validating admission.

### Validating Admission
Rejects requests that violate rules.
Examples:
- Block privileged containers
- Deny hostPath volumes
- Reject images from unknown registries

Runs **after** mutation.

---

## Policy Engines

### [[GateKeeper]] (OPA)
Uses OPA Rego language to define constraints.  
Highly flexible, great for complex enterprise policies.

### Kyverno
Kubernetes-native policy engine.
- Mutating rules
- Validation rules
- Generation rules  
Easier syntax than OPA.

### Pod Security Admission (built-in)
Direct successor to PodSecurityPolicy (deprecated).  
Implements [[Pod Security Standards]].

---

## Why Admission Matters
Admission is where:
- Security policies are enforced
- Naming conventions are required
- Images are validated/scanned
- Privilege escalation is blocked
- Network boundaries are enforced
- Resource defaults are injected

Every meaningful production cluster relies on strong admission rules.

---

## Related
- [[Security Overview]]
- [[Pod Security Standards]]
- [[GateKeeper]]
- [[Image Scanning]]
- [[RBAC]]