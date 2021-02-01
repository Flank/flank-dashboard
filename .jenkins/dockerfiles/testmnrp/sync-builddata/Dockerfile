FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y wget gettext-base \
    && wget -N https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -O /usr/local/bin/ci_integrations \
    && chmod +x /usr/local/bin/ci_integrations \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
