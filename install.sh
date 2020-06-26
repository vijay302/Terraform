#!/bin/bash
sudo su
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo  git clone https://github.com/vijay302/Terraform  /home/elasticsearch/
#sudo cd ../..
#sudo cp -r /Terraform /home/ubuntu/Terraform
sudo apt-get update

sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.13.5-00 kubeadm=1.13.5-00 kubectl=1.13.5-00 kubernetes-cni=0.7.5-00

sudo apt-mark hold docker-ce kubelet kubeadm kubectl
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#This will  configure kubeconfig file for  default config of your system
cp /etc/kubernetes/admin.conf $HOME
chown $(id -u):$(id -g) $HOME/admin.conf
#$b=/home/admin.conf
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config

#echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc
sudo cd /home/elasticsearch
kubectl apply -f https://github.com/vijay302/Terraform/blob/master/kube-logging.yaml
kubectl apply -f https://github.com/vijay302/Terraform/blob/master/elasticsearch_statefulset.yaml
kubectl apply -f https://github.com/vijay302/Terraform/blob/master/elasticsearch_svc.yaml
kubectl apply -f https://github.com/vijay302/Terraform/blob/master/fluentd.yaml
kubectl apply -f https://github.com/vijay302/Terraform/blob/master/kibana.yaml





