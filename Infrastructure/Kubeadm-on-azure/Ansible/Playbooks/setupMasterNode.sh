#!/bin/bash


IP_ADDRESS=$(awk '/\[masters\]/{flag=1; next} /^\[/{flag=0} flag{print $1}' ./Inventory/hosts.ini | tr -d '[:space:]')
echo $IP_ADDRESS  >> amine.txt
# Initialize cluster
sudo kubeadm init --control-plane-endpoint $IP_ADDRESS:6443 --pod-network-cidr=10.244.0.0/16 --upload-certs --cri-socket=///var/run/containerd/containerd.sock

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml