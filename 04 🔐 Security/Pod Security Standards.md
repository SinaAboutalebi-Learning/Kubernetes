# Pod Security Standards (PSS)

Pod Security Standards define **three tiers of pod-level security**.  
They are enforced through the *PodSecurity Admission Controller*, replacing the deprecated PodSecurityPolicy.

PSS is applied per-namespace, with modes:
- **enforce** – block violating pods
- **warn** – allow but warn user
- **audit** – allow but log violation

---

## Privileged
The least restrictive.
- Full host access
- Host networking, hostPID, hostIPC
- All Linux capabilities
- HostPath volumes allowed

Use only for:
- Low-level node daemons
- Monitoring or security agents
- CSI drivers
- Kube-proxy-type workloads

---

## Baseline
Safe default for general workloads.
Blocks:
- Privilege escalation
- Running as root without reason
- Dangerous capabilities
- HostPath volumes (except very controlled)
- Host networking

Allows:
- Common container patterns
- Most normal application workloads

---

## Restricted
The strictest profile.
Best for production workloads.

Requires:
- Must run as non-root
- Drop all capabilities except those explicitly required
- Read-only root filesystem
- Seccomp profile
- No host namespaces
- No hostPath volumes

Restricted mode represents Kubernetes hardening best practices.

---

## When to Use What

Privileged — infra components  
Baseline — shared environment default  
Restricted — hardened production apps

Combining them:
- dev namespaces → baseline + warnings  
- staging → restricted (audit)  
- production → restricted (enforce)

---

## Related
- [[Admission Control]]
- [[GateKeeper]]
- [[Security Overview]]
- [[Image Scanning]]