RBAC in Kubernetes is the main **authorization** system. Think of it as the rulebook that decides what requests are allowed after the API server already knows _who_ you are.

A **Role** is a little permission list inside a namespace. It specifies what actions (verbs like get, list, create, patch) are allowed on which resources (Pods, Services, Secrets…).

A **RoleBinding** is the bridge that connects a Role to a subject. The subject can be:

- a user,
- a group,
- or a service account.

People often forget this, but a Role itself is powerless until something is bound to it.

A **ClusterRole** is a Role that works cluster-wide. If a namespace Role is your studio apartment, a ClusterRole is the whole building. It can apply:

- to non-namespaced resources (like nodes),
- or to all namespaces.

A **ClusterRoleBinding** gives that cluster-wide power to someone.

There’s also the idea of _aggregated_ ClusterRoles, which let you compose powerful roles from smaller ones, but that’s optional spice.

---

Service Accounts sit at the intersection of _authentication_ and _authorization_. They give pods an identity. When a pod wants to call the Kubernetes API, the cluster knows who it is by the token mounted inside the pod. That identity can then be bound to Roles/ClusterRoles, letting you craft very fine-grained pod privileges.

They’re also perfect for giving external tools (CI/CD, monitoring agents, etc.) scoped access without ever creating human accounts. Better than giving your cluster the keys to your developer’s personal laptop.

---

Privileges flow like this:

Service Account → RoleBinding → Role → Allowed verbs/resources.

Or if you’re going global:

Service Account → ClusterRoleBinding → ClusterRole → Allowed verbs/resources.

Once this map settles in your brain, everything involving permissions becomes much easier—especially when debugging those classic 403s that make you feel like the cluster is silently judging you.