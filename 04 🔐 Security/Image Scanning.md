Image scanning protects the cluster by analyzing container images for vulnerabilities, misconfigurations, and exposed attack surfaces before deployment.

The container layer is the main filtering point in the supply chain.

---

## Why Image Scanning Matters
Containers are built from:
- OS layers
- Application libraries
- Runtime binaries
- Dependencies pulled from the internet

Any layer can contain:
- CVEs (Common Vulnerabilities and Exposures)
- Outdated packages
- Malware (yes, it happens)
- Bad base images
- Misconfigurations (open ports, root user)

Scanning catches these issues before Kubernetes ever sees your pod.

---

## Common Tools

### Trivy
Fast, lightweight, supports:
- Filesystems
- Git repos
- Docker/OCI images
- SBOM generation

### Clair
Registry-integrated scanning.

### Grype
Simple CLI-based scanner for CI pipelines.

### Twistlock / Prisma  
Enterprise-grade container security.

---

## Integrating Scanning Into CI/CD
Best practice is to:
1. Scan image on build.
2. Block PRs with critical vulnerabilities.
3. Sign images after scanning (Cosign).
4. Enforce signed-image-only deployment with [[GateKeeper]] or Kyverno.

---

## Cluster Enforcement
Scanning alone isn't enough.  
Use admission control to block unscanned or vulnerable images.

Example policies:
- Reject images with critical CVEs
- Allow images only from trusted registries
- Require image signatures
- Require SBOM

These are typically implemented with:
- Gatekeeper constraints
- Kyverno policies
- PodSecurity Standards (for basic privilege settings)

---

## Related
- [[GateKeeper]]
- [[Admission Control]]
- [[Security Overview]]