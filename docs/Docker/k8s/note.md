### docker proxy

```
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="ALL_PROXY=socks5://127.0.0.1:1080"
```


### install

```
master  --->    yum install docker-ce kubelet kubeadm kubectl
node    --->    yum install docker-ce kubelet kubeadm

```
### bridge

```
echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
```

### init

```
kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12
```

### join

```
kubeadm join 10.211.55.8:6443 --token i6zo3l.dh8qoq9micgscaru --discovery-token-ca-cert-hash sha256:eeb8bbd378f964671066e88736c7bb5fc55e48414d4c95fa53edf92ba89084f6
```

### fannel

```
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml
```

### token

```
kubeadm token list
```

### ca sha256

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```
