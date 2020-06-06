# Deploy test application

*This chapter presents how to install the Online Boutique application for the purpose of service
mesh evaluation.*

## Outline

In this chapter you will learn:

* How to install the Online Boutique test application.
* How to verify the installation.
* How to access the application.

## Walkthrough

For the purpose of this workshop we will use the test application named
[**Online Boutique**](https://github.com/GoogleCloudPlatform/microservices-demo) (previously: Hipster
Shop) provided by the Google Cloud Platform team. The application will allow us to evaluate several
service mesh scenarios, including traffic routing, traffic shifting, and circuit breaking.

Online Boutique is a cloud-native microservices demo. It consists of 10 microservices, written in
polyglot programming languages (Go, C#, Node.js, Python, Java), that implement a web-based
e-commerce app where users can browse items, add them to the cart, and purchase them:

![](/assets/images/test-app-screenshot-1.png)
![](/assets/images/test-app-screenshot-2.png)

The application architecture is presented below:

![](/assets/images/test-app-architecture.png)

The frontend service is an entry point to the application. It exposes an HTTP endpoint for its
clients (web browser, load generator), providing the content compiled from the integrated
microservices. Internally, the microservices communicate using the gRPC protocol.

### Install the app

Start with enabling the sidecar injection for the `default` namespace:

```
$ kubectl label namespace default istio-injection=enabled
```

The `istio-injection` label informs the Istio Sidecar Injector running in Istio control plane to
inject a sidecar into each new pod created in the `default` namespace.

Sidecars running alongside application services are responsible for processing the traffic entering
and leaving the pods. They act as local proxies capable of enforcing the requested traffic policies.
Sidecars are the key building block required to form a service mesh. We will inspect them later.

Now, clone the application repository from Github:

```
$ git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
```

Enter the repository and checkout the proper version:

```
$ cd ./microservices-demo
$ git checkout -b v0.2.0 tags/v0.2.0
```

Apply Kubernetes manifests:

```
$ kubectl -n default apply -f ./release/kubernetes-manifests.yaml
```

That will create the required Kubernetes deployments and services:

```
deployment.apps/emailservice created
service/emailservice created
deployment.apps/checkoutservice created
service/checkoutservice created
deployment.apps/recommendationservice created
service/recommendationservice created
deployment.apps/frontend created
service/frontend created
service/frontend-external created
deployment.apps/paymentservice created
service/paymentservice created
deployment.apps/productcatalogservice created
service/productcatalogservice created
deployment.apps/cartservice created
service/cartservice created
deployment.apps/loadgenerator created
deployment.apps/currencyservice created
service/currencyservice created
deployment.apps/shippingservice created
service/shippingservice created
deployment.apps/redis-cart created
service/redis-cart created
deployment.apps/adservice created
service/adservice created
```

### Verify installation

Ensure that all deployed pods are running (inspect `READY` column):

```
$ kubectl -n default get pods
NAME                                     READY   STATUS    RESTARTS   AGE
adservice-687b58699c-766hv               2/2     Running   0          19m
cartservice-778cffc8f6-9klmn             2/2     Running   2          20m
checkoutservice-98cf4f4c-5gmcr           2/2     Running   0          20m
currencyservice-c69c86b7c-zsl7c          2/2     Running   0          20m
emailservice-5db6c8b59f-pxjmq            2/2     Running   0          20m
frontend-8d8958c77-pctms                 2/2     Running   0          20m
loadgenerator-6bf9fd5bc9-kmlw2           2/2     Running   3          20m
paymentservice-698f684cf9-9qs2m          2/2     Running   0          20m
productcatalogservice-789c77b8dc-p595c   2/2     Running   0          20m
recommendationservice-75d7cd8d5c-2w4nv   2/2     Running   0          20m
redis-cart-5f59546cdd-tglxz              2/2     Running   0          19m
shippingservice-7d87945947-fl4xr         2/2     Running   0          19m
```

### Access the app

Apply Istio manifests to expose the application outside the Kubernetes cluster:

```
$ kubectl -n default apply -f ./release/istio-manifests.yaml
```

```
gateway.networking.istio.io/frontend-gateway created
virtualservice.networking.istio.io/frontend-ingress created
virtualservice.networking.istio.io/frontend created
serviceentry.networking.istio.io/whitelist-egress-googleapis created
serviceentry.networking.istio.io/whitelist-egress-google-metadata created
```

Obtain the hostname address of the Istio Ingress Gateway:

```
$ kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
a50936c539b864c85a16962a7dcad24b-1660651843.us-east-1.elb.amazonaws.com
```

Visit the address in your web browser (Chrome, Firefox). It should display the Online Boutique
web page.

Explore the application to get familiar with its functionality. For instance, try to add products to
the cart and go througuh the checkout process.
