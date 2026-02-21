`kubectl` is the main CLI tool used to interact with a Kubernetes cluster.

You can install it using this command:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

### 🔧 Enhancing kubectl

You can integrate kubectl with:

- **zsh plugins**
- **kubectl aliases**
- **kubectl-plugins**
- Third-party tools like:
    - `krew` (plugin manager)
    - `kubectx` and `kubens`
    - `stern` (log tailing)

These tools improve speed, readability, and make your life less painful.