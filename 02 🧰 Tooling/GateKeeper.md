
Gatekeeper is a Kubernetes admission controller framework built on top of OPA (Open Policy Agent).  
It validates and enforces cluster policies using “policy as code.”

Gatekeeper is a **Validating Admission Webhook** and **Mutating Webhook** depending on configuration.

---

## How Gatekeeper Works

### Constraint Templates
Define the policy logic in **Rego** (OPA’s policy language).  
Templates describe:
- Inputs
- Parameters
- Validation rules

Example topics:
- Block privileged pods
- Require labels
- Enforce resource limits
- Validate domain naming conventions

### Constraints
Instances of templates with specific parameters.

Example:
Deny any image not coming from `registry.mycompany.com`.

### Sync
Gatekeeper can sync Kubernetes objects into OPA for global policy evaluation.

---

## Strengths
- Extremely powerful for complex rules
- Cloud-native policy management
- Works with GitOps (store templates + constraints in repos)
- Enforces organization-wide compliance
- Full audit mode
- Declarative, reproducible, reviewable

---

## Common Use Cases
- Block privileged containers
- Block hostPath volumes
- Require resource limits and requests
- Enforce naming conventions
- Allow only trusted container registries
- Require image signatures (Cosign)
- Validate labels for billing or ownership

These rules protect your cluster long before workloads misbehave.

---

## Comparing With Kyverno
Gatekeeper:
- Most powerful, extremely flexible
- Rego-based (harder to learn)
- Great for auditors + security teams

Kyverno:
- Kubernetes-native syntax
- Great for dev teams
- Simpler to write policies
- Has built-in mutating and generating rules

Many orgs run both:  
Gatekeeper for core security compliance, Kyverno for soft operational policies.

---

## Related
- [[Admission Control]]
- [[Pod Security Standards]]
- [[Image Scanning]]
- [[Security Overview]]