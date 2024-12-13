FROM debian:latest
WORKDIR /render

ARG TAILSCALE_VERSION
ENV TAILSCALE_VERSION=$TAILSCALE_VERSION

# Install necessary packages
RUN apt-get -qq update \
  && apt-get -qq install --upgrade -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    netcat-openbsd \
    wget \
    dnsutils \
    python3 \
  > /dev/null \
  && apt-get -qq clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && :

# Configure .digrc for DNS debugging
RUN echo "+search +short" > /root/.digrc

# Copy scripts
COPY run-tailscale.sh /render/
COPY install-tailscale.sh /tmp

# Install Tailscale
RUN /tmp/install-tailscale.sh && rm -r /tmp/*

# Add a simple health check server
COPY health_check.py /render/

# Expose port for health check
EXPOSE 80

# Run Tailscale and health check server
CMD ./run-tailscale.sh & python3 /render/health_check.py
