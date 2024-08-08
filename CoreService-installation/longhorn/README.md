# Longhorn Installation Guide

## Installation Requirements

Each node in the Kubernetes cluster where Longhorn is installed must meet the following requirements:

- **Container Runtime**: Compatible with Kubernetes (Docker v1.13+, containerd v1.3.7+, etc.)
- **Kubernetes Version**: >= v1.21
- **open-iscsi**: Installed and the `iscsid` daemon is running on all nodes. [Help installing open-iscsi](#install-open-iscsi).
- **NFSv4 Client**: Installed if RWX support is required. [Help installing NFSv4 client](#install-nfs-client).
- **Host Filesystem**: Supports file extents feature. Supported filesystems include:
  - ext4
  - XFS
- **Utilities**: `bash`, `curl`, `findmnt`, `grep`, `awk`, `blkid`, `lsblk` must be installed.
- **Mount Propagation**: Must be enabled.
- **Longhorn Workloads**: Must be able to run as root for proper deployment and operation.

For minimum recommended hardware, refer to the [best practices guide](https://longhorn.io/docs/1.6.2/best-practices/).

## Using the Environment Check Script

To check your environment for potential issues, use the provided script. Ensure `jq` is installed locally before running the script:
```bash
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/scripts/environment_check.sh | bash
```

## Installing Dependencies

### Install open-iscsi
Run the following command to install open-iscsi:
```bash
apt-get install open-iscsi
```
Alternatively, you can use the provided installer:
```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/deploy/prerequisite/longhorn-iscsi-installation.yaml
```

### Check NFSv4 Support
Ensure NFSv4.1 and NFSv4.2 support is enabled in the kernel:
```bash
cat /boot/config-`uname -r` | grep CONFIG_NFS_V4_1
cat /boot/config-`uname -r` | grep CONFIG_NFS_V4_2
```

### Install NFS Client
Run the following command to install the NFS client:
```bash
apt-get install nfs-common
```
Alternatively, you can use the provided installer:
```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/deploy/prerequisite/longhorn-nfs-installation.yaml
```

## Installing Longhorn

Apply the Longhorn manifests to deploy Longhorn:
```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/deploy/longhorn.yaml
```
### Monitoring Installation
Monitor the Longhorn pods to ensure they are running correctly:
```bash
kubectl get pods --namespace longhorn-system --watch
```

## Configuring Longhorn Frontend Service as a LoadBalancer

By default, the `longhorn-frontend` service is configured as a `ClusterIP` service. To expose it as a LoadBalancer service, follow the steps below:

1. Create a YAML file for the longhorn-frontend service with the following content:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: longhorn-frontend
  namespace: longhorn-system
  labels:
    app: longhorn-ui
    app.kubernetes.io/instance: longhorn
    app.kubernetes.io/name: longhorn
    app.kubernetes.io/version: v1.6.2
spec:
  type: LoadBalancer
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: http
  selector:
    app: longhorn-ui
```

2. Apply the YAML file:
```bash
kubectl apply -f longhorn-frontend-lb.yaml
```

This will configure the longhorn-frontend service as a LoadBalancer, allowing external access to the Longhorn UI.