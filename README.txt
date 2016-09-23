computer information
	192.168.116.141 Docker-Registry-v2_141
	192.168.116.144 DomeOS_144
	192.168.116.149 etcd_slave_149
	192.168.116.150 etcd_slave_150
	192.168.116.151 etcd_slave_151
	192.168.116.152 Kubernetes_master_152

	Docker-Registry-v2_141
	  systemctl stop firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		mkdir -p /opt/docker && cd $_
		git clone https://github.com/libin2722/docker-registry-v2.git
		cd /opt/docker/docker-registry-v2
		docker-compose up &
		# 执行mysql脚本
		
	DomeOS_144
	  systemctl stop firewalld
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		systemctl restart docker
		docker login registry.terry.com  # username: terry / password: 111111
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		mkdir -p /opt/docker && cd $_
		git clone https://github.com/libin2722/docker-registry-v2.git
		cd /opt/docker/docker-registry-v2/domeos
		docker-compose up &
		
		#在浏览器访问 http://192.168.116.144:8080/      username: admin  / password: admin
		
	etcd_slave_149
		systemctl stop firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		systemctl restart docker
		docker login registry.terry.com  # username: terry / password: 111111
		
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.149,192.168.116.150,192.168.116.151 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.149:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
    
	etcd_slave_150
		systemctl stop firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		systemctl restart docker
		docker login registry.terry.com  # username: terry / password: 111111
		
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.149,192.168.116.150,192.168.116.151 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.150:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
		
	etcd_slave_151
		systemctl stop firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		systemctl restart docker
		docker login registry.terry.com  # username: terry / password: 111111
		
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_etcd.sh
		chmod +x start_etcd.sh
		./start_etcd.sh --cluster-nodes 192.168.116.149,192.168.116.150,192.168.116.151 --client-port 4012 --data-path /opt/etcd/data --etcd-version 2.3.1 --peer-port 4010
		#验证
		curl -L 192.168.116.151:4012/health
		# {"health": "false"}  如果两台以上机器启动了这里应该是{"health": "true"}
		
	Kubernetes_master_152
		yum remove docker-engine
		systemctl stop firewalld
		echo '192.168.116.141 registry.terry.com' >> /etc/hosts
		scp root@192.168.116.141:/opt/docker/docker-registry-v2/nginx/devdockerCA.crt /etc/pki/ca-trust/source/anchors/
		update-ca-trust enable
		update-ca-trust extract
		#systemctl restart docker
		#docker login registry.terry.com  # username: terry / password: 111111
		
		curl -O http://domeos-script.bjctc.scs.sohucs.com/start_master_centos.sh
		chmod +x start_master_centos.sh
		./start_master_centos.sh --cluster-dns 172.16.40.1 --cluster-domain domeos.local --docker-graph-path /opt/domeos/openxxs/docker --docker-registry-crt /etc/pki/ca-trust/source/anchors/devdockerCA.crt --etcd-servers http://192.168.116.149:4012,http://192.168.116.150:4012,http://192.168.116.151:4012 --flannel-network-ip-range 172.24.0.0/13 --flannel-subnet-len 22 --flannel-version 0.5.5 --insecure-bind-address 0.0.0.0 --insecure-port 8080 --insecure-docker-registry 192.168.116.141:5000 --kube-apiserver-port 8080 --kubernetes-version 1.2.0 --service-cluster-ip-range 172.16.0.0/13 --secure-docker-registry https://registry.terry.com
		
