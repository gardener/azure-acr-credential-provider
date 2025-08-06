FROM curlimages/curl:8.15.0 AS downloader

ARG TARGETARCH=amd64

RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/cloud-provider-azure/releases/latest | \
    grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    echo "Latest version: $LATEST_VERSION" && \
    curl -L -o /tmp/azure-acr-credential-provider \
    https://github.com/kubernetes-sigs/cloud-provider-azure/releases/download/$LATEST_VERSION/azure-acr-credential-provider-linux-$TARGETARCH && \
    chmod +x /tmp/azure-acr-credential-provider

FROM scratch

COPY --from=downloader /tmp/azure-acr-credential-provider /bin/azure-acr-credential-provider

ENTRYPOINT ["/bin/azure-acr-credential-provider"]
