# Install

## Create GlusterFS volume

	$ sudo gluster volume create spip-pv-claim replica 2 192.168.1.81:/data/brick1/spip-pv-claim 192.168.1.37:/data/brick1/spip-pv-claim force
 
	$ sudo gluster volume create mysql-pv-claim replica 2 192.168.1.81:/data/brick1/mysql-pv-claim 192.168.1.37:/data/brick1/mysql-pv-claim force

## Create secret password for Mysql

	$ kubectl create secret generic mysql-pass --from-literal=password=<MYPASSWORD>
	$ kubectl get secrets


## Apply yaml

	$ kubectl apply -f mysql-deployment.yaml 
	$ kubectl apply -f spip-deployment.yaml 