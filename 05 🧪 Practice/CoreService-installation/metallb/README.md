# MetalLB Installation Guide

## Installation Steps

1. **Apply MetalLB's Native Manifests**

   This command will install the core components of MetalLB:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml
   ```
2. **Apply Custom ConfigMap**

    Ensure you have your custom metallb-configmap.yaml file ready with your configuration. Apply it with:
    ```bash
    kubectl apply -f metallb-configmap.yaml
    ```

## Configuration

In your metallb-configmap.yaml, ensure that the configuration matches your network setup. Example configuration:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: metallb-config
  namespace: metallb-system
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.240/28  # Adjust to your network range
```      