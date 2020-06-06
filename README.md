# Istio Workshop

This repository contains the source code for the Istio Workshop website.

The website is built using Gitbook site generator and is currently hosted on Github pages. The full
rendered version of the static content is available in the
[istioworkshop.github.io](https://github.com/istioworkshop/istioworkshop.github.io) repository.

## Setup

Install Gitbook:

```bash
$ npm install gitbook-cli -g
```

Load website submodule:

```bash
$ git submodule update --init --recursive
```

Run Gitbook server:

```bash
$ gitbook serve
```

## Deployment

In order to deploy rendered content to Github pages, run:

```bash
$ ./deploy.sh
```
