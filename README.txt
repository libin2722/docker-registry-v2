computer information
	192.168.116.141 Docker-Registry-v2
	192.168.116.144 DomeOS
	192.168.116.145 etcd-slave-1
	192.168.116.146 etcd-slave-2
	192.168.116.147 etcd-slave-3
	192.168.116.138 Kubernetes_master
	
	echo '192.168.116.141 registry registry.terry.com' >> /etc/hosts
	echo '192.168.116.145 etcd-slave-1' >> /etc/hosts
	echo '192.168.116.146 etcd-slave-2' >> /etc/hosts
	echo '192.168.116.147 etcd-slave-3' >> /etc/hosts

	Docker-Registry-v2
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 terry.com' >> /etc/hosts
		mkdir -p /opt/docker && cd $_
		git clone https://github.com/libin2722/docker-registry-v2.git
		cd /opt/docker/docker-registry-v2
		# 这里将 nginx/registry.conf 文件中#    auth_basic_user_file /etc/nginx/conf.d/registry.password;注释了，因为domeos不支持带用户名密码的访问
		docker-compose up &
		# 执行mysql脚本
		
	DomeOS
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		systemctl restart docker
		docker login registry.terry.com  # username: terry / password: 111111
		
		mkdir -p /opt/docker && cd $_
		git clone https://github.com/libin2722/docker-registry-v2.git
		cd /opt/docker/docker-registry-v2/domeos
		docker-compose up &
		
		#在浏览器访问 http://192.168.116.144:8080/      username: admin  / password: admin
		
	etcd-slave-1
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.145,192.168.116.146,192.168.116.147 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.145:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
    
	etcd-slave-2
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.145,192.168.116.146,192.168.116.147 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.146:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
		
	etcd-slave-3
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.145,192.168.116.146,192.168.116.147 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.147:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
		
		
	Kubernetes_master
		yum remove docker-engine
		systemctl stop firewalld
		systemctl disable firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		#systemctl restart docker
		#docker login registry.terry.com  # username: terry / password: 111111
		
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_master_centos.sh
		chmod +x start_master_centos.sh
		./start_master_centos.sh --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker --docker-registry-crt /etc/pki/ca-trust/source/anchors/devdockerCA.crt --etcd-servers http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-network-ip-range 172.24.0.0/13 --flannel-subnet-len 22 --flannel-version 0.5.5 --insecure-bind-address 0.0.0.0 --insecure-port 8080 --insecure-docker-registry 192.168.116.141:5000 --kube-apiserver-port 8080 --kubernetes-version 1.2.0 --service-cluster-ip-range 172.16.0.0/13 --secure-docker-registry https://registry.terry.com
		#验证
		sudo /usr/sbin/domeos/k8s/current/kubectl cluster-info
		Kubernetes master is running at http://localhost:8080

	
	
	etcd-slave-1
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_node_centos.sh
		curl -O http://domeos-script.bjctc.scs.sohucs.com/change_hostname.sh
		chmod +x *.sh
		./change_hostname.sh etcd-slave-1
		mkdir -p /etc/docker/certs.d/registry.terry.com
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/docker/certs.d/registry.terry.com/registry.crt
		
			#下面这段之间执行(每一行前面不能有空格)
