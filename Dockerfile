FROM docker.io/debian:bookworm AS build

ARG KUBECTL_RELEASE
ARG TARGETPLATFORM

RUN apt-get update \
  && apt-get install -y apt-transport-https ca-certificates curl gnupg

WORKDIR /bin

RUN set -x \
  && curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_RELEASE}/bin/${TARGETPLATFORM}/kubectl" \
  && curl -LO "https://dl.k8s.io/release/${KUBECTL_RELEASE}/bin/${TARGETPLATFORM}/kubectl.sha256" \
  && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check \
  && chmod +x kubectl

RUN useradd -u 1000 -U -m kubectl

USER kubectl
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]
