启动etcd
./start_etcd.sh --cluster-nodes 192.168.116.145,192.168.116.146,192.168.116.147 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
验证
curl -L 192.168.116.145:4012/health
curl -L 192.168.116.146:4012/health
curl -L 192.168.116.147:4012/health


部署kubernets master 在 145 机器上
./start_master_centos.sh --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker --docker-registry-crt /etc/pki/ca-trust/source/anchors/devdockerCA.crt --etcd-servers http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-network-ip-range 172.24.0.0/13 --flannel-subnet-len 22 --flannel-version 0.5.5 --insecure-bind-address 0.0.0.0 --insecure-port 8080 --insecure-docker-registry 192.168.116.141:5000 --kube-apiserver-port 8080 --kubernetes-version 1.2.0 --service-cluster-ip-range 172.16.0.0/13 --secure-docker-registry https://registry.terry.com



Kubernetes 中加入 node
./start_node_centos.sh --api-server http://192.168.116.148:8080 --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker-graph --docker-log-level warn --domeos-server 192.168.116.133:8080 --etcd-server http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-version 0.5.5 --heartbeat-addr 0.0.0.0:6030 --hostname-override my-host-01 --k8s-data-dir /opt/domeos/openxxs/k8s-data --kubernetes-version 1.2.0 --monitor-transfer 0.0.0.0:8433,0.0.0.1:8433 --node-labels TESTENV=HOSTENVTYPE,PRODENV=HOSTENVTYPE --registry-type https --registry-arg registry.terry.com
