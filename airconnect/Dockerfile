ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
FROM ${BUILD_FROM}

# AirConnect-Version pinnen — bei Updates hier bumpen (+ config.yaml Version)
ARG AIRCONNECT_VERSION=1.10.1

# Statische Binaries aus dem Release-ZIP holen (Alpine = musl, daher -static Pflicht)
RUN apk add --no-cache curl unzip \
    && APK_ARCH="$(apk --print-arch)" \
    && case "${APK_ARCH}" in \
         x86_64)  AC_ARCH="x86_64" ;; \
         aarch64) AC_ARCH="aarch64" ;; \
         armv7)   AC_ARCH="arm" ;; \
         armhf)   AC_ARCH="armv5te" ;; \
         *) echo "Nicht unterstützte Architektur: ${APK_ARCH}" && exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/airconnect.zip \
         "https://github.com/philippe44/AirConnect/releases/download/${AIRCONNECT_VERSION}/AirConnect-${AIRCONNECT_VERSION}.zip" \
    && unzip -oq /tmp/airconnect.zip -d /tmp/airconnect \
    && AIRCAST_BIN="$(find /tmp/airconnect -type f -name "aircast-linux-${AC_ARCH}-static" | head -n1)" \
    && AIRUPNP_BIN="$(find /tmp/airconnect -type f -name "airupnp-linux-${AC_ARCH}-static" | head -n1)" \
    && test -n "${AIRCAST_BIN}" || { echo "aircast-Binary für ${AC_ARCH} nicht im ZIP gefunden:"; find /tmp/airconnect -name "aircast-linux-*" ; exit 1; } \
    && test -n "${AIRUPNP_BIN}" || { echo "airupnp-Binary für ${AC_ARCH} nicht im ZIP gefunden:"; find /tmp/airconnect -name "airupnp-linux-*" ; exit 1; } \
    && install -m 755 "${AIRCAST_BIN}" /usr/bin/aircast \
    && install -m 755 "${AIRUPNP_BIN}" /usr/bin/airupnp \
    && rm -rf /tmp/airconnect.zip /tmp/airconnect \
    && apk del unzip

COPY rootfs /

RUN chmod a+x /etc/services.d/aircast/run \
    && chmod a+x /etc/services.d/airupnp/run
