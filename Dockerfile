FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:fc3ac77e66d80f7606be20d9a96a7f926e60b6f5281271bad4ae22b13728628e

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > \
        /etc/apt/sources.list.d/antigravity.list && \
    apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends \
        antigravity \
        openssh-client \
        && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN ln -s \
        /usr/share/applications/antigravity.desktop \
        "$HOME_TEMPLATE_DIR/Desktop"

RUN mamba install --freeze-installed \
        go-cgo \
        kubernetes-client \
        kubernetes-helm \
        make \
        stern \
        && \
    mamba clean --all
