# demo-connector

A one-node Kubernetes cluster on a GCP VM running Prometheus, a synthetic
workload worth watching, and the [Vedavid
connector](https://github.com/vedavid-dev/connector) answering queries about
it.

It is the cluster behind Vedavid's own demo, and it is meant to be run by
anyone: clone it, name a project, apply.

## What you get

- A Spot `e2-medium` with a stateful boot disk, so Prometheus keeps its
  history across preemptions.
- k3s, with Flux reconciling everything else from this repository.
- Prometheus, scraping [rust-k8s-demo](https://github.com/caulagi/rust-k8s-demo):
  an HTTP frontend, a gRPC quotation service, Postgres and a Redis cache, all
  exporting metrics, driven by a load generator that varies traffic on a
  ~5 minute cycle.
- The connector, dialling out to the relay. Nothing listens on the internet.

## Prerequisites

- An existing GCP project with billing enabled. This configuration never
  creates a project and never touches billing.
- `gcloud auth application-default login`, with rights to enable services and
  create compute and IAM resources in that project.
- OpenTofu 1.8 or newer.

## Stand it up

```sh
git clone https://github.com/vedavid-dev/demo-connector
cd demo-connector
tofu init
tofu apply -var project=your-project-id
```

State is local by default. To keep it in GCS instead, add a `backend "gcs"`
block to `versions.tf` and re-run `tofu init`.

The node takes a few minutes to install k3s, install Flux, and reconcile. Find
it with the command the apply prints:

```sh
tofu output -raw find_instance_command
```

## Give the connector a token

The connector enrols with a token you create in the Vedavid admin console. Until
that Secret exists the cluster runs fine and the connector crash-loops saying so
— it is the one step this repository cannot do for you.

Write the token to a file rather than passing it on the command line, where it
would land in your shell history:

```sh
kubectl --namespace vedavid create secret generic vedavid-enrolment-token \
  --from-file=token=./enrolment-token.txt
```

The `vedavid` namespace is created by Flux, so wait for the first reconcile.

## Reaching the cluster

The firewall allows SSH only from Google's IAP range, and nothing else inbound
from anywhere:

```sh
gcloud compute ssh <instance> --tunnel-through-iap --project your-project-id
sudo k3s kubectl get pods -A
```

## What it costs

Roughly **$12–15 a month** in your own project, at the defaults: a Spot
`e2-medium` (~$7), a 40 GB `pd-balanced` boot disk (~$4), and one in-use
ephemeral external IPv4 (~$2). Spot pricing varies by region and over time, and
preemption is a normal event here rather than an incident.

`tofu destroy` removes everything except the boot disk, which the stateful
policy deliberately keeps — delete it by hand when you are done.

## Layout

| | |
| --- | --- |
| `modules/cluster/` | the GCE footprint; usable on its own from another root |
| `clusters/demo/` | what Flux reconciles, and where it reads it from |
| `connector/` | the connector's HelmRelease and its dashboards |
| `monitoring/` | Prometheus |
| `workload/` | the rust-k8s-demo services, their data stores and the load generator |

Flux follows `main`, so a merge reaches the cluster on the next poll. Point
`git_repository_url` at a fork to run your own manifests.
