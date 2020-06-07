# Stopping the cluster

## Stop the cluster

First, list node scaling groups:

```
$ kops get ig
NAME                ROLE    MACHINETYPE MIN	MAX	ZONES
master-us-east-1a   Master  t2.medium   1   1   us-east-1a
nodes               Node    t2.medium   0   0   us-east-1a
```

Save, name for the master group:

```
$ MASTER_NAME=master-us-east-1a
```

Edit the group for Kubernetes worker nodes:

```
$ kops edit ig nodes
```

```yaml
apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  ...
  name: nodes
spec:
  image: kope.io/k8s-1.16-debian-stretch-amd64-hvm-ebs-2020-01-17
  machineType: t2.medium
  maxSize: 0
  minSize: 0
  ...
```

Edit the group for Kubernetes master nodes:

```
$ kops edit ig $MASTER_NAME
```

```yaml
apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  ...
  name: master-us-east-1a
spec:
  image: kope.io/k8s-1.16-debian-stretch-amd64-hvm-ebs-2020-01-17
  machineType: t2.medium
  maxSize: 0
  minSize: 0
  ...
```

Update the cluster:

```
$ kops update cluster --yes

Using cluster from kubectl context: istio-workshop.k8s.local

I0607 16:18:35.680522   18665 apply_cluster.go:556] Gossip DNS: skipping DNS validation
W0607 16:18:35.827462   18665 firewall.go:250] Opening etcd port on masters for access from the nodes, for calico.  This is unsafe in untrusted environments.
I0607 16:18:38.189527   18665 executor.go:103] Tasks: 0 done / 95 total; 46 can run
I0607 16:18:39.544345   18665 executor.go:103] Tasks: 46 done / 95 total; 24 can run
I0607 16:18:40.482241   18665 executor.go:103] Tasks: 70 done / 95 total; 21 can run
I0607 16:18:41.809540   18665 executor.go:103] Tasks: 91 done / 95 total; 3 can run
I0607 16:18:42.444500   18665 executor.go:103] Tasks: 94 done / 95 total; 1 can run
I0607 16:18:42.651568   18665 executor.go:103] Tasks: 95 done / 95 total; 0 can run
I0607 16:18:43.972348   18665 update_cluster.go:305] Exporting kubecfg for cluster
kops has set your kubectl context to istio-workshop.k8s.local

Cluster changes have been applied to the cloud.


Changes may require instances to restart: kops rolling-update cluster
```

Run the rolling update of the cluster:

```
$ kops rolling-update cluster --cloudonly
```

Now, open the AWS console, go to the EC2 dashboard and ensure that all instances are in `terminated` state.

## Restart the cluster

In order to restart the stopped cluster, run the exact same steps but provide different values for `minSize` and `maxSize` parameters in the instance group settings.

For Kubernetes worker nodes:

```yaml
maxSize: 2
minSize: 2
```

For Kubernetes master nodes:

```yaml
maxSize: 1
minSize: 1
```

Wait 5-10 minutes until the cluster is ready and all pods are recreated. Inspect `default` and `istio-system` namespaces to ensure that are pods are up and running.
