# Variables
docker_version=26.0.1
docker_dest=/etc/systemd/system/docker.service.d/
mirror_registry=
kubeadm_version=1.28.0-00
kubectl_version=1.28.0-00
kubelet_version=1.28.0-00
etcd_version=v3.5.13

# Network
loadbalancer_ip=20.20.20.100
master1_ip=20.20.20.101
master2_ip=20.20.20.102
master3_ip=20.20.20.103
worker1_ip=20.20.20.104

# Commands
apt update && apt upgrade -y

echo "[⚙️] Installing tools"
apt install -y wget git vim bash-completion curl htop net-tools dnsutils \
                atop software-properties-common telnet axel jq iotop

echo -e "[⚙️] Docker installation"
which docker || { curl -fsSL https://releases.rancher.com/install-docker/${docker_version}.sh | sh - ;}
{
    systemctl start docker
    systemctl enable docker
}

echo "[⚙️] Configure Docker daemon"
cat >/etc/docker/daemon.json<<EOF
{
"insecure-registries":["https://docker.arvancloud.ir"],
"registry-mirrors": ["https://docker.arvancloud.ir"]
}
EOF

{
    systemctl daemon-reload
    systemctl restart docker
}

echo "[⚙️] Add sysctl settings"
cat >> /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable Swap
echo "[⚙️] Disable swap"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install apt-transport-https pkg
echo "[⚙️] Install apt-transport-https pkg"
apt install -y apt-transport-https

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
ls -ltr /etc/apt/sources.list.d/kubernetes.list
apt update -y

# Install Kubernetes
echo "[⚙️] Install Kubernetes kubeadm, kubelet, kubectl"
apt install -y kubelet="$kubelet_version" kubectl="$kubectl_version" kubeadm="$kubeadm_version" cri-o

# Check versions
kubelet --version
kubeadm version
kubectl version

# Kubernetes bash completion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Start and enable kubelet service
echo "[⚙️] Start and enable kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl restart kubelet >/dev/null 2>&1
systemctl status kubelet >/dev/null 2>&1

# Install etcd on Ubuntu
echo "[⚙️] Installing etcd"
curl -L https://github.com/coreos/etcd/releases/download/"$etcd_version"/etcd-"$etcd_version"-linux-amd64.tar.gz | tar xzvf -
cp etcd-"$etcd_version"-linux-amd64/etcdctl /usr/local/bin
rm -rf etcd-"$etcd_version"-linux-amd64
etcdctl version

echo "[⚙️] Remove all unused packages"
apt autoremove -y

cat >> /etc/hosts <<EOF
$loadbalancer_ip loadbalancer.zeroCluster.lab lb loadbalancer
$master1_ip master-1.zeroCluster.lab master1.zeroCluster.lab master-1 master1
$master2_ip master-2.zeroCluster.lab master2.zeroCluster.lab master-2 master2
$master3_ip master-3.zeroCluster.lab master3.zeroCluster.lab master-3 master3
$worker1_ip worker-1.zeroCluster.lab worker1.zeroCluster.lab worker-1 worker1
EOF