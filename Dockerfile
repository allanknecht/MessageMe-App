FROM ruby:2.5.9

# Fix Debian Buster archive repositories (Buster is archived)
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    curl \
    gnupg \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Node 12 directly from official binaries
RUN NODE_VERSION=12.22.12 && \
    curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz -o node.tar.xz && \
    tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
    rm node.tar.xz && \
    node --version && \
    npm --version

# Install Yarn 1.x via npm
RUN npm install -g yarn@1.22.19 && \
    yarn --version

# Install bundler (needed for rails new and project setup)
RUN gem install bundler -v 1.17.3

# Install Rails 5.1.6 without dependencies (dependencies will be managed by bundler)
# This allows 'rails new' command to work
RUN gem install rails -v 5.1.6 --ignore-dependencies

# Set working directory
WORKDIR /app

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
