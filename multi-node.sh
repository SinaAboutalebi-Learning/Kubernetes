cp kubeadm_config to /opt/kubeadm_config.yml

#get images
kubeadm config images list --config /opt/kubeadm_config.yml
kubeadm config images pull --config /opt/kubeadm_config.yml

k8s.gcr.io/kube-apiserver:v1.28.8
k8s.gcr.io/kube-controller-manager:v1.28.8
k8s.gcr.io/kube-scheduler:v1.28.8
k8s.gcr.io/kube-proxy:v1.28.8
k8s.gcr.io/pause:3.9
k8s.gcr.io/etcd:3.5.12-0
k8s.gcr.io/coredns:v1.10.1

# initalize master
kubeadm init --config /opt/kubeadm_config.yml