tee /lib/systemd/system/docker.socket <<-'EOF'
[Unit]
Description=Docker Socket for the API
PartOf=docker.service
[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker
[Install]
WantedBy=sockets.target
EOF 
				
		systemctl unmask docker.service
		systemctl unmask docker.socket
		service docker restart
		
		./start_node_centos.sh --api-server http://192.168.116.138:8080 --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker-graph --docker-log-level warn --domeos-server 192.168.116.144:8080 --etcd-server http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-version 0.5.5 --heartbeat-addr 0.0.0.0:6030 --hostname-override etcd-slave-1 --k8s-data-dir /opt/domeos/openxxs/k8s-data --kubernetes-version 1.2.0 --monitor-transfer 0.0.0.0:8433,0.0.0.1:8433 --node-labels TESTENV=HOSTENVTYPE,PRODENV=HOSTENVTYPE --registry-type https --registry-arg registry.terry.com
		
		#验证
		
		/usr/sbin/domeos/k8s/current/kubectl  --server 192.168.116.138:8080 get nodes
		
  

  
	etcd-slave-2
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_node_centos.sh
		curl -O http://domeos-script.bjctc.scs.sohucs.com/change_hostname.sh
		chmod +x *.sh
		./change_hostname.sh etcd-slave-2
		mkdir -p /etc/docker/certs.d/registry.terry.com
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/docker/certs.d/registry.terry.com/registry.crt
		
			#下面这段之间执行(每一行前面不能有空格)
tee /lib/systemd/system/docker.socket <<-'EOF'
[Unit]
Description=Docker Socket for the API
PartOf=docker.service
[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker
[Install]
WantedBy=sockets.target
EOF 
				
		systemctl unmask docker.service
		systemctl unmask docker.socket
		service docker restart
		
		./start_node_centos.sh --api-server http://192.168.116.138:8080 --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker-graph --docker-log-level warn --domeos-server 192.168.116.144:8080 --etcd-server http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-version 0.5.5 --heartbeat-addr 0.0.0.0:6030 --hostname-override etcd-slave-2 --k8s-data-dir /opt/domeos/openxxs/k8s-data --kubernetes-version 1.2.0 --monitor-transfer 0.0.0.0:8433,0.0.0.1:8433 --node-labels TESTENV=HOSTENVTYPE,PRODENV=HOSTENVTYPE --registry-type https --registry-arg registry.terry.com
		
		#验证
		
		/usr/sbin/domeos/k8s/current/kubectl  --server 192.168.116.138:8080 get nodes
		

	etcd-slave-3
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_node_centos.sh
		curl -O http://domeos-script.bjctc.scs.sohucs.com/change_hostname.sh
		chmod +x *.sh
		./change_hostname.sh etcd-slave-3
		mkdir -p /etc/docker/certs.d/registry.terry.com
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/docker/certs.d/registry.terry.com/registry.crt
		
			#下面这段之间执行(每一行前面不能有空格)
tee /lib/systemd/system/docker.socket <<-'EOF'
[Unit]
Description=Docker Socket for the API
PartOf=docker.service
[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker
[Install]
WantedBy=sockets.target
EOF 
				
		systemctl unmask docker.service
		systemctl unmask docker.socket
		service docker restart
		
		./start_node_centos.sh --api-server http://192.168.116.138:8080 --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker-graph --docker-log-level warn --domeos-server 192.168.116.144:8080 --etcd-server http://192.168.116.145:4012,http://192.168.116.146:4012,http://192.168.116.147:4012 --flannel-version 0.5.5 --heartbeat-addr 0.0.0.0:6030 --hostname-override etcd-slave-3 --k8s-data-dir /opt/domeos/openxxs/k8s-data --kubernetes-version 1.2.0 --monitor-transfer 0.0.0.0:8433,0.0.0.1:8433 --node-labels TESTENV=HOSTENVTYPE,PRODENV=HOSTENVTYPE --registry-type https --registry-arg registry.terry.com
		
		#验证
		
		/usr/sbin/domeos/k8s/current/kubectl  --server 192.168.116.138:8080 get nodes
		
		
		
	Kubernetes_master
		curl -O http://domeos-script.bjctc.scs.sohucs.com/dns.yaml
		
			修改：
				apiVersion: v1
				kind: Service
				metadata:
				  name: skydns-svc
				  labels:
					app: skydns-svc
					version: v9
				spec:
				  selector:
					app: skydns
					version: v9
				  type: ClusterIP
				  clusterIP: 172.16.40.1
				  ports:
					- name: dns
					  port: 53
					  protocol: UDP
					- name: dns-tcp
					  port: 53
					  protocol: TCP
				---
				apiVersion: v1
				kind: ReplicationController
				metadata:
				  name: skydns
				  labels:
					app: skydns
					version: v9
				spec:
				  replicas: 1
				  selector:
					app: skydns
					version: v9
				  template:
					metadata:
					  labels:
						app: skydns
						version: v9
					spec:
					  containers:
						- name: skydns
						  image: pub.domeos.org/domeos/skydns:1.5
						  command:
							- "/skydns"
						  args:
							- "--machines=http://http://192.168.116.145:4012,http://192.168.116.147:4012,http://192.168.116.153:4012"
							- "--domain=domeos.local"
							- "--addr=0.0.0.0:53"
							- "--nameservers=192.168.116.2:53"
						  ports:
							- containerPort: 53
							  name: dns-udp
							  protocol: UDP
							- containerPort: 53
							  name: dns-tcp
							  protocol: TCP
				---
				apiVersion: v1
				kind: ReplicationController
				metadata:
				  name: kube2sky
				  labels:
					app: kube2sky
					version: v9
				spec:
				  replicas: 1
				  selector:
					app: kube2sky
					version: v9
				  template:
					metadata:
					  labels:
						app: kube2sky
						version: v9
					spec:
					  containers:
						- name: kube2sky
						  image: pub.domeos.org/domeos/kube2sky:0.4
						  command:
							- "/kube2sky"
						  args:
							- "--etcd-server=http://192.168.116.145:4012"
							- "--domain=domeos.local"
							- "--kube_master_url=http://0.0.0.1:8080"
		
		kubectl --server 192.168.116.138:8080 create -f dns.yaml
		
		验证

			1.通过以下命令获取集群svc列表，确认skydns-svc是否已创建：

			 kubectl --server <kube-apiserver服务地址> get svc
			 kubectl --server  192.168.116.138:8080 get svc
			
			2.通过以下命令获取集群pod列表，确认skydns-为前缀和kube2sky-为前缀的两个pod是否处于Running状态，如skydns-u44ey和kube2sky-2h1b9：

			 kubectl --server <kube-apiserver服务地址> get pods
			 kubectl --server 192.168.116.138:8080 get pods
			  
			3.查看node上的/etc/resolv.conf文件，确认前两行是否为如下内容(其中的domeos.local为--cluster-domain参数的值，172.16.40.1为--cluster-dns参数的值):

			 search default.svc.domeos.local svc.domeos.local domeos.local
			 nameserver 172.16.40.1
			若没有，添加如上格式内容

			4.在node上进行dns解析验证，方式有多种，如：
			
			 nslookup skydns-svc.default.svc.domeos.local
			 安装 nslookup：yum install -y bind-utils
			如果没有安装nslookup，也可通过ping间接验证：

			 ping skydns-svc.default.svc.domeos.local -c 1
			解析出IP地址则说明dns服务创建成功。

			5.在通过kubernetes创建的容器内部验证，方法同步骤4。

