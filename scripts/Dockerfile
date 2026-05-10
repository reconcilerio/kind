ARG image registry ca name
FROM ${image}
COPY ${ca} /usr/local/share/ca-certificates/reconcilerio-registry-${name}.crt
RUN mkdir -p /etc/containerd/certs.d/${registry} \
    && cp /usr/local/share/ca-certificates/reconcilerio-registry-${name}.crt /etc/containerd/certs.d/${registry}/ca.pem \
    && echo "server = \"https://${registry}\"" > /etc/containerd/certs.d/${registry}/hosts.toml \
    && echo "" > /etc/containerd/certs.d/${registry}/hosts.toml \
    && echo "[host.\"https://${registry}\"]" > /etc/containerd/certs.d/${registry}/hosts.toml \
    && echo "  capabilities = [\"pull\"]" > /etc/containerd/certs.d/${registry}/hosts.toml \
    && echo "  ca = \"/etc/containerd/certs.d/${registry}/ca.pem\"" > /etc/containerd/certs.d/${registry}/hosts.toml \
    && echo "" > /etc/containerd/config.toml \
    && echo "[plugins.\"io.containerd.grpc.v1.cri\".registry]" > /etc/containerd/config.toml \
    && echo "  config_path = \"/etc/containerd/certs.d\"" > /etc/containerd/config.toml \
    && update-ca-certificates
