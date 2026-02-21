# Security Overview

Security in Kubernetes stretches across multiple layers.  
Think of it like nested shells: code → container → cluster → cloud/datacenter.  
Weakness at any layer eventually leaks into the others.

---

## Cloud Native Security Layers

### Code Layer
The smallest attack surface.
- Avoid logic bugs, injection, XSS, insecure dependencies.
- Use static code analysis in CI/CD.
- Enforce secure coding standards.

### Container Layer
Before pods even hit the cluster:
- Scan images (Trivy, Clair, Grype).
- Detect exposed ports, vulnerable libraries, misconfigured base images.
- Enforce that only signed images are deployed (e.g., Cosign + Kyverno/Gatekeeper).

### Cluster Layer
Admin-owned space. Users deploy apps, but platform owners define guardrails.
- Secure control-plane configs.
- Limit API access.
- Use Pod Security Standards.
- Restrict privileged containers.
- Disable anonymous API access.
- Network segmentation with [[CNI]] policies.

### Cloud/Datacenter/CoLocation Layer
Where physical reality touches Kubernetes.
- Physical access controls.
- Apply SOPs: SCOOP-style operational controls, off-site backups, air-gapped secrets.
- All the electricity-and-steel concerns you never see in YAML.

---

## Pod Security Standards (PSS)
Modern replacement for the deprecated PodSecurityPolicy.

Three baseline profiles:

### 1. **Privileged** (high trust)
- Almost unrestricted.
- Avoid unless running low-level infra or node agents.

### 2. **Baseline** (safe minimum)
- Prevents known bad patterns.
- Best default for shared clusters.

### 3. **Restricted** (hardened mode)
- Blocks privilege escalation, host networking, hostPaths, and unsafe capabilities.
- Ideal for production apps following least-privilege.

### Enforcement Levels
PSS works through the API admission chain:

- **enforce** → reject the request  
- **audit** → allow but log the violation  
- **warn** → allow but warn the user  

Good clusters combine enforce (for prod), audit (for dev), and warn (for onboarding).

---

## Admission Control
Every request to Kubernetes flows through:

Authentication → Authorization → Admission → Execution

### Authentication
Identifies *who* you are.

Methods:
- Certificates  
- Tokens  
- Username/password  
- OIDC (LDAP, Active Directory, Keycloak)

Failure returns **401 Unauthorized**.

### Authorization
Checks *what you can do*.

Mechanisms:
- **RBAC (Role-Based Access Control)** — modern standard  
- **ABAC (Attribute-Based)** — deprecated  
- Webhook authorization  

Failure returns **403 Forbidden**.

### Admission
Mutates or validates the request.

Two key types:
- **Mutating admission** → modifies incoming objects (add labels, defaults…)  
- **Validating admission** → blocks objects that break policies

Tools:
- **Gatekeeper (OPA)** — policy as code, powerful constraint language  
- **Kyverno** — Kubernetes-native policy engine  
- Built-in PSS admission plugin  

Admission is where policy enforcement happens: preventing vulnerable images, blocking privileged containers, forcing labels, etc.

---

## Auditing
Everything in a cluster ultimately passes through the API server, which makes it the perfect place to record activity.

Why it matters:
- Forensics
- Compliance
- Debugging access issues
- Detecting malicious activity

Best practices:
- Enable audit logging on kube-apiserver.
- Exclude noisy verbs: `read`, `list`, `watch`.
- Store logs where tampering is impossible (remote sink or SIEM).

---

## Related
- [[RBAC]]
- [[Certificates]]
- [[Kube-apiserver]]
- [[Pod Security Standards]]
- [[Gatekeeper]]
- [[Auditing]]
- [[Admission Control]]
- [[CNI]]