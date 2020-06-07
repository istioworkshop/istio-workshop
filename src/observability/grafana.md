# Inspect service metrics in Grafana

*This chapter presents how to monitor service mesh traffic using the Grafana Istio addon.*

## Outline

In this chapter you will learn:

* How to access the Grafana dashboard.
* How to analyze service mesh traffic globally.
* How to analyze traffic for a particular application service.
* How to monitor the operation of individual components in Istio control plane.

## Walkthrough

Most of the service mesh metrics are collected through the presence of a sidecar proxy installed in each application pod.

Each proxy generates a rich set of metrics describing the inbound and outbound traffic passing through the proxy. They also provide detailed statistics about the administrative functions of the proxy itself, including configuration and health information.

In addition, Istio provides a set of aggregated service-oriented metrics for monitoring inter-service communication. These metrics cover the four fundamental service health indicators: latency, traffic, errors, and saturation.

The Istio control plane also provides a collection of self-monitoring metrics. These metrics allow monitoring the behavior of Istio itself.

### Access the dashboard

Port-forward the Grafana dashboard to your local machine:

```
$ istioctl dashboard grafana
```

Your browser should startup automatically and display the dashboard. Otherwise, visit the address:
http://localhost:3000.

### Analyze mesh dashboard

Navigate to the [**Mesh Dashboard**](http://localhost:3000/d/G8wLrJIZk/istio-mesh-dashboard). It
should look similar to:

![](/assets/images/grafana-mesh-dashboard-1.png)

The dashboard provides the global view of the service mesh:

* total number of discovered services,
* global request volume expressed in *operations per second* (ops),
* global success rate - percentage of requests completed with success,
* total failed requests - number of requests ended with 4xx and 5xx HTTP error codes.

In addition, the dashboard provides essential metrics for the discovered services:

* operations per second,
* p50, p90, p99 latency,
* success rate.

### Analyze service dashboard

Navigate to the [**Service Dashboard**](http://localhost:3000/d/LJ_uJAvmk/istio-service-dashboard)
and pick the `productcatalog` service from the *Service* dropdown.

The dashboard should look similar to:

![](/assets/images/grafana-service-dashboard-1.png)
![](/assets/images/grafana-service-dashboard-2.png)

The dashboard provides detailed metrics for the selected service:

* client/server request volume,
* client/server success rate,
* client/server request duration,
* incoming requests by source,
* incoming success rate by source,
* incoming request duration by source,
* incoming request size by source,
* TCP received/sent bytes (only for raw TCP traffic).

Note that you can use the *Service* dropdown to switch between inspected services. Moreover, you can
view the metrics in the context of a particular service client by using the *Client workload*
dropdown.

### Analyze Pilot dashboard

Navigate to the
[**Pilot Dashboard**](http://localhost:3000/d/3--MLVZZk/istio-pilot-dashboard?orgId=1&refresh=5m).

It provides metrics related to Istio Pilot component deployed in the Istio control plane.

The first part of the dashboard describes the usage of system resources (CPU, memory, disk):

![](/assets/images/grafana-pilot-dashboard-1.png)

The second part presents metrics specific to Pilot operation, for instance:

* Pilot pushes - frequency of configuration distribution to sidecar proxies,
* Pilot errors - number of errors encountered during configuration rendering and distrubution,
* Proxy push time - time needed to synchronize configuration to a proxy.

![](/assets/images/grafana-pilot-dashboard-2.png)

Note, each component in the control plane provides a similar monitoring dashboard:

![](/assets/images/grafana-all-dashboards.png)

Inspect them to identify what metrics are avilable for Galey, Citadel and Mixer.

## Exercises

Use the presented Grafana dashboards to answer the following questions:

1. How many ops are being currently processed by the application?
2. What is the global success rate?
3. Are there any request errors occurring in the application at the moment? How do you check that?
4. Which application service processes the most requests? What is its p99 latency and success rate?
5. What is the current CPU and memory usage by Istio Pilot?
6. Does Istio Pilot encouteres any errors at the moment?
