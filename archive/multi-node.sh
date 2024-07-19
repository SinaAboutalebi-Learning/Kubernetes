cp kubeadm_config to /opt/kubeadm_config.yml

#get images
kubeadm config images list --config /opt/kubeadm_config.yml
kubeadm config images pull --config /opt/kubeadm_config.yml

docker pull registry.k8s.io/kube-apiserver:v1.28.8
docker pull registry.k8s.io/kube-controller-manager:v1.28.8
docker pull registry.k8s.io/kube-scheduler:v1.28.8
docker pull registry.k8s.io/kube-proxy:v1.28.8
docker pull registry.k8s.io/pause:3.9
docker pull registry.k8s.io/etcd:3.5.12-0
docker pull registry.k8s.io/coredns/coredns:v1.10.1

# initalize master
kubeadm init --config /opt/kubeadm_config.yml

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Deploy Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml


# SSH CONFIGS
cat /etc/ssh/sshd_config | grep PermitRootLogin
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep PermitRootLogin
systemctl restart sshd


# copy Certificates on master 2 and 3
scp -r root@20.20.20.101:/etc/kubernetes/pki /etc/kubernetes

# For Master 2
kubeadm join loadbalancer.zerocluster.lab:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:a6f9fc0f549ccbc4db420032a25acbeb8b7b134837c6c0e421c365b8fbc2eabf \
        --control-plane --apiserver-advertise-address 20.20.20.102 --cri-socket="unix:///var/run/crio/crio.sock"
# For Master 3
kubeadm join loadbalancer.zerocluster.lab:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:a6f9fc0f549ccbc4db420032a25acbeb8b7b134837c6c0e421c365b8fbc2eabf \
        --control-plane --apiserver-advertise-address 20.20.20.103 --cri-socket="unix:///var/run/crio/crio.sock"

# For Worker 1 
kubeadm join loadbalancer.zerocluster.lab:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:a6f9fc0f549ccbc4db420032a25acbeb8b7b134837c6c0e421c365b8fbc2eabf \
        --cri-socket="unix:///var/run/crio/crio.sock"

# CHECK ETCD server

export endpoint="https://20.20.20.101:2379,https://20.20.20.102:2379,https://20.20.20.103:2379"
export flags="--cacert=/etc/kubernetes/pki/etcd/ca.crt \
              --cert=/etc/kubernetes/pki/etcd/server.crt \
              --key=/etc/kubernetes/pki/etcd/server.key"
export endpoints=$(sudo ETCDCTL_API=3 etcdctl member list $flags --endpoints=${endpoint} \
                   --write-out=json | jq -r '.members | map(.clientURLs) | add | join(",")')

# Verify
sudo ETCDCTL_API=3 etcdctl  $flags --endpoints=${endpoint} member list
sudo ETCDCTL_API=3 etcdctl  $flags --endpoints=${endpoint} endpoint status
sudo ETCDCTL_API=3 etcdctl  $flags --endpoints=${endpoint} endpoint health
sudo ETCDCTL_API=3 etcdctl  $flags --endpoints=${endpoint} alarm list
sudo ETCDCTL_API=3 etcdctl  $flags --endpoints=${endpoint} get / --prefix --keys-only --limit=30

sudo etcdctl  $flags --endpoints=${endpoint} --write-out=table member list
sudo etcdctl  $flags --endpoints=${endpoint} --write-out=table endpoint status
sudo etcdctl  $flags --endpoints=${endpoint} --write-out=table endpoint health
sudo etcdctl  $flags --endpoints=${endpoint} --write-out=table alarm list
sudo etcdctl  $flags --endpoints=${endpoint} --write-out=table get / --prefix --keys-only --limit=30




Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join loadbalancer.zerocluster.lab:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:a6f9fc0f549ccbc4db420032a25acbeb8b7b134837c6c0e421c365b8fbc2eabf \
        --control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join loadbalancer.zerocluster.lab:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:a6f9fc0f549ccbc4db420032a25acbeb8b7b134837c6c0e421c365b8fbc2eabf 