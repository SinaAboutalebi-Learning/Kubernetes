# 📜 Logging Best Practices in Kubernetes

Logs are one of the most important observability signals in a Kubernetes cluster. Good logging helps with debugging, auditing, performance analysis, security, and post-mortems — _but only if the logs are actually structured, stored, searchable, and protected._

This document covers the recommended practices for logging in Kubernetes at scale.

---

# 🏗️ 1. Use a Centralized Logging Stack (ELK / EFK / Loki / Graylog)

Running logs locally on Pods or nodes → **not enough**.  
Containers die. Pods restart. Nodes get replaced. Local logs vanish.

You need a **central aggregator** such as:
### 🔹 ELK Stack

- ElasticSearch
- Logstash
- Kibana

### 🔹 EFK Stack

- ElasticSearch
- Fluentd / Fluent Bit
- Kibana

### 🔹 Loki Stack (lightweight)

- Loki
- Promtail / Fluent Bit
- Grafana

### 🔹 Graylog

- Graylog Server
- Elasticsearch
- MongoDB
- 
Which one to choose:

- **Loki** → lightweight, cheap, cloud-native
- **EFK/ELK** → enterprise-grade, indexing, querying
- **Graylog** → security & SIEM-focused

- ---

# 🗄️ 2. Always Have a Retention Policy

🔥 Logs grow like crazy.  
🔥 If you don’t limit them → your storage will get nuked.

Recommended retention patterns:

- Development: **1–7 days**
- Staging: **7–14 days**
- Production: **14–90 days** based on compliance/security needs
- Critical apps: **90–180+ days**
- Security-focused clusters (CKS-ready): **365+ days**

Retention reduces:

- Disk usage
- Costs
- Noisy data
- Slow search queries

---

# 🧱 3. Structured Logs Only (No Raw Text)

Raw logs are a nightmare to search.

Use **JSON logging** or at least key=value patterns:

### Bad (raw text):
```
database connection failed!
```
### Good (structured):
```JSON
{
  "level": "error",
  "service": "db",
  "msg": "connection_failed",
  "request_id": "abcd-123",
  "duration_ms": 42
}
```

Benefits of structured logs:

- Better filtering
- Better dashboards
- Faster search
- Easy correlation with traces & metrics
- Standardized across services

---

# 🧪 4. Separate Development, Staging, and Production Logs

Environment separation prevents chaos.

### Why?

- Dev logs should never pollute production
- Different retention periods
- Different access permissions
- Different levels of verbosity

### How to enforce it:

- Use labels:
```
env=prod
env=staging
env=dev
```
- Use separate indexes or buckets
- Use namespaces wisely
- Use Log policies per environment
---
# 🔐 5. Use RBAC for Log Access

Logs often contain:

- environment variables
- internal URLs
- tokens
- secrets (accidentally)
- user activity
- error traces

Meaning → **logs = sensitive data**.

Access to logs should be controlled using:

- Kubernetes RBAC
- Logging system built-in roles (Kibana roles, Loki RBAC, Graylog roles)
- SSO integration (OIDC, Keycloak)

Minimum recommended roles:

- **Developers:** access to their own namespace logs
- **SRE/DevOps:** wider cluster access
- **Security team:** raw logs + audit logs
- **Audit logs:** extremely restricted

---

# 🧩 6. Logs Should Be Meaningful

A few quick principles:

### 🔹 Include Request IDs & Trace IDs

So logs can correlate across microservices.

### 🔹 Include log levels

- DEBUG
- INFO
- WARNING
- ERROR
- CRITICAL

### 🔹 Avoid dumping huge JSON objects

This kills search performance.

### 🔹 Timestamp everything

Prefer UTC for consistency.