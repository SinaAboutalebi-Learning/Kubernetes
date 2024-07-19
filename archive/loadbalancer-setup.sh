# Variables
loadbalancer_name=loadbalancer.zeroCluster.lab
loadbalancer_port=6443
loadbalancer_ip=20.20.20.100
master1_ip=20.20.20.101
master2_ip=20.20.20.102
master3_ip=20.20.20.103
worker1_ip=20.20.20.104

# Commands
apt install haproxy -y

cat >> /etc/haproxy/haproxy.cfg <<EOF
frontend fe-apiserver
    bind 0.0.0.0:6443
    mode tcp
    option tcplog
    default_backend be-apiserver

backend be-apiserver
    mode tcp
    option tcplog
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

    server master1 $master1_ip:6443 check
    server master2 $master2_ip:6443 check
    server master3 $master3_ip:6443 check
EOF

cat /etc/haproxy/haproxy.cfg

# Start and Enable Haproxy Service 
echo "[⚙️] Start and Enable Haproxy Service"
systemctl enable haproxy >/dev/null 2>&1
systemctl restart haproxy >/dev/null 2>&1
systemctl status haproxy >/dev/null 2>&1
