# kind/logs action  <!-- omit in toc -->

Export and upload logs for a kind cluster.

- [Usage](#usage)
  - [Outputs](#outputs)

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

    # Optional artifact-name.
    # Name of the uploaded artifact. Recommended when this action is used more than once in the same workflow.
    # Default: 'kind-logs'
    artifact-name: 'kind-logs'
```
<!-- end usage -->

**Basic**

```yaml
steps:
- name: Run cluster
  uses: reconcilerio/kind@v1
...
- name: Collect cluster logs
  uses: reconcilerio/kind/logs@v1
```

### Outputs

- **`logs-dir`** directory containing the exported logs
