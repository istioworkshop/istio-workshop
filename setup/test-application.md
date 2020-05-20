# Deploy test application

## Outline

In this chapter you will learn:

* How to install the test application.
* How to verify the installation.

## Walkthrough

For the purpose of this workshop we will use the test application
[**Online Boutique**](https://github.com/GoogleCloudPlatform/microservices-demo) (previously: Hipster
Shop) to evaluate several service mesh scenarios.

Online Boutique is a cloud-native microservices demo application. It consists of 10 microservices
that implement a web-based e-commerce app where users can browse items, add them to the cart, and
purchase them:

**TODO:** Add screenshot from app

The application architecture is presented below:

![](/assets/images/test-app-architecture.png)

### Install the app

Start with enabling the sidecar injection for the `default` namespace:

```
$ kubectl label namespace default istio-injection=enabled
```

The `istio-injection` label informs Istio Sidecar Injector running in Istio control plane to inject
a sidecar into each new pod created in the `default` namespace. Sidecars running alongside
application services are responsible for processing the traffic entering and leaving the pods. They
act as local proxies capable of enforcing the requested traffic policies. Sidecars are the key
building block required to form a service mesh.

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

Apply Istio manifests:

```
$ kubectl -n default apply -f ./release/istio-manifests.yaml
```

That will apply initial service mesh configuration:

```
gateway.networking.istio.io/frontend-gateway created
virtualservice.networking.istio.io/frontend-ingress created
virtualservice.networking.istio.io/frontend created
serviceentry.networking.istio.io/whitelist-egress-googleapis created
serviceentry.networking.istio.io/whitelist-egress-google-metadata created
```

**TODO:** Describe the applied policies

### Verify installation
