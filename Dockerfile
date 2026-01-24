FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:fc3ac77e66d80f7606be20d9a96a7f926e60b6f5281271bad4ae22b13728628e

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > \
        /etc/apt/sources.list.d/antigravity.list && \
        curl -fsSO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends \
        antigravity \
        bash-completion \
        git \
        gnome-keyring \
        make \
        openssh-client \
        ./google-chrome-stable_current_amd64.deb \
        && \
    apt-get remove -y -q \
        mate-power-manager \
        && \
    apt-get autoremove -y -q && \
    rm -rf \
        /var/lib/apt/lists/* \
        google-chrome-stable_current_amd64.deb

# Silence ALSA warnings by creating a dummy configuration
RUN echo -e 'pcm.!default { type null } \nctl.!default { type null }' > /etc/asound.conf

USER $NB_USER

RUN mamba install --yes --freeze-installed \
        go-cgo \
        kubernetes-client \
        kubernetes-helm \
        stern \
        && \
    mamba clean --all

COPY --chown=$NB_UID:$NB_GID antigravity.desktop "$HOME_TEMPLATE_DIR/Desktop"
