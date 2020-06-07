# Analyze request traces in Jaeger

*This chapter introduces the concept of Distributed Tracing and presents how to analyze request
traces using the Jaeger Istio addon.*

## Outline

In this chapter you will learn:

* What is *Distributed Tracing* and how it works.
* How to access the Jaeger dashboard.
* How to search request traces.
* How to analyze trace spans and span context.
* How to switch between trace representations.

## Walkthrough

Distributed tracing is a method used to profile and monitor distributed applications, especially those built using the microservices architecture.

Requests in microservice-based applications often span multiple services. Each service handles a request by performing one or more nested operations, for instance, database queries or call to another service. In case something goes wrong, it is challenging to locate the failure in a large network of services. Similarly, it is difficult to identify a service that introduces a bottleneck (e.g., latency) in a long chain of interacting services.

Tools such as [Jaeger](https://www.jaegertracing.io/) or [Zipkin](https://zipkin.io/) compliant with [OpenTracing](https://opentracing.io/) standard help operators to analyze the request execution throughout the application.

In a nutshell, each initiated request is assigned with a unique request ID. The ID is propagated in request headers between services handling the request. Each service on the request path extracts the ID from the header, creates its request span by adding related context information, and sends the span to the local agent. The agent, in turn, groups spans by the request ID and forwards the aggregated data to the collector. The collector performs the final construction of the request trace.

![](/assets/images/jaeger-traces-and-spans.png)

In order to instrument the span generation and delivery to the agent, the application must use a dedicated tracing library. The library poses a need for implementation in a specific programming language, as well as requires configuration and development effort.

![](/assets/images/jaeger-architecture.png)

Thanks to the Istio proxy, applications gain distributing tracing capability without using a tracing library. The proxy by participating in all inter-service communication takes over the responsibility for the entire tracing flow.

### Access the dashboard

Port-forward the Jaeger dashboard to your local machine:

```
$ istioctl dashboard jaeger
```

Your browser should startup automatically and display the dashboard. Otherwise, visit the address:
http://localhost:16686.

### Analyze request traces

Search traces from the last hour for the `frontend` service. Limit the results to 30 traces:

![](/assets/images/jaeger-trace-search.png)

The results should be similar to:

![](/assets/images/jaeger-trace-results.png)

The plot at the top presents the clustered histogram of request traces over time. Below, Jaeger
presents a list of captured request traces.

Trace represents a complete request path through the application (i.e., multiple microservices). It
is composed of request spans reported by individual application services. Each span informs how much
time a given service spent on processing the request and what was the request result (success or
error).

That way we can easily infer which service introduces a bottleneck (e.g., high latency) or which
service causes a failure in a large application.

Let's inspect an arbitrary trace of length >1:

![](/assets/images/jaeger-sample-trace-1.png)

The above example ilustrates trace of a request handled by two services: the `frontend` service
calls the `productcatalog` service. The entire request took `1.33ms` to complete, but `0.57ms` of
the request was handled by the `productcatalog` service.

Now, click on the `frontend` span to reveal the context information:

![](/assets/images/jaeger-sample-trace-2.png)

*Istio proxy* running in each application pod enhances request spans with rich context
information:

* content type,
* HTTP method,
* HTTP protocol,
* HTTP status code,
* request URL,
* request size,
* user agent.

These data can be useful for debugging the particular microservice identified as anomalous.

Note that without a proxy, the application would have to build the span (retrieve trace ID from
request headers, inject context information) and sent it to the span collector on its own. That
requires using a tracing library compatibile with application programming language.

Since the proxy participates in all communication between services, it can offload the application
from the tracing function. The tracing is transparent for the application and requires no
configuration.

Lastly, switch to the graph representation of the trace:

![](/assets/images/jaeger-sample-trace-3.png)
![](/assets/images/jaeger-sample-trace-4.png)

The graph view enables you to inspect complex request traces consisting of many nested spans.


## Exercises

1. Describe three distinct request paths from `checkout` service to other services. Include:

    * when the request started (date, time),
    * total request duration,
    * request protocol, method and status code,
    * duration of nested span.

