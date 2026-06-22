# kind/cloud-provider-kind action  <!-- omit in toc -->

Install and run cloud-provider-kind.

## Usage

See [action.yml](action.yml)

<!-- start usage -->
```yaml
- uses: reconcilerio/kind/cloud-provider-kind@v1
  with:
    # Optional version.
    # Version of cloud-provider-kind.
    # Default: 'latest'
    version: 'latest'
```
<!-- end usage -->

**Basic**

```yaml
steps:
- name: Run cluster
  uses: reconcilerio/kind@v1
- uses: reconcilerio/kind/cloud-provider-kind@v1
```
