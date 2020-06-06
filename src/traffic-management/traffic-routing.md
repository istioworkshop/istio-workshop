# Traffic routing

*This chapter presents how to configure routing between services in the mesh.*

## Outline

In this chapter you will learn:

* What are `DestinationRule` and `VirtualService` policies.
* How to route the traffic to a specific service version.

## Walkthrough

### Route traffic to a specific app version

Open the Kiali dashboard:

```
$ istioctl dashboard kiali
```

Then, switch to the graph view and select `Versioned app graph` type from the graph dropdown. It should display a similar structure:

![](/assets/images/traffic-routing-1.png)

Note that due to multiple versions of some application services, traffic is distributed to all versions using Round Robin balancing algorithm. In case, each service version implements different business logic, balancing traffic to all versions can potentially lead to undesirable side effects and harm user experience. Typically, we should strive to handle user traffic only through one version of the service.

Let's start with the `shippingservice`.

First, inspect the `shippingservice` deployments:

```
$ kubectl -n default describe deploy shippingservice-v1
```

```yaml
Name:                   shippingservice-v1
Namespace:              default
...
Pod Template:
  Labels:  app=shippingservice
           version=v1
...
```

```
$ kubectl -n default describe deploy shippingservice-v2
```

```yaml
Name:                   shippingservice-v2
Namespace:              default
...
Pod Template:
  Labels:  app=shippingservice
           version=v2
...
```

Note that pods produced by these deployments have labels determining the service version: `version=v1` and `version=v2`.

In order to enforce routing the user traffic to version `v1` of the `shipping` service, apply the `DestinationRule` and `VirtualService` policies:

```
$ kubectl -n default apply -f ./release/istio/shippingservice-dr.yaml
destinationrule.networking.istio.io/shippingservice created
$ kubectl -n default apply -f ./release/istio/shippingservice-vs.yaml
virtualservice.networking.istio.io/shippingservice created
```

The former policy specifies named service subsets which group service instances by version:

```
$ kubectl -n default describe dr shippingservice
```

```yaml
Name:         shippingservice
Namespace:    default
...
Spec:
  Host:  shippingservice
  Subsets:
    Labels:
      Version:  v1
    Name:       v1
    Labels:
      Version:  v2
    Name:       v2
    Labels:
      Version:  v3
    Name:       v3
```

The latter, uses the defined service subsets to route the traffic to the proper service version:

```
$ kubectl -n default describe vs shippingservice
```

```yaml
Name:         shippingservice
Namespace:    default
...
Spec:
  Hosts:
    shippingservice
  Http:
    Route:
      Destination:
        Host:    shippingservice
        Subset:  v1
```

After applying the policies, the traffic should be routed only to the version `v1` of the `shipping` service:

![](/assets/images/traffic-routing-2.png)

The service node in the graph should be marked with a purple virtual service icon.

## Exercises

1. Apply `DestinationRule` and `VirtualService` policies to all services deployed in the service mesh. Regardless of how many versions a given service provides, it is a good practice to configure the proper service routing for each service.

2. Route `productcatelog` traffic to version `v2`.

