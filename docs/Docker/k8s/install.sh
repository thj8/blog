#!/bin/bash
yum install -y wget
if [[ `cat /etc/yum.repos.d/CentOS-Base.repo|grep aliyun | wc -l` -eq 0 ]]; then
    cd /etc/yum.repos.d/
    mv CentOS-Base.repo CentOS-Base.repo_bak
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    cd /tmp

    yum install -y yum-utils
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum makecache fast
fi



yum install -y vim curl wget net-tools lsof nmap-ncat.x86_64 git
yum install -y device-mapper-persistent-data lvm2
yum install -y docker-ce


sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
setenforce 0
systemctl stop firewalld.service
systemctl disable firewalld.service

touch /etc/sysctl.d/k8s.conf
cat <<"EOF" > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

systemctl start docker
systemctl enable docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum makecache fast && yum install -y kubelet kubeadm kubectl
echo "KUBELET_EXTRA_ARGS=\"--fail-swap-on=false\"" > /etc/sysconfig/kubelet


kubeadm init \
      --pod-network-cidr=10.244.0.0/16 \
      --apiserver-advertise-address=10.151.30.57 \
      --ignore-preflight-errors=Swap

wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml
