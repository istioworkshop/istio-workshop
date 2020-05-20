# Install Istio Service Mesh

## Outline

In this chapter you will learn:

* How to setup and use the Istio management utility - `istioctl`.
* How to use the binary to install Istio control plane.
* How to verify the installation.

## Walkthrough

### Install istioctl

Istio provides an advanced tool named `istioctl` for managing its control and data planes. The tool
enables automated installation of Istio with custom installation profiles. Besides, it provides
a set of commands for inspecting the configuration of individual sidecars and troubleshooting issues
that emerge in the service mesh.

We will use `istioctl` to install Istio in the Kubernetes cluster.

First, download the Istio release package from the upstream server:

```
$ curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.2 sh -
```

The script above will automatically download and extract the package archive into the current
directory:

```
$ ls -al |grep istio
drwxr-x---.  6 root root       113 Apr 21 00:51 istio-1.5.2
```

Install the `istioctl` binary into the system path:

```
$ mv ./istio-1.5.2/bin/istioctl /usr/local/bin/
$ chmod +x /usr/local/bin/istioctl
```

Next, test if the binary is working:

```
$ istioctl
Istio configuration command line utility for service operators to
debug and diagnose their Istio mesh.

Usage:
  istioctl [command]

Available Commands:
  analyze         Analyze Istio configuration and print validation messages
  authn           Interact with Istio authentication policies
  authz           (authz is experimental. Use `istioctl experimental authz`)
  convert-ingress Convert Ingress configuration into Istio VirtualService configuration
  dashboard       Access to Istio web UIs
  deregister      De-registers a service instance
  experimental    Experimental commands that may be modified or deprecated
  help            Help about any command
  kube-inject     Inject Envoy sidecar into Kubernetes pod resources
  manifest        Commands related to Istio manifests
  operator        Commands related to Istio operator controller.
  profile         Commands related to Istio configuration profiles
  proxy-config    Retrieve information about proxy configuration from Envoy [kube only]
  proxy-status    Retrieves the synchronization status of each Envoy in the mesh [kube only]
  register        Registers a service instance (e.g. VM) joining the mesh
  upgrade         Upgrade Istio control plane in-place
  validate        Validate Istio policy and rules (NOTE: validate is deprecated and will be removed in 1.6. Use 'istioctl analyze' to validate configuration.)
  verify-install  Verifies Istio Installation Status or performs pre-check for the cluster before Istio installation
  version         Prints out build version information
```

> **NOTE:** We will use the `istioctl` binary multiple times throughout the workshop. Use the
  `istioctl help` command whenever you encounter issues or something is not clear. The command
  output will provide you with all necessary instructions (options with detailed documentation).
  For instance: `istioctl help manifest apply`.

### Deploy control plane

Execute `istioctl` [manifest apply](https://istio.io/docs/reference/commands/istioctl/#istioctl-manifest-apply)
command to deploy the Istio control plane:

```
$ istioctl manifest apply --set profile=demo
- Applying manifest for component Base...
✔ Finished applying manifest for component Base.
- Applying manifest for component Pilot...
✔ Finished applying manifest for component Pilot.
  Waiting for resources to become ready...
  Waiting for resources to become ready...
  Waiting for resources to become ready...
  Waiting for resources to become ready...
- Applying manifest for component EgressGateways...
- Applying manifest for component IngressGateways...
- Applying manifest for component AddonComponents...
✔ Finished applying manifest for component EgressGateways.
✔ Finished applying manifest for component IngressGateways.
✔ Finished applying manifest for component AddonComponents.
✔ Installation complete
```

The command will deploy all Istio components required for the purpose of the workshop:

* **Istiod** - key component, a composite of:
    - **Istio Pilot** - service discovery and config distribution to Envoy sidecars,
    - **Istio Galley** - validation of user-provided policies,
    - **Istio Citadel** - service mesh CA, certificate signing and distribution,
    - **Istio Sidecar Injector** - automated injection of sidecars into pods;
* **Istio Ingress Gateway** - ingress traffic control,
* **Istio Egress Gateway** - egress traffic control,
* **Istio Tracing** - distributed tracing, wrapper on top of Jaeger
* **Prometheus** - metric sink, collects and stores service metrics,
* **Grafana** - metric data visualization,
* **Kiali** - mesh topology dashboard.


### Verify installation

Ensure that all deployed pods are running (inspect `READY` column):

```
$ kubectl -n istio-system get pods
NAME                                   READY   STATUS    RESTARTS   AGE
grafana-78bc994d79-h5cpf               1/1     Running   0          2m50s
istio-egressgateway-595c6bbdd4-5z8dc   1/1     Running   0          3m
istio-ingressgateway-dffb85968-chgcf   1/1     Running   0          2m58s
istio-tracing-c7b59f68f-5z49t          1/1     Running   0          2m49s
istiod-6d85865b9c-lrzsm                1/1     Running   0          3m17s
kiali-7ff568c949-hcpzp                 1/1     Running   0          2m48s
prometheus-fd997976c-7gpgs             2/2     Running   0          2m48s
```

Ensure that the required services have been created:

```
$ kubectl -n istio-system get svc
NAME                        TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                                                                                      AGE
grafana                     ClusterIP      10.233.30.217   <none>        3000/TCP                                                                                                                                     3m20s
istio-egressgateway         ClusterIP      10.233.26.241   <none>        80/TCP,443/TCP,15443/TCP                                                                                                                     3m33s
istio-ingressgateway        LoadBalancer   10.233.34.251   <IP-ADDRESS>  15020:31571/TCP,80:31276/TCP,443:31871/TCP,15029:31062/TCP,15030:32076/TCP,15031:30667/TCP,15032:31128/TCP,31400:32566/TCP,15443:30797/TCP   3m29s
istio-pilot                 ClusterIP      10.233.16.50    <none>        15010/TCP,15011/TCP,15012/TCP,8080/TCP,15014/TCP,443/TCP                                                                                     3m51s
istiod                      ClusterIP      10.233.59.86    <none>        15012/TCP,443/TCP                                                                                                                            3m51s
jaeger-agent                ClusterIP      None            <none>        5775/UDP,6831/UDP,6832/UDP                                                                                                                   3m20s
jaeger-collector            ClusterIP      10.233.32.190   <none>        14267/TCP,14268/TCP,14250/TCP                                                                                                                3m19s
jaeger-collector-headless   ClusterIP      None            <none>        14250/TCP                                                                                                                                    3m19s
jaeger-query                ClusterIP      10.233.10.253   <none>        16686/TCP                                                                                                                                    3m18s
kiali                       ClusterIP      10.233.42.148   <none>        20001/TCP                                                                                                                                    3m18s
prometheus                  ClusterIP      10.233.57.51    <none>        9090/TCP                                                                                                                                     3m18s
tracing                     ClusterIP      10.233.16.27    <none>        80/TCP                                                                                                                                       3m16s
zipkin                      ClusterIP      10.233.1.86     <none>        9411/TCP                                                                                                                                     3m15s
```

Ensure that an External IP has been assigned to the Istio Ingress Gateway (`EXTERNAL-IP` column):

```
$ kubectl -n istio-system get svc istio-ingressgateway
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                                                                                      AGE
istio-ingressgateway   LoadBalancer   10.233.34.251   <IP-ADDRESS>  15020:31571/TCP,80:31276/TCP,443:31871/TCP,15029:31062/TCP,15030:32076/TCP,15031:30667/TCP,15032:31128/TCP,31400:32566/TCP,15443:30797/TCP   4m28s
```

If all components have been installed correctly, proceed to the next chapter.
