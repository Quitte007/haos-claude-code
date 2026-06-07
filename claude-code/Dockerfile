ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
FROM ${BUILD_FROM}

# Install Node.js 22 LTS and ttyd
RUN apk add --no-cache \
    nodejs \
    npm \
    ttyd \
    git \
    curl \
    jq \
    python3 \
    bash

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code@latest

# Copy addon files
COPY rootfs /

RUN chmod a+x /etc/services.d/ttyd/run \
    && chmod a+x /etc/services.d/ttyd/finish \
    && chmod a+x /usr/local/bin/claude-ha-wrapper.sh
