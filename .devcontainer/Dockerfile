FROM range3/dev-cpp:master

USER root
RUN \
  # Common packages
  export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get -y install --no-install-recommends \
    libssl-dev \
    perl \
    python3 \
    python3-pip \
    python3-venv \
    libopenmpi-dev \
    ffmpeg \
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN \
  pip3 install --upgrade --no-cache-dir pip \
  && pip3 install --no-cache-dir \
    jinja2 \
    Pygments \
    ipykernel \
    matplotlib \
    pandas

USER vscode
