FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

# Outils système
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    ca-certificates \
    gnupg \
    openjdk-21-jre-headless

# Installer Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g firebase-tools \
    && rm -rf /var/lib/apt/lists/*

# Installer FlutterFire CLI
RUN dart pub global activate flutterfire_cli

ENV PATH="/root/.pub-cache/bin:${PATH}"

EXPOSE 8080 4000 9099 8085

CMD ["bash"]