**(Stateless Workload Controller)**

A Deployment is the modern, feature-rich controller to manage **stateless** applications.

### ✔ Why Deployments are preferred over [[ReplicaSet]]?

- They support **rollback** (history kept automatically)
- Provide **safe rollout strategies**
- Ensure consistent Pod updates

---

### 🎛 **Deployment Strategies**

#### **1. Recreate**

- Terminates all Pods
- Creates new Pods
- **Has downtime**
- Used when app can't run two versions at once

---

#### **2. RollingUpdate** (default)

- Slowly reduces old Pods and increases new ones
- Zero downtime
- Controlled using `maxUnavailable` and `maxSurge`

---

#### **3. Blue/Green**

- Entire second environment created (blue=new, green=old)
- Switch traffic once ready
- Very safe, **but high resource usage**

---

#### **4. Canary Deployment**

- Route **N% of traffic** to the new version
- Observe behavior → promote or rollback

---

#### **5. A/B Testing**

- Similar to canary but **selects users based on filters**  
    e.g., user-agent, cookie, region

---

#### **6. Shadow Release**

- Copy **real production traffic** to v2
- Only v1 returns responses
- Great for real-world testing without user impact