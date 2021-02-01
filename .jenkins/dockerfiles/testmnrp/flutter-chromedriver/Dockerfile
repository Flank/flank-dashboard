FROM cirrusci/flutter:1.22.3

RUN DEBIAN_FRONTEND=noninteractive \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb unzip wget gettext-base\
    && CHROME_DRIVER_VERSION=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P / \
    && unzip /chromedriver_linux64.zip -d / \
    && rm -f /chromedriver_linux64.zip \
    && mv /chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/platform-platform/monorepo/releases/download/coverage-converter-snapshot/coverage_converter_linux -O /usr/local/bin/coverage_converter \
    && chmod a+x /usr/local/bin/coverage_converter

RUN wget -N https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -O /usr/local/bin/ci_integrations \
    && chmod +x /usr/local/bin/ci_integrations \
