ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
FROM ${BUILD_FROM}

# Install Node.js 22 LTS and ttyd
RUN apk add --no-cache \
    nodejs \
    npm \
    ttyd \
    tmux \
    git \
    curl \
    jq \
    python3 \
    bash \
    smartmontools \
    util-linux \
    iproute2 \
    ntfs-3g \
    ntfs-3g-progs \
    exfatprogs \
    btrfs-progs \
    xfsprogs \
    e2fsprogs \
    e2fsprogs-extra \
    udisks2 \
    hdparm \
    attr \
    eudev \
    hwids-udev \
    findmnt \
    blkid \
    lsblk

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code@latest

# Copy addon files
COPY rootfs /

RUN chmod a+x /etc/services.d/ttyd/run \
    && chmod a+x /etc/services.d/ttyd/finish \
    && chmod a+x /usr/local/bin/claude-ha-wrapper.sh
