# Deploy test application

*This chapter presents how to install the Online Boutique application for the purpose of service
mesh evaluation.*

## Outline

In this chapter you will learn:

* How to install the Online Boutique test application.
* How to verify the installation.

## Walkthrough

For the purpose of this workshop we will use the test application named
[**Online Boutique**](https://github.com/GoogleCloudPlatform/microservices-demo) (previously: Hipster
Shop) provided by the Google Cloud Platform team. The application will allow us to evaluate several
service mesh scenarios, including traffic routing, and traffic shifting, and circuit breaking.

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

The load generator populates random requests to the application to simulate user behaviour. That
enables evaluating service mesh scenarios under load.

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
$ git clone https://github.com/istioworkshop/microservices-demo.git
$ cd ./microservices-demo
```

Apply Kubernetes manifests:

```
$ kubectl -n default apply -f ./release/kubernetes/manifests.yaml
```

That will create the required Kubernetes deployments and services:

```
deployment.apps/emailservice-v1 created
deployment.apps/emailservice-v2 created
service/emailservice created
deployment.apps/checkoutservice-v1 created
service/checkoutservice created
deployment.apps/recommendationservice-v1 created
service/recommendationservice created
deployment.apps/frontend-v1 created
service/frontend created
service/frontend-external created
deployment.apps/paymentservice-v1 created
service/paymentservice created
deployment.apps/productcatalogservice-v1 created
deployment.apps/productcatalogservice-v2 created
service/productcatalogservice created
deployment.apps/cartservice-v1 created
service/cartservice created
deployment.apps/loadgenerator created
deployment.apps/currencyservice-v1 created
service/currencyservice created
deployment.apps/shippingservice-v1 created
deployment.apps/shippingservice-v2 created
deployment.apps/shippingservice-v3 created
service/shippingservice created
deployment.apps/redis-cart-v1 created
service/redis-cart created
deployment.apps/adservice-v1 created
service/adservice created
```

### Verify installation

Ensure that all deployed pods are running (inspect `READY` column):

```
$ kubectl -n default get pods
NAME                                        READY   STATUS    RESTARTS   AGE
adservice-v1-56bbbd9bb9-hfmxw               2/2     Running       0          15m
cartservice-v1-79c46c8d45-zmjjn             2/2     Running       2          15m
checkoutservice-v1-f6c695857-k8mxx          2/2     Running       0          15m
currencyservice-v1-697b4c8f99-mwbjz         2/2     Running       0          15m
emailservice-v1-645bd47fc9-chbht            2/2     Running       0          16m
emailservice-v2-646bd95f7b-5bh25            2/2     Running       0          16m
frontend-v1-69875769bf-n7wct                2/2     Running       0          15m
loadgenerator-6bf9fd5bc9-2d778              2/2     Running       3          15m
paymentservice-v1-868dff5bbb-slkcv          2/2     Running       0          15m
productcatalogservice-v1-79b8ddc995-skss5   2/2     Running       0          15m
productcatalogservice-v2-7dc5d96f5d-jcgr6   2/2     Running       0          11m
recommendationservice-v1-f47c98849-p2nvh    2/2     Running       0          15m
redis-cart-v1-65b44b7949-rszpq              2/2     Running       0          15m
shippingservice-v1-5fff674495-pkcdd         2/2     Running       0          15m
shippingservice-v2-6fc7489bdb-tnp2v         2/2     Running       0          72s
shippingservice-v3-677b68d6bf-jmnjc         2/2     Running       0          71s
```

Note that some application services are deployed in multiple versions, for instance, `emailservice`
and `shippingservice`.
