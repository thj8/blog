#!/bin/bash
docker pull k8s.gcr.io/kube-apiserver
docker pull k8s.gcr.io/kube-controller-manager
docker pull k8s.gcr.io/kube-scheduler
docker pull k8s.gcr.io/kube-proxy
docker pull k8s.gcr.io/pause
docker pull k8s.gcr.io/etcd
docker pull k8s.gcr.io/coredns

#!/bin/bash

set -e 
# Check version in https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# Search "Running kubeadm without an internet connection"
# For running kubeadm without an internet connection you have to pre-pull the required master images for the version of choice:
KUBE_VERSION=v1.15.2
KUBE_DASHBOARD_VERSION=v1.10.1
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers
PUSH_REGISTER_URL=172.29.100.191:5000

images=(
    kube-proxy:${KUBE_VERSION}
    kube-scheduler:${KUBE_VERSION}
    kube-controller-manager:${KUBE_VERSION}
    kube-apiserver:${KUBE_VERSION}
    pause:${KUBE_PAUSE_VERSION}
    etcd:${ETCD_VERSION}
    coredns:${DNS_VERSION}
    kubernetes-dashboard-amd64:${KUBE_DASHBOARD_VERSION}
) 

for imageName in ${images[@]} ; do
docker pull $ALIYUN_URL/$imageName
docker tag $ALIYUN_URL/$imageName $GCR_URL/$imageName
docker rmi $ALIYUN_URL/$imageName
done

docker images

for imageName in ${images[@]} ; do
docker tag $GCR_URL/$imageName $PUSH_REGISTER_URL/$GCR_URL/$imageName
docker push $PUSH_REGISTER_URL/$GCR_URL/$imageName
docker rmi -f $PUSH_REGISTER_URL/$GCR_URL/$imageName 
done