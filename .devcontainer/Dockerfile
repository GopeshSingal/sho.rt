FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*


ARG TERRAFORM_VERSION=1.9.8

RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip


RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


WORKDIR /workspace


RUN pip install --upgrade pip
