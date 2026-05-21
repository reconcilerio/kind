# kind action  <!-- omit in toc -->

[![CI](https://github.com/reconcilerio/kind/actions/workflows/ci.yaml/badge.svg)](https://github.com/reconcilerio/kind/actions/workflows/ci.yaml)

Starts a secure, trusted OCI registry for a GitHub Actions workflow. The nuscenes of creating and trusting certificates, or allowing clients to run insecurely is avoided.

- [Usage](#usage)
  - [Outputs](#outputs)
- [Nested actions](#nested-actions)
- [Community](#community)
  - [Code of Conduct](#code-of-conduct)
  - [Communication](#communication)
  - [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)
- [License](#license)

## Usage

See [action.yml](action.yml)

<!-- start usage -->
```yaml
- uses: reconcilerio/registry@v1
  with:
    # Optional cluster-name.
    # Name of kind cluster.
    # Default: 'kind'
    cluster-name: 'kind'

    # Optional kind-version.
    # Version of the kind CLI to install.
    # Default: latest stable
    kind-version: ''

    # Optional kubernetes-version.
    # Version of Kubernetes for the cluster. May be a tag that resolves to an image in the ghcr.io/reconcilerio/kind/node repository, or a fully qualified image. Tags match upstream kubernetes release versions, typically matching `v{MAJOR}.{MINOR}.{PATCH}` with an alias of `v{MAJOR.{MINOR}` to the latest patch for the minor line.
    # For example 'v1.33' maps to 'v1.33.11' and the fully qualified image 'ghcr.io/reconcilerio/kind/node:v1.33.11'.
    # Default: latest stable
    kubernetes-version: ''

    # Optional registry.
    # Coordinates for a local OCI registry. Often specified in conjunction with a CA certificate.
    # Default: none
    registry: ''

    # Optional registry-ca.
    # Path to the CA certificate for the registry. This cluster is configured to trust this certificate for operations against the registry.
    # Default: none
    registry-ca: ''
```
<!-- end usage -->

**Basic**
```yaml
steps:
- uses: reconcilerio/kind@v1
```

Starts a kind cluster with a recent, stable Kubernetes.

**With registry:**

```yaml
steps:
- uses: reconcilerio/registry@v1
  id: registry
- uses: reconcilerio/kind@v1
  with:
    kubernetes-version: v1.36
    registry: ${{ steps.registry.outputs.registry }}
    registry-ca: ${{ steps.registry.outputs.tls-ca }}
```

Starts a kind cluster configured to use a local  OCI registry with a generated certificate that is trust by the job VM and the kind cluster.

Images can be pushed to the registry (defined by `${{ steps.registry.outputs.registry }}`, defaulting to `registry.local`), and pulled for pods within the cluster. Direct, programmatic access to the registry from within a running container will likely require propagating the CA certificate to that container in a way it understands.

### Outputs

- **`context`** kubernetes context for this cluster.
- **`kubernetes-version`** running kubernetes version as reported by the cluster. Multi-node clusters will produce a new line separated list with an line for each control-plane node.

## Nested actions
- [`reconcilerio/kind/logs`](./logs/) Export and upload logs for a kind cluster

## Community

### Code of Conduct

The reconciler.io projects follow the [Contributor Covenant Code of Conduct](./CODE_OF_CONDUCT.md). In short, be kind and treat others with respect.

### Communication

General discussion and questions about the project can occur either on the Kubernetes Slack [#reconcilerio](https://kubernetes.slack.com/archives/C07J5G9NDHR) channel, or in the project's [GitHub discussions](https://github.com/orgs/reconcilerio/discussions). Use the channel you find most comfortable.

### Contributing

The reconciler.io project team welcomes contributions from the community. A contributor license agreement (CLA) is not required. You own full rights to your contribution and agree to license the work to the community under the Apache License v2.0, via a [Developer Certificate of Origin (DCO)](https://developercertificate.org). For more detailed information, refer to [CONTRIBUTING.md](CONTRIBUTING.md).

## Acknowledgements

The basic ideas that manifest in this action originated as a pile of bash scripts in the [Service Bindings for Kubernetes](https://github.com/servicebinding/runtime) runtime project, among others.

## License

Apache License v2.0: see [LICENSE](./LICENSE) for details.
