# Cleanup

## Destroy Kubernetes cluster

In order to delete the cluster using kops, first retrieve the S3 state store where kops maintains
the cluster state information:

```
$ aws s3api list-buckets --region us-east-1
-------------------------------------------------------------------------------------------------------
|                                             ListBuckets                                             |
+-----------------------------------------------------------------------------------------------------+
||                                              Buckets                                              ||
|+------------------------------------+--------------------------------------------------------------+|
||            CreationDate            |                            Name                              ||
|+------------------------------------+--------------------------------------------------------------+|
||  2020-06-03T12:49:06+00:00         |  istio-workshop-15904-kops-cluster-state-store               ||
|+------------------------------------+--------------------------------------------------------------+|
||                                               Owner                                               ||
|+------------------------------+--------------------------------------------------------------------+|
||          DisplayName         |                                ID                                  ||
|+------------------------------+--------------------------------------------------------------------+|
||  awslabsc0w768921t1588545607 |  efc35b87124f4803bc1328ab888b22a8e605a5a635db18a2f25c619067cde3a4  ||
|+------------------------------+--------------------------------------------------------------------+|

$ BUCKET_NAME=istio-workshop-15904-kops-cluster-state-store
$ export KOPS_STATE_STORE=s3://$BUCKET_NAME
```

Then, delete Kubernetes cluster in AWS using kops `delete` command:

```
$ kops delete cluster istio-workshop.k8s.local --yes
```

Wait until all AWS resources are deleted. **Do not interrupt the process execution**. It may result
with left-over resources that continue to consume the AWS credits.

During the cluster deletion you might encouter warnings similar to:

```
Not all resources deleted; waiting before reattempting deletion
```

```
subnet:subnet-08991b365aca297fd	still has dependencies, will retry
```

These warnings are normal behaviour. Ignore them.

In the end, the command should inform about completed cluster deletion:

```
Deleted kubectl config for istio-workshop.k8s.local
Deleted cluster: "istio-workshop.k8s.local"
```
