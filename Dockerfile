FROM debian:buster

LABEL maintainer "mmercuri"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    unzip \
    unrar-free \
    curl \
    wget \
    openssl \
    ca-certificates \
    python3 \
    python3-pip \
    python3-dev \
    python3-yaml \
    python3-virtualenv \
    virtualenvwrapper \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libssl-dev \
    jq \
    ssh \
    rsync \
    git \
    pass \
    gpg \
    qemu-utils \
    sgabios \
    seabios \
    qemu-system\
    qemu-efi\
    qemu-kvm\
    qemu \
    python3-libvirt\
    python3-libqcow\
    libvirt0\
    libncursesw5 \
    gcc \
    python3-setuptools \
    apt-transport-https \
    lsb-release \
    openssh-client \
    gnupg \
    emacs \
    netcat socat kafkacat\
    tmux \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

############################# Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

############################# RClone
RUN wget http://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip -d /usr/bin && \
    rm *.zip

############################# Packer
ARG PACKER_VERSION=1.5.4
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    chmod +x packer && \
    mv packer /usr/bin && \
    rm *.zip

############################# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm *.zip

############################ Yaml Query (Yq)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

############################# Ansible
RUN pip3 install --upgrade \
    setuptools \
    ansible \
    paramiko \
    PyYAML \
    pycrypto \
    pywinrm \
    poetry \
    ansible-lint \
    urllib3  \
    python-dateutil \
    jmespath \
    boto \
    boto3 \
    botocore \
    diagrams

############################# Lego

RUN wget https://github.com/xenolf/lego/releases/download/v2.1.0/lego_v2.1.0_linux_amd64.tar.gz -O lego.tar.gz && \
    tar -zxvf lego.tar.gz && \
    chmod +x lego && \
    mv lego /bin/lego && \
    rm *.tar.gz

######################################################################

#### User setup
RUN useradd --system --uid 1000 -m --shell /usr/bash devops && \
    mkdir -p /home/devops && \
    chown devops /home/devops

USER devops

ENV PATH="/home/devops/.local/bin/:${PATH}"

COPY main.sh /

ENTRYPOINT ["/main.sh"]
CMD ["default"]
