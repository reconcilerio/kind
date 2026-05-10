ARG image ca name
FROM ${image}
COPY ${ca} /usr/local/share/ca-certificates/reconcilerio-registry-${name}.crt
RUN update-ca-certificates
